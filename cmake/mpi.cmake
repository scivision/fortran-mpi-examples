include(CheckSourceCompiles)

set(MPI_DETERMINE_LIBRARY_VERSION true)
find_package(MPI REQUIRED COMPONENTS C Fortran)
message(STATUS "MPI Library Version: ${MPI_C_LIBRARY_VERSION_STRING}")

# Cray FindMPI.cmake has a bug where the plain CMake variables aren't defined, only imported target is
# as a workaround for the many versions of CMake where this is so, we populate them ourselves.

if(NOT MPI_Fortran_INCLUDE_DIRS)
  get_property(MPI_Fortran_INCLUDE_DIRS TARGET MPI::MPI_Fortran PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
  message(STATUS "workaround: MPI_Fortran_INCLUDE_DIRS: ${MPI_Fortran_INCLUDE_DIRS}")
endif()
if(NOT MPI_C_INCLUDE_DIRS)
  get_property(MPI_C_INCLUDE_DIRS TARGET MPI::MPI_C PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
  message(STATUS "workaround: MPI_C_INCLUDE_DIRS: ${MPI_C_INCLUDE_DIRS}")
endif()
if(NOT MPI_Fortran_COMPILE_OPTIONS)
  get_property(MPI_Fortran_COMPILE_OPTIONS TARGET MPI::MPI_Fortran PROPERTY INTERFACE_COMPILE_OPTIONS)
endif()
if(NOT MPI_Fortran_COMPILE_DEFINITIONS)
  get_property(MPI_Fortran_COMPILE_DEFINITIONS TARGET MPI::MPI_Fortran PROPERTY INTERFACE_COMPILE_DEFINITIONS)
endif()
if(NOT MPI_Fortran_LINK_FLAGS)
  get_property(MPI_Fortran_LINK_FLAGS TARGET MPI::MPI_Fortran PROPERTY INTERFACE_LINK_OPTIONS)
endif()

find_file(mpi_f08_mod NAMES mpi_f08.mod
NO_DEFAULT_PATH
HINTS ${MPI_Fortran_INCLUDE_DIRS}
)

message(STATUS "${MPI_Fortran_LIBRARY_VERSION_STRING}")

message(STATUS "MPI_Fortran_LIBRARIES: ${MPI_Fortran_LIBRARIES}")

message(STATUS "MPI_Fortran_MODULE_DIR: ${MPI_Fortran_MODULE_DIR}")
message(STATUS "MPI_Fortran_INCLUDE_DIRS: ${MPI_Fortran_INCLUDE_DIRS}")

message(STATUS "MPI_f08 module: ${mpi_f08_mod}")
message(STATUS "MPI_Fortran_COMPILE_OPTIONS: ${MPI_Fortran_COMPILE_OPTIONS}")
message(STATUS "MPI_Fortran_LINK_FLAGS: ${MPI_Fortran_LINK_FLAGS}")

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
