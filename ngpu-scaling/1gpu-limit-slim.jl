using Oceananigans
using Oceananigans.DistributedComputations
using Statistics
using NCDatasets
using Printf
using Random

Nx = Ny = 1024
Nz = 512
Lx = Ly = Lz = 2π
topology = (Periodic, Periodic, Periodic)
arch = GPU()
grid = RectilinearGrid(
    arch;
    topology,
    size = (Nx, Ny, Nz),
    x = (0, Nx * π / 32),
    y = (0, Ny * π / 32),
    z = (0, Nz * π / 32),
)

@show grid

model = NonhydrostaticModel(;
    grid,
    advection = WENO(),
)

# Make sure we use different seeds for different cores.
# rank = arch.local_rank
e(x, y, z) = 2rand() - 1
set!(model, u = e, v = e, w = e)

u, v, w = model.velocities
#e_op = @at (Center, Center, Center) 1/2 * (u^2 + v^2 + w^2)
#e = Field(e_op)
#ζ = Field(∂x(v) - ∂y(u))
#compute!(e)
#compute!(ζ)

simulation = Simulation(model, Δt = 0.01, stop_iteration = 100)

progress_message(sim) =
    @printf("Iteration: %04d, time: %s, Δt: %s, max(|w|) = %.1e ms⁻¹, wall time: %s\n",
        iteration(sim), prettytime(sim), prettytime(sim.Δt),
        maximum(abs, sim.model.velocities.w), prettytime(sim.run_wall_time))

#add_callback!(simulation, progress_message, IterationInterval(20))

#=
fields =
    Dict(
        "u" => u,
        "v" => v,
        "w" => w,
        #"uadv" => u * ∂x(u) + v * ∂y(u) + w * ∂z(u),
        #"vadv" => u * ∂x(v) + v * ∂y(v) + w * ∂z(v),
        #"wadv" => u * ∂x(w) + v * ∂y(w) + w * ∂z(w),
    )

simulation.output_writers[:field_writer] = JLD2Writer(model, fields,
    schedule = IterationInterval(50),
    filename = "1gpu_limit",
    overwrite_existing = true)
=#

run!(simulation)
