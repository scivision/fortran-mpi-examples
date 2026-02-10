program mpi_pass
!! passes data between two threads
!! This would be much simpler using Fortran 2008 coarray syntax
!!
!!  Original author:  John Burkardt

use, intrinsic :: iso_fortran_env, only: compiler_version, int64, stderr=>error_unit

use mpi_f08

implicit none

type(MPI_DATATYPE) :: mpipasstype

integer :: mcount
real :: dat(0:99), val(200)
integer :: dest, i, num_procs, id, tag
integer(int64) :: tic, toc, rate

type(MPI_STATUS) :: status
!integer :: status(MPI_STATUS_SIZE)


if (storage_size(dat) == 32) then
  mpipasstype = MPI_REAL
else if (storage_size(dat) == 64) then
  mpipasstype = MPI_DOUBLE_PRECISION
else
  error stop "Unsupported data type size"
endif


call system_clock(tic)

call MPI_Init()

!  Determine this process's ID.
call MPI_Comm_rank(MPI_COMM_WORLD, id)

!  Find out the number of processes available.
call MPI_Comm_size(MPI_COMM_WORLD, num_procs)

if (id == 0) print '(a)',compiler_version()

print '(a,i0,a,i0)', 'Process ', id, ' / ', num_procs

if (num_procs < 2) then
  if (id == 0) write(stderr, '(a,i0,a)') 'Detected ',num_procs, ' processes. Two workers required, use: mpiexec -np 2 ./mpi_pass'
  error stop
endif

!  Process 0 expects to receive as much as 200 real values, from any source.
select case (id)
case (0)
  print *, id, "waiting for MPI_send() from image 1"
  call MPI_Recv (val, size(val), mpipasstype, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, status)

  ! print '(i0,a,i0,a,i0)', id, ' Got data from processor ', status%MPI_SOURCE, ' tag ',status%MPI_TAG

  call MPI_Get_count(status, mpipasstype, mcount)

  print '(i0,a,i0,a)', id, ' Got ', mcount, ' elements.'

  if (abs(val(5)-4) > epsilon(0.)) error stop "data did not transfer"

!  Process 1 sends 100 real values to process 0.
case (1)
  print '(i0, a)', id, ': setting up data to send to process 0.'

  dat = real([(i, i = 0, 99)])

  dest = 0
  tag = 55
  call MPI_Send(dat, size(dat), mpipasstype, dest, tag, MPI_COMM_WORLD)

case default
  print '(i0,a,i0)', id, ': MPI has no work for image', id
end select

call MPI_Finalize()

if (id == 0) then
  call system_clock(toc)
  call system_clock(count_rate=rate)
  print '(a,f8.4)', 'Run time in seconds: ', real(toc - tic) / real(rate)
end if

end program
