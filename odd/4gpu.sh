#!/bin/bash

#SBATCH --job-name=4gpu_odd
#SBATCH --partition=ceoas-gpu
#SBATCH --nodelist=aerosmith
#SBATCH --cpus-per-task=6
#SBATCH --mem=100000
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:4
#SBATCH --time=3-00:00:00
#SBATCH --output=4gpu_odd.out

export MPITRAMPOLINE_LIB="/local/ceoas/x86_64/opt/MPIwrapper/openmpi@4.1.6%gcc@13.2-cuda-sandybridge/lib64/libmpiwrapper.so"
export MPITRAMPOLINE_MPIEXEC="/local/ceoas/x86_64/opt/MPItrampoline/openmpi@4.1.6%gcc@13.2-cuda-sandybridge/bin/mpiwrapperexec"

export UCX_WARN_UNUSED_ENV_VARS=n

export JULIA_NUM_THREADS=1

# export CUDA_VISIBLE_DEVICES=0,1,2,3
# use the above to limit available GPUs

/local/ceoas/x86_64/opt/MPIwrapper/openmpi@4.1.6%gcc@13.2-cuda-sandybridge/bin/mpiwrapperexec -n 4 julia --project=.. ngpu-odd.jl 4
