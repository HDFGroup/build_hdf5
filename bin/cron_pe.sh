#!/usr/bin/bash

. /etc/profile
. /global/homes/h/hyoklee/.bashrc

echo "Hello" > /global/homes/h/hyoklee/bin/hello.txt
module load nvhpc/23.1

d="/pscratch/sd/h/hyoklee/hdf5"
cd $d
/global/homes/h/hyoklee/src/hpc-h5/bin/ckrev
rc_h5=$?
rc_h5=1
if [ $rc_h5 -eq 1 ]
then
   rm -rf $d/build
   mkdir $d/build
   cd $d/build
   /global/homes/h/hyoklee/src/hpc-h5/bin/cmake_nv_pe.sh
   sbatch /global/homes/h/hyoklee/src/hpc-h5/bin/j_pe.slurm
fi

# To measure time
echo "Hello2" > /global/homes/h/hyoklee/bin/hello2.txt

