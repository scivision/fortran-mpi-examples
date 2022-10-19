include(CheckFortranSourceCompiles)

find_package(MPI REQUIRED COMPONENTS C Fortran)

set(CMAKE_REQUIRED_LIBRARIES MPI::MPI_Fortran)

if(MPI_Fortran_HAVE_F08_MODULE)
  check_fortran_source_compiles(
  [=[
  program test
  use mpi_f08, only : mpi_comm_rank, mpi_real, mpi_comm_world, mpi_init, mpi_finalize
  implicit none
  call mpi_init
  call mpi_finalize
  end program
  ]=]
  MPI_Fortran_F08_MODULE_WORKS
  SRC_EXT f90
  )
endif()

set(CMAKE_REQUIRED_LIBRARIES)
