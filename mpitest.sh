#!/bin/bash

#SBATCH --job-name=mpitest
#SBATCH --partition=ceoas-gpu
#SBATCH --nodelist=aerosmith
#SBATCH --cpus-per-task=6
#SBATCH --mem=100000
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:4
#SBATCH --time=3-00:00:00
#SBATCH --output=mpitest.out

spack load openmpi@4.1.6%gcc@13.2.0+cuda arch=linux-rocky9-sandybridge

mpiexec -n 4 julia --project mpitest.jl
