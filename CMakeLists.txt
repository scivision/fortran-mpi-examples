cmake_minimum_required(VERSION 3.19...3.28)

project(FortranMPIexamples
LANGUAGES C Fortran
)

enable_testing()

message(STATUS "CMake ${CMAKE_VERSION} Generator ${CMAKE_GENERATOR}  Build type ${CMAKE_BUILD_TYPE}")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# this has checks that can be reused in other projects as well
include(cmake/mpi.cmake)

include(cmake/print_target_props.cmake)
print_target_props(MPI::MPI_Fortran)

include(cmake/compilers.cmake)

add_subdirectory(test)

file(GENERATE OUTPUT .gitignore CONTENT "*")
