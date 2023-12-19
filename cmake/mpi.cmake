include(CheckSourceCompiles)

set(MPI_DETERMINE_LIBRARY_VERSION true)
find_package(MPI REQUIRED COMPONENTS C Fortran)
message(STATUS "MPI Library Version: ${MPI_C_LIBRARY_VERSION_STRING}")

find_file(mpi_f08_mod NAMES mpi_f08.mod
NO_DEFAULT_PATH
HINTS ${MPI_Fortran_INCLUDE_DIRS}
)

message(STATUS "${MPI_Fortran_LIBRARY_VERSION_STRING}")
message(STATUS "MPI libs: ${MPI_Fortran_LIBRARIES}")
message(STATUS "MPI include: ${MPI_Fortran_INCLUDE_DIRS}")
message(STATUS "MPI_f08 module: ${mpi_f08_mod}")
message(STATUS "MPI compile flags: ${MPI_Fortran_COMPILER_FLAGS}")
message(STATUS "MPI link flags: ${MPI_Fortran_LINK_FLAGS}")

if(NOT mpi_f08_mod)
  message(WARNING "Fortran MPI ${MPI_Fortran_VERSION} doesn't have MPI-3 Fortran mpi_f08.mod, searched using ${MPI_Fortran_INCLUDE_DIRS}")
endif()

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
