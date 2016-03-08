#!/bin/bash
#   ___  __           _      __     __
#  / _ )/ /_ _____   | | /| / /__ _/ /____ _______
# / _  / / // / -_)  | |/ |/ / _ `/ __/ -_) __(_-<
#/____/_/\_,_/\__/   |__/|__/\_,_/\__/\__/_/ /___/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Build script to build hdf5 trunk on Blue Waters

source /opt/modules/default/init/bash
module swap cce cce/8.3.14
module unload cray-libsci atp darshan
module load xpmem dmapp ugni udreg
module swap cray-mpich cray-mpich/7.2.4

SRC="$HOME/packages/hdf5/trunk"
DIR="$HOME/packages/phdf5_trunk_cray"

export XTPE_LINK_TYPE=dynamic
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CRAY_MPICH2_DIR}/lib"
module list
export LIBS="-L${CRAY_MPICH2_DIR}/lib -lmpichf90_cray -lmpich_cray"

export CC="cc"
export FC="ftn"
export CXX="CC"

export CRAY_CPU_TARGET="x86-64" 

export CFLAGS="-DCRAYCC -dynamic"
export LDFLAGS="-Wl,--no-as-needed,-lm,-lrt,--as-needed"
export FCFLAGS="-em -dynamic"
export CXXFLAGS="-DpgiFortran"

export RUNSERIAL="aprun -q -n 1"
export RUNPARALLEL="aprun -q -n 6"

./autogen.sh

mkdir -p build-hdf5 ; cd ./build-hdf5

../configure --prefix=${DIR} --enable-parallel --enable-build-mode=debug \
  --enable-fortran --enable-static --enable-shared \
  --with-pic --disable-sharedlib-rpath --with-zlib=/usr/lib64

sed -i -e 's|wl=""|wl="-Wl,"|g' -e 's|pic_flag=" -.PIC"|pic_flag=" -hPIC"|g' libtool
make -j 8

################################################################################
# IMPORTANT: In order to run 'make check' you need to make sure that RUNSERIAL
# and # RUNPARALLEL are set, AND you initiate the build process from a compute
# node as part of an interactive job, e.g.,
# qsub -I -l nodes=1 -l walltime=01:00:00
################################################################################

export LD_LIBRARY_PATH=$SRC/build-hdf5/src/.libs:$LD_LIBRARY_PATH
make check

make install
