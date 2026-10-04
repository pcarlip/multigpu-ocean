#!/bin/bash

#SBATCH --job-name=gpu-stats
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --time=03:00
#SBATCH --output=h100.txt

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
nvidia-smi