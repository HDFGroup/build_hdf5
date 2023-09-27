#!/bin/bash
##
## Usage: sbatch j_pe.slurm
## Author: Hyokyung Lee (hyoklee@hdfgroup.org)
## Last Update: 2023-09-19
##
#SBATCH -A m2621
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -J h5
#SBATCH -o %x-%j.out
#SBATCH -t 01:00:00
#SBATCH -N 6
#SBATCH --ntasks-per-node=6

srun -N1 -n1 /global/homes/h/hyoklee/src/hpc-h5/bin/j_pe.sh
