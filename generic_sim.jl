using Oceananigans
using Oceananigans: TendencyCallsite, Periodic
using CUDA
using CUDA.CUFFT: fftfreq, rfftfreq, irfft
using NCDatasets
using Printf
using CairoMakie
using Oceanostics
using Dates
using TOML
using MPI

CUDA.Random.seed!(1234);

conf = TOML.tryparsefile(ARGS[1])
if isa(conf, TOML.ParserError)
    conf = Dict{String,Any}()
    println("Bad config file")
end

println(conf)

N = get(conf, "N", 512)
Nx = get(conf, "Nx", N)
Ny = get(conf, "Ny", N)
Nz = get(conf, "Nz", N)
Lx = get(conf, "Lx", Nx * π / 4)
Ly = get(conf, "Ly", Ny * π / 4)
Lz = get(conf, "Lz", Nz * π / 4)
Δt = get(conf, "dt", 0.01)
visc = get(conf, "visc", 5e-6)
#stoptime = get(conf, "stoptime", 3.5e6)
stopnum = get(conf, "stopnum", 1000) # default to stop after 1000 timesteps
prog_interval = get(conf, "prog_interval", 25)
save_interval = get(conf, "save_interval", 50)
file = get(conf, "file", "3d-data.jld2")

mpi = get(conf, "mpi", false)

if mpi
    gpu = Distributed(GPU())
    file = file * string(arch.local_rank)
else
    gpu = GPU()
end

grid = RectilinearGrid(
    gpu,
    size=(Nx, Ny, Nz),
    x=(-Lx / 2, Lx / 2),
    y=(-Ly / 2, Ly / 2),
    z=(-Lz / 2, Lz / 2),
    topology=(Periodic, Periodic, Periodic),
    halo=(5, 5, 5))

display(grid)

model = NonhydrostaticModel(
    grid,
    advection=WENO(order=9),
    closure=ScalarDiffusivity(ν=visc))

display(model)

e(x, y, z) = 2rand() - 1
set!(model, u=e, v=e, w=e)

simulation = Simulation(model; Δt=Δt, stop_iteration=stopnum)

display(simulation)

function progress_message(sim)
    @printf("Iteration: %04d, time: %s, Δt: %s, wall time: %s\n",
        iteration(sim), prettytime(sim), prettytime(sim.Δt), prettytime(
            sim.run_wall_time,
        ))
    return flush(stdout)
end

add_callback!(simulation, progress_message, IterationInterval(prog_interval))


u, v, w = model.velocities
ke = Integral(KineticEnergyEquation.KineticEnergy(model))
diss = Integral(KineticEnergyEquation.DissipationRate(model))

fields =
    Dict(
        "u" => u,
        "v" => v,
        "w" => w,
        "KE" => ke,
        "dissipation" => diss,
    )

simulation.output_writers[:JLD2] =
    JLD2Writer(
        model,
        fields,
        filename=file,
        schedule=OrSchedule(IterationInterval(save_interval), TimeInterval(stoptime)),
        overwrite_existing=true,
    )

conjure_time_step_wizard!(simulation, cfl=1, max_Δt=(Δt * 10))

run!(simulation)
