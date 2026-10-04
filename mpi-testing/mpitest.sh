#!/bin/bash

#SBATCH --job-name=mpitest
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=10000
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:4
#SBATCH --time=3:00:00
#SBATCH --output=mpitest.out

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
mpiexec -n 4 julia --project=.. mpitest.jl
