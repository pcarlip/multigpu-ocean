# Run this script with
#
# $ mpirun -n 2 julia --project distributed_nonhydrostatic_turbulence.jl
#
# for example.
#
# You also probably should set
#
# $ export JULIA_NUM_THREADS=1
#
# See MPI.jl documentation for more information on how to setup the MPI environment.
# If you have a local installation of MPI, you can use it by setting
#
# julia> MPIPreferences.use_system_binaries()
#
# before running the script.

using MPI
using Oceananigans
#using Oceananigans.DistributedComputations
using Statistics
using NCDatasets
using Printf
using Random

Nx = Ny = Nz = 64
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
    closure = ScalarDiffusivity(ν = 1e-4, κ = 1e-4),
)

# Make sure we use different seeds for different cores.
rank = arch.local_rank
e(x, y, z) = 2rand() - 1
set!(model, u = e, v = e, w = e)

u, v, w = model.velocities
#e_op = @at (Center, Center, Center) 1/2 * (u^2 + v^2 + w^2)
#e = Field(e_op)
#ζ = Field(∂x(v) - ∂y(u))
#compute!(e)
#compute!(ζ)

simulation = Simulation(model, Δt = 0.01, stop_iteration = 1000)

progress_message(sim) =
    @printf("Iteration: %04d, time: %s, Δt: %s, max(|w|) = %.1e ms⁻¹, wall time: %s\n",
        iteration(sim), prettytime(sim), prettytime(sim.Δt),
        maximum(abs, sim.model.velocities.w), prettytime(sim.run_wall_time))

#add_callback!(simulation, progress_message, IterationInterval(20))

fields =
    Dict(
        "u" => u,
        "v" => v,
        "w" => w,
        #"uadv" => u * ∂x(u) + v * ∂y(u) + w * ∂z(u),
        #"vadv" => u * ∂x(v) + v * ∂y(v) + w * ∂z(v),
        #"wadv" => u * ∂x(w) + v * ∂y(w) + w * ∂z(w),
    )

#= simulation.output_writers[:field_writer] = NetCDFWriter(model, fields,
    schedule = IterationInterval(50),
    with_halos = true,
    filename = "three_dimensional_turbulence_rank$rank",
    overwrite_existing = true)
 =#
run!(simulation)
