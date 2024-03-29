include(CheckSourceCompiles)

set(MPI_DETERMINE_LIBRARY_VERSION true)

find_package(MPI REQUIRED COMPONENTS C Fortran)

message(STATUS "MPI Library Version: ${MPI_C_LIBRARY_VERSION_STRING}")

message(STATUS "${MPI_Fortran_LIBRARY_VERSION_STRING}")

message(STATUS "MPI_Fortran_LIBRARIES: ${MPI_Fortran_LIBRARIES}")

message(STATUS "MPI_Fortran_MODULE_DIR: ${MPI_Fortran_MODULE_DIR}")
message(STATUS "MPI_Fortran_INCLUDE_DIRS: ${MPI_Fortran_INCLUDE_DIRS}")
message(STATUS "MPI_Fortran_COMPILE_OPTIONS: ${MPI_Fortran_COMPILE_OPTIONS}")
message(STATUS "MPI_Fortran_LINK_FLAGS: ${MPI_Fortran_LINK_FLAGS}")

include(${CMAKE_CURRENT_LIST_DIR}/openmpi.cmake)

if(MPI_Fortran_HAVE_F08_MODULE)
  return()
endif()

set(CMAKE_REQUIRED_LIBRARIES MPI::MPI_Fortran)

# sometimes factory FindMPI.cmake doesn't define this
message(CHECK_START "Checking for Fortran MPI-3 binding")
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

if(MPI_Fortran_HAVE_F08_MODULE)
  message(CHECK_PASS "yes")
else()
  message(CHECK_FAIL "no")
  message(WARNING "MPI-3 Fortran module mpi_f08 not found, builds may fail.")
endif()
