using MPI
using CUDA
MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
mpi_size = MPI.Comm_size(comm)
dst = mod(rank+1, mpi_size)
src = mod(rank-1, mpi_size)
println("rank=$rank, size=$mpi_size, dst=$dst, src=$src")
N = 4
send_mesg = CuArray{Float64}(undef, N)
recv_mesg = CuArray{Float64}(undef, N)
fill!(send_mesg, Float64(rank))
CUDA.synchronize()
MPI.Sendrecv!(send_mesg, dst, 0, recv_mesg, src, 0, comm)
println("recv_mesg on proc $rank: $recv_mesg")
rank==0 && println("done.")