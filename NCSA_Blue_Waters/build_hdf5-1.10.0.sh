#!/bin/bash
#   ___  __           _      __     __
#  / _ )/ /_ _____   | | /| / /__ _/ /____ _______
# / _  / / // / -_)  | |/ |/ / _ `/ __/ -_) __(_-<
#/____/_/\_,_/\__/   |__/|__/\_,_/\__/\__/_/ /___/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Build script to build hdf5 on Blue Waters


# Q's: which 'automake' is used? Does it matter? Not part of pre-install stuff

# PRE: Download and unpack pristine sources to $SOURCES_DIR

###################### Set values for these three environment variables:

# where is the build instructions repo? 
# HINT:  You probably found this script there, maybe one level up
export BW_BUILD_INSTRUCTIONS_DIR=$HOME/local/build_hdf5
# where did you unpack the sources tarball?
export SOURCES_DIR=$HOME/local/hdf5-1.10.0-patch1
# where do you want to install?
export HDF5_INSTALL_DIR=$HOME/local/phdf5-1.10.0-install

###################### Should not need to make changes below here. 

# build directory where package will be assembled
export BUILD_DIR=$SOURCES_DIR/build
mkdir -p $BUILD_DIR
cd $BUILD_DIR
# Need a newer version of autotools, so run pre-install script to install here
. $BW_BUILD_INSTRUCTIONS_DIR/preinstall_hdf5.sh
# add libtool to path
export PATH=`pwd`/util/bin:$PATH
cd $SOURCES_DIR 

# the following line will comment out AM_SILENT_RULES in the resulting 
# configure script, because it's not recognized and hangs autogen
sed -i -e "s/AM_SILENT_RULES/## AM_SILENT_RULES/" $SOURCES_DIR/configure.ac


# Get the modules in order so we have the right environment vars set:
source /opt/modules/default/init/bash
module swap cce cce/8.3.14
module unload cray-libsci atp darshan
module load xpmem dmapp ugni udreg
module swap cray-mpich cray-mpich/7.2.4


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

# This messes up the build, which needs to run a script to generate H5lib_settings.c
# Because build runs on the head node.
# export RUNSERIAL="aprun -q -n 1"
export RUNPARALLEL="aprun -n 6"


# Okay, go do it
./autogen.sh
cd $BUILD_DIR

../configure --prefix=${HDF5_INSTALL_DIR} --enable-parallel --enable-build-mode=production \
             --enable-fortran --enable-static --enable-shared --with-pic \
             --disable-sharedlib-rpath --with-zlib=/usr/lib64 --disable-silent-rules 

#sed -i -e 's|wl=""|wl="-Wl,"|g' -e 's|pic_flag=" -.PIC"|pic_flag=" -hPIC"|g' `which libtool`
sed -i -e 's|wl=""|wl="-Wl,"|g' -e 's|pic_flag=" -.PIC"|pic_flag=" -hPIC"|g' libtool

make -j 8
make install
export LD_LIBRARY_PATH=$SRC/build-hdf5/src/.libs:$LD_LIBRARY_PATH

echo "Done installing to ${HDF5_INSTALL_DIR}. Do remember to run the environment script when building."




