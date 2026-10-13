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
#     display_name: Julia 1.12
#     language: julia
#     name: julia-1.12
# ---

# %%
using Oceananigans, CairoMakie
using ColorSchemes
using MPI

# %%
loc = "/nfs/hpc/share/carlipp/ngpu-scaling/strong/"
ds_1gpu = FieldDataset(loc*"1-gpu_rank0.jld2"; backend = OnDisk())
ds_2gpu = FieldDataset(loc*"2-gpu_rank0.jld2"; backend = OnDisk())
ds_4gpu = FieldDataset(loc*"4-gpu_rank0.jld2"; backend = OnDisk())


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
n = size(ds_1gpu.KE)[end]

# %%
ke_1 = [collect(ds_1gpu.KE[i])[1] for i = 1:n]
ke_2 = [collect(ds_2gpu.KE[i])[1] for i = 1:n]
ke_4 = [collect(ds_4gpu.KE[i])[1] for i = 1:n];


# %%
println(ke_1)
println(ke_2)
println(ke_4)

# %%
isapprox(ke_1, ke_2, rtol = 1e-5)

# %%
isapprox(ke_2, ke_4, rtol = 1e-5)

# %%
u1 = FieldTimeSeries(loc*"1-gpu", "u"; backend = OnDisk())
u2 = FieldTimeSeries(loc*"2-gpu", "u"; backend = OnDisk())
u4 = FieldTimeSeries(loc*"4-gpu", "u"; backend = OnDisk());

# %%
u1slice = interior(u1[end])[:, :, 10]
u2slice = interior(u2[end])[:, :, 10]
u4slice = interior(u4[end])[:, :, 10];

# %%
fig = Figure(size = (900, 300))
ax1 = Axis(fig[1, 1])
ax2 = Axis(fig[1, 2])
ax3 = Axis(fig[1, 3])
heatmap!(ax1, u1slice, colormap = :balance)
heatmap!(ax2, u2slice, colormap = :balance)
heatmap!(ax3, u4slice, colormap = :balance)
fig

# %%
u1_end = interior(u1[end])
u2_end = interior(u2[end])
u4_end = interior(u4[end]);

# %%
using Statistics

println(std(u1_end))
println(std(u2_end))
println(std(u4_end))
println(std(u1_end-u2_end))
println(std(u1_end-u4_end))

# %%
