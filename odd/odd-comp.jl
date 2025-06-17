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
times_o = [3.818, 9.48, 7.23]
mem_per_o = [53600, 40000, 17575]
mem_tot_o = n .* mem_per_o



# %%
(times_o ./ 0.75) ./ times


# %%
(mem_tot_o ./ 0.75) ./ mem_tot


# %%
plot(
    n,
    mem_tot,
    linewidth = 2,
    label = "Total memory (power of 2)",
    shape = :circle,
    markersize = 3,
)
plot!(
    n,
    mem_per,
    linewidth = 2,
    label = "Memory per GPU (power of 2)",
    shape = :circle,
    markersize = 3,
)
plot!(
    n,
    mem_tot_o,
    linewidth = 2,
    label = "Total memory (non-power of 2)",
    shape = :circle,
    markersize = 3,
)
plot!(
    n,
    mem_per_o,
    linewidth = 2,
    label = "Memory per GPU (non-power of 2)",
    shape = :circle,
    markersize = 3,
)

plot!(legend = :bottomleft)
xlabel!("Number of GPUs")
ylabel!("Memory (MiB)")
ylims!(0, 10^5)
title!("Memory use scaling")



# %%
plot(
    n,
    times,
    linewidth = 2,
    label = "Run time (power of 2)",
    shape = :circle,
    markersize = 3,
)
plot!(
    n,
    times_o,
    linewidth = 2,
    label = "Run time (non-power of 2)",
    shape = :circle,
    markersize = 3,
)

xlabel!("Number of GPUs")
ylabel!("Simulation time (min)")
ylims!(0, 13)
title!("Time scaling")



# %%
