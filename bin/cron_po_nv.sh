#!/usr/bin/bash

. /etc/profile

echo "Hello" > /home/hyoklee/bin/hello_po_nv.txt
module load nvhpc/23.3
module load cmake
d="/lus/grand/projects/CSC250STDM10/hyoklee/hdf5_nv"
cd $d
/home/hyoklee/bin/ckrev
# rc_h5=$?
rc_h5=1
if [ $rc_h5 -eq 1 ]
then   
    rm -rf $d/build
    mkdir $d/build
    cd $d/build
    /home/hyoklee/src/hpc-h5/bin/cmake_nv.sh
    ctest -T Build --output-on-error -j
    cd /home/hyoklee/src/hpc-h5/bin
    qsub j_po_nv.pbs
    sleep 60m && cd $d/build && ctest -T Submit
fi
echo "Hello2" > /home/hyoklee/bin/hello2_po_nv.txt
