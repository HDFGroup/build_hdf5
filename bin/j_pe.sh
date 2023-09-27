#!/bin/bash
echo "Running CTest"
cd /pscratch/sd/h/hyoklee/hdf5/build
module load nvhpc/23.1
ctest -T Build --output-on-error -j
ctest -T Test --output-on-error -j
ctest -T Submit

