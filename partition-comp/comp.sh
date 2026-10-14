#!/bin/bash

#SBATCH --job-name=part-comp
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:4
#SBATCH --time=5:00:00
#SBATCH --output=part-comp.out
#SBATCH --exclude=dgxh-1

export SCRATCH="/nfs/hpc/share/$USER/part-comp"
mkdir -p $SCRATCH
# I'm not doing any complex comparisons here, just checking if runtime is similar for 
# some smallish, shortish sims
module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
export JULIA_CUDA_MEMORY_POOL=none
mpiexec -n 4 julia --project=.. ../generic_sim.jl partitions.toml $SCRATCH/partitions
mpiexec -n 4 julia --project=.. ../generic_sim.jl baseline.toml $SCRATCH/baseline
