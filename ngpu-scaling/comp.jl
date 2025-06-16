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
using Plots

# %%
n = [1, 2, 4]

mem_per = [54823, 44871, 23207]
mem_tot = mem_per .* n

times = [4.859, 12.4835, 9.607]


# %%
plot(n, mem_tot, linewidth = 2, label = "Total memory")
plot!(n, mem_per, linewidth = 2, label = "Memory per GPU")
plot!(legend = :bottomleft)
xlabel!("Number of GPUs")
ylabel!("Memory (MiB)")
ylims!(0, 10^5)
title!("Memory use scaling")



# %%
plot(n, times, linewidth = 2, legend = false)
xlabel!("Number of GPUs")
ylabel!("Simulation time (min)")
ylims!(0, 13)
title!("Time scaling")

