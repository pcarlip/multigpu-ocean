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
n_o = [1, 2, 3, 4]
times_o = [3.818, 9.48]
mem_per_o = [53600, 40000]
mem_tot_o = n_o .* mem_per_o

