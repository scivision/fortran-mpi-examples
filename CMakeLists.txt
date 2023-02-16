cmake_minimum_required(VERSION 3.14...3.26)

project(FortranMPIexamples
LANGUAGES C Fortran
)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(cmake/compilers.cmake)

add_subdirectory(mpi)

# --- Coarrary

find_package(Coarray)
if(Coarray_FOUND)
  add_subdirectory(coarray)
endif()

include(FeatureSummary)

add_feature_info(Coarray Coarray_FOUND "Coarray Fortran")

feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
