#!/bin/bash

export NGPU=$1
export SCRATCH="/nfs/hpc/share/$USER/ngpu-scaling/strong"

mkdir -p $SCRATCH

sbatch <<EOT
#!/bin/bash

#SBATCH --job-name=$NGPU-gpu-oc
#SBATCH --partition=dgxh
#SBATCH --cpus-per-task=2
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=$NGPU
#SBATCH --gres=gpu:$NGPU
#SBATCH --time=3:00:00
#SBATCH --output=$NGPU-gpu.out

module load openmpi/4.1_gcc-12 cuda/13.0 julia/1.12
export JULIA_CUDA_MEMORY_POOL=none
mpiexec -n $NGPU julia --project=.. ../generic_sim.jl ngpu.toml $SCRATCH/$NGPU-gpu

exit 0
EOT
