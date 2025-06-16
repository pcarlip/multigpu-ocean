# multigpu-ocean

Testing [Oceananigans](https://github.com/CliMA/Oceananigans.jl) on multiple GPUs using 
MPI and the [OSU CQLS](https://shell.cqls.oregonstate.edu/) supercomputer.

## Repository Structure

The `mpi-testing`, `openmpi`, and `openmpi4` directories involve my initial attempts to get 
Oceananigans, Julia, and MPI working together consistently. At the moment, every version 
of MPI that I've tried does work, though OpenMPI 5 runs roughly 3x slower than OpenMPI 4
or MPITrampoline around OpenMPI 4. I also still have issues saving simulation outputs 
as NetCDF files, but if that proves to be necessary I'm sure it can be done through 
post-processing of the jld2 outputs.

The `ngpu-scaling` directory contains my attempts to find the maximum size simulation that
can run on 1 gpu, as well as some initial benchmarks comparing the same simulation 
on 1, 2, and 4 GPUs. Notable scripts include `ngpu-mpi.jl`, a general Julia file for running
a 1024x1024x512 gridpoint simulation on multiple GPUs if run via `mpiexec` (note: 
adjust JLD2Writer filename as appropriate), and 
`2gpu_mpi.sh` and `4gpu_mpi.sh`, which create Slurm jobs to run the simulation on 2 and 4
GPUs respectively.

The `tracer` directory looks at the performance impact of adding a buoyancy tracer to the 
model, which affects run time, memory usage, and output file size (not saved in repo; 
.jld2 files are too large). The `odd` directory considers a simulation size that isn't 
a power of 2, for which the FFT methods used in the simulation may be less efficient.