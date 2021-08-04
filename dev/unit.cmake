# Unit tests for FindMPI.cmake

function(get_flags exec outvar)

execute_process(COMMAND ${exec} -show
OUTPUT_STRIP_TRAILING_WHITESPACE
OUTPUT_VARIABLE ret
RESULT_VARIABLE code
TIMEOUT 10
)
if(NOT code EQUAL 0)
  return()
endif()

set(${outvar} ${ret} PARENT_SCOPE)

endfunction(get_flags)


function(get_link_flags raw outvar)


string(REGEX MATCHALL "(^| )(${CMAKE_LIBRARY_PATH_FLAG})([^\" ]+|\"[^\"]+\")" _Lflags "${raw}")
list(TRANSFORM _Lflags STRIP)
set(_flags ${_Lflags})

# check if compiler absolute path is first element and remove
if("${raw}" MATCHES "^/")
  if("${_flags}" MATCHES "^/")
    list(REMOVE_AT _flags 0)
  endif()
endif()

# Linker flags "-Wl,..."
string(REGEX MATCHALL "(^| )(-Wl,)([^\" ]+|\"[^\"]+\")" _Wflags "${raw}")
list(TRANSFORM _Wflags STRIP)
if(_Wflags)
  # this transform avoids CMake stripping out all "-Wl,rpath" after first.
  # Example:
  #  -Wl,rpath -Wl,/path/to/lib -Wl,rpath -Wl,/path/to/another
  list(TRANSFORM _Wflags REPLACE "-Wl," "LINKER:")
  list(APPEND _flags "${_Wflags}")
else()
  pop_flag("${raw}" -Xlinker _Xflags)
  if(_Xflags)
    set(CMAKE_C_LINKER_WRAPPER_FLAG "-Xlinker" " ")
    set(CMAKE_CXX_LINKER_WRAPPER_FLAG "-Xlinker" " ")
    set(CMAKE_Fortran_LINKER_WRAPPER_FLAG "-Xlinker" " ")
    string(REPLACE ";" "," _Xflags "${_Xflags}")
    list(APPEND _flags "LINKER:${_Xflags}")
  endif()
endif()

set(${outvar} "${_flags}" PARENT_SCOPE)

endfunction(get_link_flags)


function(pop_flag raw flag outvar)
# this gives the argument to flags to get their paths like -I or -l or -L

set(_v)
string(REGEX MATCHALL "(^| )${flag} *([^\" ]+|\"[^\"]+\")" _vars "${raw}")
foreach(_p IN LISTS _vars)
  string(REGEX REPLACE "(^| )${flag} *" "" _p "${_p}")
  list(APPEND _v "${_p}")
endforeach()

set(${outvar} ${_v} PARENT_SCOPE)

endfunction(pop_flag)


function(pop_path raw outvar)
# these are file paths without flags like /usr/lib/mpi.so

if(MSVC)
  return()
endif()

set(flag /)
set(_v)
string(REGEX MATCHALL "(^| )${flag} *([^\" ]+|\"[^\"]+\")" _vars "${raw}")
foreach(_p IN LISTS _vars)
  string(REGEX REPLACE "(^| )${flag} *" "" _p "${_p}")
  list(APPEND _v "/${_p}")
endforeach()

# check if compiler absolute path is first element and remove
if("${raw}" MATCHES "^/")
  list(REMOVE_AT _v 0)
endif()

set(${outvar} ${_v} PARENT_SCOPE)

endfunction(pop_path)


# ---- tests ----

set(CMAKE_LIBRARY_PATH_FLAG -L)

# Cray mpifort -show
function(cray_fortran)
set(f_raw "gfortran -I/cm/shared/apps/openmpi/gcc/64/3.1.2_gcc8/include -pthread -I/cm/shared/apps/openmpi/gcc/64/3.1.2_gcc8/lib -L/usr/lib64 -L/opt/mellanox/mxm/lib -Wl,-rpath -Wl,/usr/lib64 -Wl,-rpath -Wl,/opt/mellanox/mxm/lib -Wl,-rpath -Wl,/cm/shared/apps/openmpi/gcc/64/3.1.2_gcc8/lib -Wl,--enable-new-dtags -L/cm/shared/apps/openmpi/gcc/64/3.1.2_gcc8/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi")

pop_flag(${f_raw} -I inc_dirs)
pop_flag(${f_raw} ${CMAKE_LIBRARY_PATH_FLAG} lib_dirs)

pop_flag(${f_raw} -l lib_names)

pop_path(${f_raw} lib_paths)

get_link_flags(${f_raw} MPI_Fortran_LINK_FLAGS)

# Cray unit test
if(lib_paths)
  message(FATAL_ERROR "lib_paths not present in Cray mpifort -show")
endif()

set(MPI_Fortran_LINK_FLAGS "${MPI_Fortran_LINK_FLAGS}" PARENT_SCOPE)
endfunction(cray_fortran)

cray_fortran()

message(STATUS "
MPI_Fortran_INCLUDE_DIR: ${inc_dirs}
MPI_Fortran_LIBRARY_DIR: ${lib_dirs}
MPI_Fortran_LIBRARY_NAMES: ${lib_names}
MPI_Fortran_LIBRARY: ${lib_paths}
MPI_Fortran_LINK_FLAGS: ${MPI_Fortran_LINK_FLAGS}
")
