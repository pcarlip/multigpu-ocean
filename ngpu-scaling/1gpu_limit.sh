#!/bin/bash

#SBATCH --job-name=1gpu-oc
#SBATCH --partition=dgxh
#SBATCH --exclude=dgxh-1
#SBATCH --cpus-per-task=2
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --time=3:00:00
#SBATCH --output=1gpu.out

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
export JULIA_CUDA_MEMORY_POOL=none
mpiexec -n 1 julia --project=.. ../generic_sim.jl 1gpu_limit.toml
