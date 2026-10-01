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
using Plots

# %%
n = [1, 2, 4]

mem_tot = [59629, (44379+43849), (24658+23069*3)]
mem_per = mem_tot ./ n

times = [1.605*60, (52.466+52.479)/2, (27.904+27.885+27.871+27.906)/4]


# %%
plot(n, mem_tot, linewidth = 2, label = "Total memory", shape = :circle, markersize = 3, linecolor = "blue")
plot!(range(1, 4, 100), range(mem_tot[1], mem_tot[1], 100), linecolor = "blue", label = "weak scaling")
plot!(
    n,
    mem_per,
    linewidth = 2,
    label = "Memory per GPU",
    shape = :circle,
    markersize = 3,
    linecolor = "red",
    markercolor = "red",
)
plot!(range(1, 4, 100), mem_tot[1] ./ range(1, 4, 100), linecolor = "red", label = "weak scaling")
plot!(legend = :bottomleft)
xlabel!("Number of GPUs")
ylabel!("Memory (MiB)")
ylims!(0, 10^5)
title!("Memory use scaling")

# %%
plot(n, times, linewidth = 2, legend = false, shape = :circle, markersize = 3, label = "Measured times")
plot!(range(1, 4, 100), times[1] ./ range(1, 4, 100), label = "Strong scaling")
xlabel!("Number of GPUs")
ylabel!("Simulation time (min)")
ylims!(0, 100)
title!("Time scaling")


# %%
