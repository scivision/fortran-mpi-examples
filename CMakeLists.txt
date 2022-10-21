cmake_minimum_required(VERSION 3.14...3.25)

project(FortranMPIexamples
LANGUAGES C Fortran
)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/compilers.cmake)

add_subdirectory(mpi)

find_package(Coarray)
if(Coarray_FOUND)
  add_subdirectory(coarray)
endif()

include(FeatureSummary)

add_feature_info(Coarray Coarray_FOUND "Coarray Fortran")
add_feature_info(MPIF08 MPI_Fortran_HAVE_F08_MODULE "MPI Fortran 2008 bindings")

feature_summary(WHAT ALL)
