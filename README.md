[![DOI](https://zenodo.org/badge/996260250.svg)](https://doi.org/10.5281/zenodo.23257573)

# multigpu-ocean

Testing [Oceananigans](https://github.com/CliMA/Oceananigans.jl) on multiple GPUs using 
MPI and the [OSU COE](https://it.engineering.oregonstate.edu/hpc/about-cluster) HPC. This is not 
intended to produce scientific results (yet), it is a test/demo of my research group's capacity
to run Oceananigans on multiple GPUs and an initial test of its scaling properties. 
The model is a simple DNS of decaying turbulence, run at resolutions intended to 
come close to the maximum memory capacity of the GPUs used.

## Repository Structure

The `mpi-testing` directory has some simple checks that I can run CUDA-aware MPI in
Julia in the first place, and that I can set up and run an Oceananigans simulation.
This is important for ensuring that I'm using the correct OpenMPI module with the 
appropriate extensions enabled and disabled.

The other two directories,`strong-scaling` and `weak-scaling` test the scaling properties of 
Oceananigans on 1, 2, and 4 H100 GPUs. `strong-scaling` runs a simulation of constant size to 
test whether the memory burden and runtime decrease with number of GPUs. `weak-scaling`, 
meanwhile, runs a simulation whose size is proportional to the number of GPUs, to test whether
simulation time and per-GPU memory usage remain roughly constant. Overall, there is a 
slight memory and time cost associated with multi-GPU simulations, but not one that substantially
increases from 2 to 4 GPUs, and scaling otherwise remains fairly close to ideal.

## How to run

Instead of individual slurm scripts, jobs are generated with `ngpu.sh`, which is 
linked between `strong-scaling` and `weak-scaling`. It accepts 3 arguments: 
number of GPUs, toml config for `generic_sim.jl`, and a naming argument which 
extends the job name and creates a storage directory for the output files in 
`/nfs/hpc/share/$USER/ngpu-scaling`.
The strong scaling analysis can be run from the `strong-scaling` folder, with the
commands `./ngpu.sh 4 ngpu.toml strong`, `./ngpu.sh 2 ngpu.toml strong` and 
`./ngpu.sh 1 ngpu.toml strong`. The weak scaling analysis can be run from the 
`weak-scaling` folder with the commands `./ngpu.sh 4 4gpu_limit.toml weak`, 
`./ngpu.sh 2 2gpu_limit.toml weak`, and `.ngpu.sh 1 1gpu_limit.toml weak`.

More generally, the primary simulation
file is `generic_sim.jl`, which can be run with 
`mpiexec -n NUM_PROCS julia --project generic_sim.jl CONF.toml OUTPUT`,
with some appropriate choice of number of processes (here equal to number of GPUs), config file,
and output file (including path but not the extension;
this location is also used for storing the time and memory info).
The config options should be largely self-documenting in `generic_sim.jl`.

The loading methods for CUDA, Julia, and 
MPI would need modification for any other system, as would `LocalPreferences.toml`, 
which informs Julia about MPI details, and the storage directory in `ngpu.sh`.
