#!/bin/bash

#SBATCH --job-name=2gpu-oc
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --gres=gpu:2
#SBATCH --time=3:00:00
#SBATCH --output=2gpu.out

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
export JULIA_CUDA_MEMORY_POOL=none
mpiexec -n 2 julia --project=.. ../generic_sim.jl 2gpu_limit.toml
