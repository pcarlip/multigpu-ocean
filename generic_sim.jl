using Oceananigans
using CUDA
using NCDatasets
using Printf
using CairoMakie
using Oceanostics
using Dates
using TOML
using MPI
using Random
using CoherentNoise
using ForwardDiff

MPI.Init()
rank = MPI.Comm_rank(MPI.COMM_WORLD)

if length(ARGS) < 2
    println("Missing config file or output file")
    exit(1)
elseif length(ARGS) > 2
    println("Extra args given; please provide only one config file and one output file path")
    exit(1)
end

conf = TOML.tryparsefile(ARGS[1])
filepath = ARGS[2]

if isa(conf, TOML.ParserError)
    println("Bad conf file")
    println(conf)
    exit(1)
end

println(conf)

N = get(conf, "N", 512)
Nx = get(conf, "Nx", N)
Ny = get(conf, "Ny", N)
Nz = get(conf, "Nz", N)
Lx = get(conf, "Lx", Nx * π / 4)
Ly = get(conf, "Ly", Ny * π / 4)
Lz = get(conf, "Lz", Nz * π / 4)
Δt = get(conf, "dt_init", 0.01)
visc = get(conf, "visc", 5e-6)
stoptime = get(conf, "stoptime", 3600) # default to stop after 1 hour
prog_interval = get(conf, "prog_interval", 25)
save_interval = get(conf, "save_interval", 50)
jld2 = get(conf, "use_jld2", true)
mpi = get(conf, "mpi", false)

if mpi
    arch = Distributed(GPU())
else
    arch = GPU()
end

if jld2
    writer = JLD2Writer
else
    writer = NetCDFWriter
end

grid = RectilinearGrid(
    arch,
    size = (Nx, Ny, Nz),
    x = (-Lx / 2, Lx / 2),
    y = (-Ly / 2, Ly / 2),
    z = (-Lz / 2, Lz / 2),
    topology = (Periodic, Periodic, Periodic),
    halo = (5, 5, 5))

display(grid)

model = NonhydrostaticModel(
    grid,
    advection = WENO(order = 5),
    closure = ScalarDiffusivity(ν = visc))

display(model)

a = opensimplex2_3d(123)
b = opensimplex2_3d(456)
c = opensimplex2_3d(789)

afunc(arr) = sample(a, arr[1], arr[2], arr[3])
bfunc(arr) = sample(a, arr[1], arr[2], arr[3])
cfunc(arr) = sample(a, arr[1], arr[2], arr[3])

ufunc(x, y, z) = ForwardDiff.gradient(cfunc, [x, y, z])[2] - ForwardDiff.gradient(bfunc, [x, y, z])[3]
vfunc(x, y, z) = ForwardDiff.gradient(afunc, [x, y, z])[3] - ForwardDiff.gradient(cfunc, [x, y, z])[1]
wfunc(x, y, z) = ForwardDiff.gradient(bfunc, [x, y, z])[1] - ForwardDiff.gradient(afunc, [x, y, z])[2]

# generate a random vector field as a function of x, y, z, with a fixed seed
# its curl is also random but also divergenceless

set!(model, u = ufunc, v = vfunc, w = wfunc)

simulation = Simulation(model; Δt = Δt, stop_time = stoptime)

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

simulation.output_writers[:output] =
    writer(
        model,
        fields,
        filename = filepath,
        schedule = IterationInterval(save_interval),
        overwrite_files = true,
    )

conjure_time_step_wizard!(simulation, cfl = 1, max_Δt = (Δt * 10))
# avoid too-large timesteps even within CFL

#mem in MiB, to nearest integer
used_mem = Int((CUDA.total_memory() - CUDA.free_memory())/1024)
total_mem = Int(CUDA.total_memory())

run!(simulation)

file = filepath*"_mem"*string(rank)*".txt"
t_end = Int(sim.run_wall_time) # should be time in s, to the nearest int
data = Dict("rank"=>rank, "total_mem" => total_mem, "used_mem" => used_mem, "runtime" => t_end)

open(file, "w") do io
    TOML.print(io, data)
end

