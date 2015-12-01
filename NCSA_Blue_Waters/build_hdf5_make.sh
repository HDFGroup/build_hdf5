#!/bin/bash
#   ___  __           _      __     __
#  / _ )/ /_ _____   | | /| / /__ _/ /____ _______
# / _  / / // / -_)  | |/ |/ / _ `/ __/ -_) __(_-<
#/____/_/\_,_/\__/   |__/|__/\_,_/\__/\__/_/ /___/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Build script to build hdf5 on Blue Waters

source /opt/modules/default/init/bash
module swap cce cce/8.3.14
module unload cray-libsci atp
module load xpmem dmapp ugni udreg
module swap cray-mpich cray-mpich/7.2.4

DIR="$HOME/packages/phdf5_1_8_cray"

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
export RUNPARALLEL="aprun -n 6"

$HOME/packages/hdf5_1_8/configure \
--prefix=${DIR} --disable-silent-rules --enable-fortran --enable-fortran2003 \
--enable-static --with-pic --disable-sharedlib-rpath --with-zlib=/usr/lib64 --enable-parallel \
--enable-shared --enable-production 

sed -i -e 's|wl=""|wl="-Wl,"|g' -e 's|pic_flag=" -.PIC"|pic_flag=" -hPIC"|g' libtool
make -j 8
make install
