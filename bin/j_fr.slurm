#!/bin/bash
##
## Usage: sbatch j_fr.slurm
## Author: Hyokyung Lee (hyoklee@hdfgroup.org)
## Last Update: 2023-04-20
##
#SBATCH -A CSC444
#SBATCH -J h5
#SBATCH -o %x-%j.out
#SBATCH -t 00:20:00
#SBATCH -N 2
#SBATCH -S 0
#SBATCH --ntasks-per-node=64
#SBATCH -p batch

#ROMIO HINTS
#export OMPI_MCA_io=romio321
#export ROMIO_HINTS=$HOME/romio_hints
#export romio_cb_write=enable
#export romio_ds_write=enable
#export cb_buffer_size=16777216

export HDF5_USE_FILE_LOCKING=FALSE

srun -N1 -n1 ./j_fr.sh
