program basic

use mpi
use, intrinsic :: iso_fortran_env, only: stderr=>error_unit, compiler_version

implicit none (type, external)

integer :: ierr

print '(a)', "going to init MPI"

call MPI_INIT(ierr)
if (ierr /= MPI_SUCCESS) then
  write(stderr,'(a,i0)') "MPI_INIT failed with error code", ierr
  error stop
endif

print '(a)', "MPI Init OK"

call MPI_FINALIZE(ierr)
if (ierr /= MPI_SUCCESS) then
  write(stderr,'(a,i0)') "MPI_FINALIZE failed with error code", ierr
  error stop
endif

print '(a)', "MPI closed"

end program
