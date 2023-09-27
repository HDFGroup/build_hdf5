#!/usr/bin/bash

. /etc/profile
. /ccs/home/hyoklee/.bashrc

cd /lustre/orion/csc332/scratch/hyoklee/hdf5
OLD_HEAD=$(git rev-parse HEAD)
git pull
NEW_HEAD=$(git rev-parse HEAD)
[ $OLD_HEAD = $NEW_HEAD ] && exit 0
cd /ccs/home/hyoklee/src/hpc-h5/bin
sbatch j_fr.slurm
sleep 1200
cd /lustre/orion/csc332/scratch/hyoklee/hdf5/build && ctest -T Submit
