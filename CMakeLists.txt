cmake_minimum_required(VERSION 3.14...3.25)

project(FortranMPIexamples
LANGUAGES C Fortran
)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

find_package(Coarray)

include(cmake/compilers.cmake)

add_subdirectory(mpi)

if(Coarray_FOUND)
  add_subdirectory(coarray)
endif()
