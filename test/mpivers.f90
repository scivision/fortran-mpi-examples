program mpi_vers
! https://github.com/open-mpi/ompi/blob/master/examples/hello_usempif08.f90

use, intrinsic :: iso_fortran_env, only : compiler_version

use mpi

implicit none

integer :: id, Nimg, vlen, ierr
character(MPI_MAX_LIBRARY_VERSION_STRING) :: version  ! allocatable not ok


print *,compiler_version()

call MPI_INIT(ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_INIT failed"

call MPI_COMM_RANK(MPI_COMM_WORLD, id, ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_Comm_rank failed"

call MPI_COMM_SIZE(MPI_COMM_WORLD, Nimg, ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_Comm_size failed"

call MPI_GET_LIBRARY_VERSION(version, vlen, ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_Get_library_version failed"

print '(A,I3,A,I3,A)', 'MPI: Image ', id, ' / ', Nimg, ':', trim(version)

call MPI_FINALIZE(ierr)
if (ierr /= MPI_SUCCESS) error stop "MPI_Finalize failed"

end program
