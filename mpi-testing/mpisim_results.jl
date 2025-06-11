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
using Oceananigans, CairoMakie
using ColorSchemes

# %%
u_timeseries = FieldTimeSeries("three_dimensional_turbulence_rank0_rank0.jld2", "u")
v_timeseries = FieldTimeSeries("three_dimensional_turbulence_rank0_rank0.jld2", "v")

times = u_timeseries.times


# %%
u_timeseries[end]

# %%
u_slice = Field(u_timeseries[end], indices = (:, :, 10))

heatmap(u_slice, colormap = ColorSchemes.imola.colors)

# %%
u_slice = Field(u_timeseries[1], indices = (:, :, 10))

heatmap(u_slice, colormap = ColorSchemes.imola.colors)

# %%
