# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.17.2
#   kernelspec:
#     display_name: Julia 1.10.9
#     language: julia
#     name: julia-1.10
# ---

# %%
using Oceananigans
using Printf

# %%
N = 256
grid = RectilinearGrid(
    GPU(),
    size = (N, N, N),
    x = (0, N * π / 32),
    y = (0, N * π / 32),
    z = (0, N * π / 32),
    topology = (Periodic, Periodic, Periodic))

mrgrid = MultiRegionGrid(grid, partition = XPartition(2), devices = 2)


# %%
model = NonhydrostaticModel(; grid, advection = WENO())

e(x, y, z) = 2rand() - 1
set!(model, u = e, v = e, w = e)

simulation = Simulation(model; Δt = 0.01, stop_iteration = 100)

progress_message(sim) =
    @printf("Iteration: %04d, time: %s, Δt: %s, max(|w|) = %.1e ms⁻¹, wall time: %s\n",
        iteration(sim), prettytime(sim), prettytime(sim.Δt),
        maximum(abs, sim.model.velocities.w), prettytime(sim.run_wall_time))

add_callback!(simulation, progress_message, IterationInterval(20))

# %%
run!(simulation)

# %%
using CairoMakie

u, v, w = model.velocities
ζ = Field(∂x(v) - ∂y(u), indices = (:, :, grid.Nz))
compute!(ζ)
heatmap(ζ)

# %%
