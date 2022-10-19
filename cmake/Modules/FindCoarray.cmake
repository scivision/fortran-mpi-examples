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

set(options_coarray Intel IntelLLVM NAG)  # flags needed
set(native Cray)
set(opencoarray_supported GNU)

set(Coarray_LIBRARY)

if(CMAKE_Fortran_COMPILER_ID IN_LIST native)
  # pass
elseif(CMAKE_Fortran_COMPILER_ID IN_LIST options_coarray)

  if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
    if(WIN32)
      set(Coarray_COMPILE_OPTIONS /Qcoarray:shared)
    elseif(APPLE)
      set(Coarray_COMPILE_OPTIONS)
    else()
      set(Coarray_COMPILE_OPTIONS -coarray=shared)
      set(Coarray_LIBRARY -coarray=shared)  # ifort requires it at build AND link
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL NAG)
    set(Coarray_COMPILE_OPTIONS -coarray)
  endif()

  set(Coarray_REQUIRED_VARS Coarray_COMPILE_OPTIONS)

  find_program(Coarray_EXECUTABLE NAMES mpiexec)
  list(APPEND Coarray_REQUIRED_VARS Coarray_EXECUTABLE)

  set(Coarray_NUMPROC_FLAG -n)

elseif(CMAKE_Fortran_COMPILER_ID IN_LIST opencoarray_supported)

  add_library(Coarray::Coarray INTERFACE IMPORTED)

  if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    set(Coarray_COMPILE_OPTIONS -fcoarray=lib)
  endif()

  find_package(OpenCoarrays QUIET)
  if(OpenCoarrays_FOUND)
    target_link_libraries(Coarray::Coarray INTERFACE OpenCoarrays::opencoarrays_mod OpenCoarrays::caf_mpi_static)
    get_target_property(_l OpenCoarrays::caf_mpi_static LOCATION)
    set(Coarray_LIBRARY ${_l})
    get_target_property(_l OpenCoarrays::opencoarrays_mod LOCATION)
    list(APPEND Coarray_LIBRARY ${_l})
    get_target_property(_l OpenCoarrays::opencoarrays_mod INTERFACE_INCLUDE_DIRECTORIES)
    set(Coarray_INCLUDE_DIR ${_l})
  else()
    find_package(PkgConfig)
    pkg_search_module(pc_caf caf caf-openmpi caf-mpich)

    find_library(Coarray_LIBRARY
      NAMES ${pc_caf_LIBRARIES} opencoarrays_mod
      HINTS ${pc_caf_LIBRARY_DIRS})

    foreach(l caf_mpi caf_openmpi)
      find_library(Coarray_${l}_LIBRARY
        NAMES ${l}
        HINTS ${pc_caf_LIBRARY_DIRS})

      if(Coarray_${l}_LIBRARY)
        list(APPEND Coarray_LIBRARY ${Coarray_${l}_LIBRARY})
      endif()
    endforeach()

    find_path(Coarray_INCLUDE_DIR
      NAMES opencoarrays.mod
      HINTS ${pc_caf_INCLUDE_DIRS})

    target_include_directories(Coarray::Coarray INTERFACE ${Coarray_INCLUDE_DIR})
    target_link_libraries(Coarray::Coarray INTERFACE ${Coarray_LIBRARY})
    set_target_properties(Coarray::Coarray PROPERTIES
      INTERFACE_COMPILE_OPTIONS ${Coarray_COMPILE_OPTIONS})
  endif()

  set(Coarray_REQUIRED_VARS Coarray_LIBRARY)

  find_program(Coarray_EXECUTABLE NAMES cafrun)
  list(APPEND Coarray_REQUIRED_VARS Coarray_EXECUTABLE)

  set(Coarray_NUMPROC_FLAG -np)

endif()


include(ProcessorCount)
ProcessorCount(Nproc)
set(Coarray_MAX_NUMPROCS ${Nproc})

if(NOT MPI_Fortran_FOUND)
  find_package(MPI COMPONENTS Fortran)
endif()

if(Coarray_COMPILE_OPTIONS)
  set(CMAKE_REQUIRED_FLAGS ${Coarray_COMPILE_OPTIONS})
endif()
set(CMAKE_REQUIRED_LIBRARIES ${Coarray_LIBRARY} MPI::MPI_Fortran)
include(CheckFortranSourceRuns)
# sync all check needed to verify library
check_fortran_source_runs(
"program a
real :: x[*]
sync all
end program"
f08coarray
)
set(CMAKE_REQUIRED_FLAGS)
set(CMAKE_REQUIRED_LIBRARIES)

list(APPEND Coarray_REQUIRED_VARS f08coarray)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Coarray
REQUIRED_VARS ${Coarray_REQUIRED_VARS}
)

if(Coarray_FOUND)
  set(Coarray_LIBRARIES ${Coarray_LIBRARY})
  set(Coarray_INCLUDE_DIRS ${Coarray_INCLUDE_DIR})

  if(NOT TARGET Coarray::Coarray)
    add_library(Coarray::Coarray INTERFACE IMPORTED)
    set_target_properties(Coarray::Coarray PROPERTIES INTERFACE_COMPILE_OPTIONS ${Coarray_COMPILE_OPTIONS})
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
