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
module swap cray-mpich cray-mpich/7.2.4
module unload cray-libsci
module load cmake

INSTALL=$HOME/packages/phdf5_1_8_cray

cmake -DCMAKE_INSTALL_PREFIX:STRING=$INSTALL \
      -DBUILD_SHARED_LIBS:BOOL=ON \
      -DBUILD_TESTING:BOOL=ON \
      -DCMAKE_C_COMPILER:FILEPATH=$CRAYPE_DIR/bin/cc \
      -DCMAKE_CXX_COMPILER:FILEPATH=$CRAYPE_DIR/bin/CC \
      -DCMAKE_Fortran_COMPILER:FILEPATH=$CRAYPE_DIR/bin/ftn \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_C_FLAGS:STRING="-dynamic -hPIC -hnoomp" \
      -DCMAKE_CXX_FLAGS:STRING="-dynamic -hPIC -hnoomp" \
      -DCMAKE_Fortran_FLAGS:STRING="-em -J. -dynamic -hnoomp" \
      -DHDF5_BUILD_CPP_LIB:BOOL=OFF \
      -DHDF5_BUILD_EXAMPLES:BOOL=OFF \
      -DHDF5_BUILD_FORTRAN:BOOL=ON \
      -DHDF5_BUILD_HL_LIB:BOOL=ON \
      -DHDF5_BUILD_TOOLS:BOOL=ON \
      -DHDF5_ENABLE_F2003:BOOL=ON \
      -DHDF5_ENABLE_PARALLEL:BOOL=ON \
      -DMPI_LIBRARY:FILEPATH=${CRAY_MPICH2_DIR}/lib/libmpich_cray.so \
      -DMPI_C_LIBRARIES:STRING=${CRAY_MPICH2_DIR}/lib/libmpich_cray.so \
      -DMPI_C_INCLUDE_PATH:STRING=${CRAY_MPICH2_DIR}/include \
      -DMPI_CXX_LIBRARIES:STRING=${CRAY_MPICH2_DIR}/lib/libmpichcxx_cray.so \
      -DMPI_CXX_INCLUDE_PATH:STRING=${CRAY_MPICH2_DIR}/include \
      -DMPI_Fortran_LIBRARIES:STRING=${CRAY_MPICH2_DIR}/lib/libmpichf90_cray.so \
      -DMPI_Fortran_INCLUDE_PATH:STRING=${CRAY_MPICH2_DIR}/include \
      -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON \
      -DZLIB_INCLUDE_DIR:PATH=/usr/include \
      -DZLIB_LIBRARY:FILEPATH=/usr/lib64/libz.so \
      ../source

# make -j8
# make install

