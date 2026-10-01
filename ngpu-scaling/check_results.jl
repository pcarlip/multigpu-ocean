# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.19.5
#   kernelspec:
#     display_name: Julia 1.12.7
#     language: julia
#     name: julia-1.12
# ---

# %%
using Oceananigans, CairoMakie
using ColorSchemes
using MPI

# %%
loc = "/nfs/hpc/share/carlipp/ngpu-scaling/"
ds_1gpu = FieldDataset(loc*"1gpu_data_rank0.jld2"; backend = OnDisk())
ds_2gpu = FieldDataset(loc*"2gpu_data_rank0.jld2"; backend = OnDisk())
ds_4gpu = FieldDataset(loc*"4gpu_data_rank0.jld2"; backend = OnDisk())


# %%
fig = Figure(size = (1000, 500))
ax = Axis(fig[1, 1], yscale = log10, title = "KE", ylabel = "Kinetic Energy", xlabel = "time")
ax2 = Axis(fig[1, 2], yscale = log10, title = "ε", ylabel = "Dissipation", xlabel = "time")
lines!(ax, ds_1gpu.KE, label = "1 GPU", linewidth = 3)
lines!(ax, ds_2gpu.KE, label = "2 GPU", linestyle = :dash, linewidth = 2)
lines!(ax, ds_4gpu.KE, label = "4 GPU", linestyle = :dot, linewidth = 5)
lines!(ax2, ds_1gpu.dissipation, label = "1 GPU", linewidth = 3)
lines!(ax2, ds_2gpu.dissipation, label = "2 GPU", linestyle = :dash, linewidth = 2)
lines!(ax2, ds_4gpu.dissipation, label = "4 GPU", linestyle = :dot, linewidth = 5)
axislegend(ax)
axislegend(ax2)
fig


# %%
println([collect(ds_1gpu.KE[i])[1] for i = 1:21])
println([collect(ds_2gpu.KE[i])[1] for i = 1:21])
println([collect(ds_4gpu.KE[i])[1] for i = 1:21])


# %%
