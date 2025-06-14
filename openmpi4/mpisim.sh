#!/bin/bash

#SBATCH --job-name=mpisim
#SBATCH --partition=ceoas-gpu
#SBATCH --nodelist=aerosmith
#SBATCH --cpus-per-task=6
#SBATCH --mem=100000
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --gres=gpu:2
#SBATCH --time=3-00:00:00
#SBATCH --output=mpisim.out

spack load openmpi@4.1.6+cuda arch=linux-rocky9-sandybridge

which mpiexec

export UCX_WARN_UNUSED_ENV_VARS=n

export JULIA_NUM_THREADS=1

mpiexec -n 2 julia --project mpisim.jl
