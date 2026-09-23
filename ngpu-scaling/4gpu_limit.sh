#!/bin/bash

#SBATCH --job-name=4gpu-oc
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:4
#SBATCH --time=6:00:00
#SBATCH --output=4gpu.out

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
export JULIA_CUDA_MEMORY_POOL=none
mpiexec -n 4 julia --project=.. ../generic_sim.jl 4gpu_limit.toml
