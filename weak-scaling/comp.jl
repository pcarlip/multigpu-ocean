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

# %%
n = [1, 2, 4]

mem_tot = [32605, (44379+43849), (46760+45169*3)]
mem_per = mem_tot ./ n

times = [50.522, 1.142*60, (58.866+58.865+58.893+58.891)/4]


# %%
f = Figure()
ax = Axis(f[1, 1], xlabel = "Number of GPUs", ylabel = "Memory (MiB)", title = "Memory use scaling")
scatterlines!(ax, n, mem_tot, linewidth = 2, label = "Total memory", marker = :circle, markersize = 10, color = :blue)
lines!(ax, range(1, 4, 100), range(mem_tot[1], mem_tot[1]*4, 100), color = :blue, label = "Weak scaling", alpha = 0.5)
scatterlines!(ax,
    n,
    mem_per,
    linewidth = 2,
    label = "Memory per GPU",
    marker = :circle,
    markersize = 10,
    color = :red,
)
lines!(ax, range(1, 4, 100), range(mem_tot[1], mem_tot[1], 100), color = :red, label = "Weak scaling", alpha = 0.5)
ylims!(ax, 0, 2*10^5)
axislegend(ax, position = :lt)
save("mem_weak.svg", f)
f


# %%
f = Figure()
ax = Axis(f[1, 1], xlabel = "Number of GPUs", ylabel = "Time (min)", title = "Time scaling")
scatterlines!(ax, n, times, linewidth = 2, marker = :circle, markersize = 10, label = "Measured times", color = :red)
lines!(ax, range(1, 4, 100), range(times[1], times[1], 100), label = "Weak scaling", color = :red, alpha = 0.5)
ylims!(0, 100)
axislegend(ax)
save("time_weak.svg", f)
f



# %%
