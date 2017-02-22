/bin/bash

# Source this script to build and install a feature branch on BW.

# Set these environment vars appropriately, the rest should just work

export SOURCES_DIR=/u/sciteam/willmore/local/hdf5-1.9.236
export HDF5_INSTALL_DIR=/sw/bw/thg/phdf5-1.9.236_ftw 

# Should not need to edit below here.  

module load autoconf/2.6.9
module unload darshan

# This macro breaks configure, so I just comment it out with this in-place edit:
sed -i -e "s/AM_SILENT_RULES/## AM_SILENT_RULES/" $SOURCES_DIR/configure.ac
# Set some environment stuff that the Cray compiler likes:
export XTPE_LINK_TYPE=dynamic
export RUNPARALLEL="aprun -n 6"
export CXXFLAGS="-DpgiFortran"
export FCFLAGS="-em -dynamic"
export LDFLAGS="-Wl,--no-as-needed,-lm,-lrt,--as-needed"
export CFLAGS="-DCRAYCC -dynamic"
export CRAY_CPU_TARGET="x86-64" 
export CXX="CC"
export FC="ftn"
export CC="cc"
export LIBS="-L${CRAY_MPICH2_DIR}/lib -lmpichf90_cray -lmpich_cray"
# Start the build process in earnest:
./autogen.sh
./configure --prefix=${HDF5_INSTALL_DIR} --enable-fortran --enable-static --with-pic --disable-sharedlib-rpath --with-zlib=/usr/lib64 --enable-parallel --enable-shared --enable-build-mode=production
sed -i -e 's|wl=""|wl="-Wl,"|g' -e 's|pic_flag=" -.PIC"|pic_flag=" -hPIC"|g' libtool
make -j8 install
 
#Load craypkg-gen to make the package and module:
module load craypkg-gen
craypkg-gen -p /sw/bw/thg/phdf5/1.9.236_ftw/
craypkg-gen -m /sw/bw/thg/phdf5/1.9.236_ftw/ 
