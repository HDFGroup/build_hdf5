#!/bin/bash
echo "Running CTest"
cd /lustre/orion/csc332/scratch/hyoklee/hdf5/build
# cmake .. -D HDF5_ENABLE_PARALLEL:BOOL=ON -D HDF5_BUILD_FORTRAN:BOOL=ON
ctest -T Build --output-on-error -j
ctest -T Test --output-on-error -j

