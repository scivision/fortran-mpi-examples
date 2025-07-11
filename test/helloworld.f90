program hw_mpi
!!    Each process prints out a "Hello, world!" message with a process ID
!!  Original Author:  John Burkardt
!!  Modified: Michael Hirsch, Ph.D.

use, intrinsic:: iso_fortran_env, only: dp=>real64, compiler_version, stderr=>error_unit

use mpi

implicit none

integer :: id, Nproc, ierr
real(dp) :: wtime

!>  Initialize MPI.
call MPI_Init(ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_INIT failed"

!>  Get the number of processes.
call MPI_Comm_size(MPI_COMM_WORLD, Nproc, ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_Comm_size failed"

!>  Get the individual process ID.
call MPI_Comm_rank(MPI_COMM_WORLD, id, ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_Comm_rank failed"

!>  Print a message.
if (id == 0) then
  print *,compiler_version()
  wtime = MPI_Wtime()
  print *, 'number of processes: ', Nproc
end if

print '(a,i0)', 'Process ', id

if (id == 0) then
  wtime = MPI_Wtime() - wtime

  print '(a,f0.3,a)', 'Elapsed wall clock time = ', wtime, ' seconds.'
end if

!>  Shut down MPI.
call MPI_Finalize(ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_FINALIZE failed"

end program
