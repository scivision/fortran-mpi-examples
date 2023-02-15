cmake_minimum_required(VERSION 3.14...3.26)

project(FortranMPIexamples
LANGUAGES C Fortran
)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(cmake/compilers.cmake)

add_subdirectory(mpi)

# *** OpenMPI workaround
if(UNIX)
  if(NOT DEFINED mpi_tmpdir)
    execute_process(COMMAND mktemp -d /tmp/mpi-XXXXXXXX
    RESULT_VARIABLE ret
    OUTPUT_VARIABLE mpi_tmpdir
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(NOT ret EQUAL 0)
      message(FATAL_ERROR "could not create MPI working dir via mktemp -d: ${ret}")
    endif()
    set(mpi_tmpdir ${mpi_tmpdir} CACHE PATH "MPI working dir")
    message(STATUS "${ret}: Created MPI working dir ${mpi_tmpdir}")
  endif()
endif()
# *** END OpenMPI workaround

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
