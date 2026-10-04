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
