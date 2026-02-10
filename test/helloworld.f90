program hw_mpi
!!    Each process prints out a "Hello, world!" message with a process ID
!!  Original Author:  John Burkardt
!!  Modified: Michael Hirsch, Ph.D.

use, intrinsic:: iso_fortran_env, only: dp=>real64, compiler_version, stderr=>error_unit

use mpi_f08

implicit none

integer :: id, Nproc
real(dp) :: wtime

!>  Initialize MPI.
call MPI_Init()

!>  Get the number of processes.
call MPI_Comm_size(MPI_COMM_WORLD, Nproc)

!>  Get the individual process ID.
call MPI_Comm_rank(MPI_COMM_WORLD, id)

!>  Print a message.
if (id == 0) then
  print '(a)',compiler_version()
  wtime = MPI_Wtime()
  print '(a,i0)', 'number of processes: ', Nproc
end if

print '(a,i0)', 'Process ', id

if (id == 0) then
  wtime = MPI_Wtime() - wtime

  print '(a,f0.3,a)', 'Elapsed wall clock time = ', wtime, ' seconds.'
end if

!>  Shut down MPI.
call MPI_Finalize()

end program
