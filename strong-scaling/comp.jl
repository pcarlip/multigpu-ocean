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
using CairoMakie
using TOML
using Statistics

# %%
n = [1, 2, 4]

user = ENV["USER"]

ds4 = [TOML.parsefile("/nfs/hpc/share/"*user*"/ngpu-scaling/strong/4-gpu_stats"*string(i)*".toml") for i = 0:3]
ds2 = [TOML.parsefile("/nfs/hpc/share/"*user*"/ngpu-scaling/strong/2-gpu_stats"*string(i)*".toml") for i = 0:1]
ds1 = [TOML.parsefile("/nfs/hpc/share/"*user*"/ngpu-scaling/strong/1-gpu_stats"*string(i)*".toml") for i = 0:0]

mem_tot = [sum([i["used_mem"] for i in ds1]), sum([i["used_mem"] for i in ds2]), sum([i["used_mem"] for i in ds4])] ./ 1024
mem_per = mem_tot ./ n

times = [mean([i["runtime"] for i in ds1]), mean([i["runtime"] for i in ds2]), mean([i["runtime"] for i in ds4])] ./ 60


# %%
f = Figure()
ax = Axis(f[1, 1], xlabel = "Number of GPUs", ylabel = "Memory (MiB)", title = "Memory use scaling")
scatterlines!(ax, n, mem_tot, linewidth = 2, label = "Total memory", marker = :circle, markersize = 10, color = :blue)
lines!(ax, range(1, 4, 100), range(mem_tot[1], mem_tot[1], 100), color = :blue, label = "Strong scaling", alpha = 0.5)
scatterlines!(ax,
    n,
    mem_per,
    linewidth = 2,
    label = "Memory per GPU",
    marker = :circle,
    markersize = 10,
    color = :red,
)
lines!(ax, range(1, 4, 100), mem_tot[1] ./ range(1, 4, 100), color = :red, label = "Strong scaling", alpha = 0.5)
ylims!(ax, 0, 10^5)
axislegend(ax, position = :lb)
save("mem_strong.svg", f)
f


# %%
f = Figure()
ax = Axis(f[1, 1], xlabel = "Number of GPUs", ylabel = "Time (min)", title = "Time scaling")
scatterlines!(ax, n, times, linewidth = 2, marker = :circle, markersize = 10, label = "Measured times", color = :red)
lines!(ax, range(1, 4, 100), times[1] ./ range(1, 4, 100), label = "Strong scaling", color = :red, alpha = 0.5)
ylims!(0, 110)
axislegend(ax)
save("time_strong.svg", f)
f


# %%
