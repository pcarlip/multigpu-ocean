#!/bin/bash

#SBATCH --job-name=NAME
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:4
#SBATCH --time=3:00:00
#SBATCH --output=NAME.out

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
export JULIA_CUDA_MEMORY_POOL=none 
# avoids segfault
# see https://juliaparallel.org/MPI.jl/stable/knownissues/#CUDA-aware-MPI
mpiexec -n 4 julia --project ../generic_sim.jl CONF.toml
# ../generic sim assumes this lives in some subfolder
# replace NAME and CONF as appropriate
