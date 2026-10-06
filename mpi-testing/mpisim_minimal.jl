
using MPI
using Oceananigans
using CUDA
using Printf

Nx = Ny = Nz = 128
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

model = NonhydrostaticModel(grid, advection = WENO())

@show model