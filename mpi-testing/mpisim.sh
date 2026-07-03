#!/bin/bash

#SBATCH --job-name=mpisim
#SBATCH --partition=ceoas-gpu
#SBATCH --nodelist=ayaya03
#SBATCH --cpus-per-task=2
#SBATCH --mem=100000
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --gres=gpu:2
#SBATCH --time=3-00:00:00
#SBATCH --output=mpisim_test.out

#export CUDA_VISIBLE_DEVICES=0,1

export MPITRAMPOLINE_LIB="/local/ceoas/x86_64/opt/MPIwrapper/openmpi@4.1.6%gcc@13.2-cuda-sandybridge/lib64/libmpiwrapper.so"
export MPITRAMPOLINE_MPIEXEC="/local/ceoas/x86_64/opt/MPItrampoline/openmpi@4.1.6%gcc@13.2-cuda-sandybridge/bin/mpiwrapperexec"

export UCX_WARN_UNUSED_ENV_VARS=n

export JULIA_NUM_THREADS=1

/local/ceoas/x86_64/opt/MPIwrapper/openmpi@4.1.6%gcc@13.2-cuda-sandybridge/bin/mpiwrapperexec -n 2 julia --project=.. ../generic_sim.jl mpisim.toml
