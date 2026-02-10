program mpi_vers
! https://github.com/open-mpi/ompi/blob/master/examples/hello_usempif08.f90

use, intrinsic :: iso_fortran_env, only : compiler_version

use mpi_f08

implicit none

integer :: id, Nimg, vlen
character(MPI_MAX_LIBRARY_VERSION_STRING) :: version  ! allocatable not ok


print *,compiler_version()

call MPI_INIT()

call MPI_COMM_RANK(MPI_COMM_WORLD, id)

call MPI_COMM_SIZE(MPI_COMM_WORLD, Nimg)

call MPI_GET_LIBRARY_VERSION(version, vlen)

print '(A,I3,A,I3,A)', 'MPI: Image ', id, ' / ', Nimg, ':', trim(version)

call MPI_FINALIZE()

end program
