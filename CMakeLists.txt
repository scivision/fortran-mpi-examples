cmake_minimum_required(VERSION 3.20)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION PROJECT_VERSION
  REGEX "^([0-9]+\.[0-9]+\.[0-9]+)" LIMIT_INPUT 16 LENGTH_MAXIMUM 16 LIMIT_COUNT 1)

project(FortranMPIexamples
LANGUAGES C Fortran
DESCRIPTION "Example of using modern Fortran syntax"
VERSION ${PROJECT_VERSION}
)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

find_package(MPI REQUIRED COMPONENTS C Fortran)

add_subdirectory(mpi)
add_subdirectory(coarray)
