using Oceananigans
using Test

user = ENV["USER"]
loc = "/nfs/hpc/share/"*user*"/ngpu-scaling/strong/"
ds_1gpu = FieldDataset(loc*"1-gpu_rank0.jld2"; backend = OnDisk())
ds_2gpu = FieldDataset(loc*"2-gpu_rank0.jld2"; backend = OnDisk())
ds_4gpu = FieldDataset(loc*"4-gpu_rank0.jld2"; backend = OnDisk())

n = size(ds_1gpu.KE)[end]

ke_1 = [collect(ds_1gpu.KE[i])[1] for i = 1:n]
ke_2 = [collect(ds_2gpu.KE[i])[1] for i = 1:n]
ke_4 = [collect(ds_4gpu.KE[i])[1] for i = 1:n]

ε_1 = [collect(ds_1gpu.dissipation[i])[1] for i = 1:n]
ε_2 = [collect(ds_2gpu.dissipation[i])[1] for i = 1:n]
ε_4 = [collect(ds_4gpu.dissipation[i])[1] for i = 1:n]

@test isapprox(ke_1, ke_2, rtol = 1e-5)
@test isapprox(ke_1, ke_4, rtol = 1e-5)
@test isapprox(ε_1, ε_2, rtol = 1e-5)
@test isapprox(ε_1, ε_4, rtol = 1e-5)
