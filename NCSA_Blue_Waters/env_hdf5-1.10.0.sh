#!/bin/bash
#   ___  __           _      __     __
#  / _ )/ /_ _____   | | /| / /__ _/ /____ _______
# / _  / / // / -_)  | |/ |/ / _ `/ __/ -_) __(_-<
#/____/_/\_,_/\__/   |__/|__/\_,_/\__/\__/_/ /___/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# set up correct build environment once the library is built

# Get the modules in order so we have the right environment vars set:
source /opt/modules/default/init/bash
module swap cce cce/8.3.14
module unload cray-libsci atp darshan
module load xpmem dmapp ugni udreg
module swap cray-mpich cray-mpich/7.2.4
module list

# this should be set according to your install
export HDF5_INSTALL_DIR=${HOME}/local/phdf5-1.10.0-install

# set up user env vars
export PATH=${HDF5_INSTALL_DIR}/bin:$PATH 
export LD_LIBRARY_PATH=${HDF5_INSTALL_DIR}/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${CRAY_MPICH2_DIR}/lib:$LD_LIBRARY_PATH
export INCLUDE_PATH=${HDF5_INSTALL_DIR}/include:$INCLUDE_PATH 

export XTPE_LINK_TYPE=dynamic
export LIBS="-L${CRAY_MPICH2_DIR}/lib -lmpichf90_cray -lmpich_cray"

export CC="cc"
export FC="ftn"
export CXX="CC"

export CRAY_CPU_TARGET="x86-64" 

export CFLAGS="-DCRAYCC -dynamic"
export LDFLAGS="-Wl,--no-as-needed,-lm,-lrt,--as-needed"
export FCFLAGS="-em -dynamic"
export CXXFLAGS="-DpgiFortran"

