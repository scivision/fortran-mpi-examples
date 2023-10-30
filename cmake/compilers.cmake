include(CheckSourceCompiles)

set(MPI_DETERMINE_LIBRARY_VERSION true)
find_package(MPI REQUIRED COMPONENTS C Fortran)
message(STATUS "MPI Library Version: ${MPI_C_LIBRARY_VERSION_STRING}")

include(${CMAKE_CURRENT_LIST_DIR}/openmpi.cmake)

set(CMAKE_REQUIRED_INCLUDES ${MPI_Fortran_INCLUDE_DIRS})
set(CMAKE_REQUIRED_LIBRARIES ${MPI_Fortran_LIBRARIES})

# sometimes factory FindMPI.cmake doesn't define this
check_source_compiles(Fortran
[=[
program test
use mpi_f08, only : mpi_comm_rank, mpi_real, mpi_comm_world, mpi_init, mpi_finalize
implicit none
call mpi_init
call mpi_finalize
end program
]=]
MPI_Fortran_HAVE_F08_MODULE
)

if(NOT MPI_Fortran_HAVE_F08_MODULE)
  message(FATAL_ERROR "Fortran MPI-3 binding not present.")
endif()


if(NOT MSVC)
  add_compile_options(-Wall)
endif()
