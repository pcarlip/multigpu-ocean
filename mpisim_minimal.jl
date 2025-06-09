
using MPI
using Oceananigans
using Oceananigans.DistributedComputations
using Statistics
using HDF5_jll
using Printf
using Random


Nx = Ny = Nz = 256
Lx = Ly = Lz = 2π
topology = (Periodic, Periodic, Periodic)
arch = Distributed(GPU())

grid = RectilinearGrid(
    arch;
    topology,
    size = (Nx, Ny, Nz),
    halo = (3, 3, 3),
    x = (0, 2π),
    y = (0, 2π),
    z = (0, 2π),
)


@show grid

model = NonhydrostaticModel(;
    grid,
    advection = WENO(),
)

