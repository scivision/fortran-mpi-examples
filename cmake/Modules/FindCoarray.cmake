# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindCoarray
----------

Finds compiler flags or library necessary to support Fortran 2008/2018 coarrays.

This packages primary purposes are:

* for compilers natively supporting Fortran coarrays without needing compiler options, simply indicating Coarray_FOUND  (example: Cray)
* for compilers with built-in Fortran coarray support, enable compiler option (example: Intel Fortran)
* for compilers needing a library such as OpenCoarrays, presenting library (example: GNU)


Result Variables
^^^^^^^^^^^^^^^^

``Coarray_FOUND``
  indicates coarray support found (whether built-in or library)

``Coarray_LIBRARIES``
  coarray library path
``Coarray_COMPILE_OPTIONS``
  coarray compiler options
``Coarray_EXECUTABLE``
  coarray executable e.g. ``cafrun``
``Coarray_MAX_NUMPROCS``
  maximum number of parallel processes
``Coarray_NUMPROC_FLAG``
  use for executing in parallel: ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} ${CMAKE_CURRENT_BINARY_DIR}/myprogram

Cache Variables
^^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Coarray_LIBRARY``
  The coarray libraries, if needed and found
#]=======================================================================]

include(CheckFortranSourceCompiles)


function(check_coarray)

set(CMAKE_REQUIRED_FLAGS ${Coarray_COMPILE_OPTIONS})
set(CMAKE_REQUIRED_LIBRARIES ${Coarray_LIBRARY})
set(CMAKE_REQUIRED_INCLUDES ${Coarray_INCLUDE_DIR})

if(MPI_Fortran_FOUND)
  list(APPEND CMAKE_REQUIRED_LIBRARIES MPI::MPI_Fortran)
endif()

# sync all check needed to verify library
check_fortran_source_compiles(
"program a
implicit none
real :: x[*]
sync all
end program"
f08coarray
SRC_EXT f90
)

endfunction(check_coarray)


if(NOT DEFINED MPI_Fortran_FOUND)
  find_package(MPI COMPONENTS Fortran)
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL "Cray")
  check_coarray()
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel|NAG")

  if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
    if(WIN32)
      set(Coarray_COMPILE_OPTIONS /Qcoarray:shared)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
      set(Coarray_COMPILE_OPTIONS -coarray=shared)
      set(Coarray_LIBRARY -coarray=shared)  # ifort requires it at build AND link
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "NAG")
    set(Coarray_COMPILE_OPTIONS -coarray)
  endif()

  find_program(Coarray_EXECUTABLE NAMES mpiexec)

  set(Coarray_NUMPROC_FLAG -n)
  set(Coarray_REQUIRED_VARS Coarray_COMPILE_OPTIONS Coarray_EXECUTABLE)

  check_coarray()

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")

  if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    set(Coarray_COMPILE_OPTIONS -fcoarray=lib)
  endif()

  find_library(Coarray_LIBRARY
  NAMES caf_mpi caf_openmpi caf_mpich opencoarrays_mod
  PATHS /usr/lib/x86_64-linux-gnu/open-coarrays/openmpi/lib
  )

  find_path(Coarray_INCLUDE_DIR
  NAMES opencoarrays.mod
  PATHS /usr/lib/x86_64-linux-gnu/fortran/gfortran-mod-15
  )

  find_program(Coarray_EXECUTABLE
  NAMES cafrun
  PATHS /usr/lib/x86_64-linux-gnu/open-coarrays/openmpi/bin
  )

  set(Coarray_NUMPROC_FLAG -np)
  set(Coarray_REQUIRED_VARS Coarray_LIBRARY Coarray_EXECUTABLE)

  if(Coarray_LIBRARY AND Coarray_INCLUDE_DIR AND MPI_Fortran_FOUND)
    check_coarray()
  endif()

endif()


set(Coarray_MAX_NUMPROCS ${MPIEXEC_MAX_NUMPROCS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Coarray
REQUIRED_VARS ${Coarray_REQUIRED_VARS} f08coarray
)

if(Coarray_FOUND)
  set(Coarray_LIBRARIES ${Coarray_LIBRARY})
  set(Coarray_INCLUDE_DIRS ${Coarray_INCLUDE_DIR})

  if(NOT TARGET Coarray::Coarray)
    add_library(Coarray::Coarray INTERFACE IMPORTED)
    set_property(TARGET Coarray::Coarray PROPERTY INTERFACE_COMPILE_OPTIONS ${Coarray_COMPILE_OPTIONS})
    if(Coarray_INCLUDE_DIR)
      target_include_directories(Coarray::Coarray INTERFACE ${Coarray_INCLUDE_DIR})
    endif()
    if(Coarray_LIBRARY)
      target_link_libraries(Coarray::Coarray INTERFACE ${Coarray_LIBRARY})
    endif()
  endif()
endif()

mark_as_advanced(
Coarray_LIBRARY
Coarray_INCLUDE_DIR
Coarray_REQUIRED_VARS
)
