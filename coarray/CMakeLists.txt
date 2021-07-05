# Coarrays are easier to use than MPI and more general as an intrinsic part of Fortran 2008.

# Linux: apt install libcoarrays-dev open-coarrays-bin
# Mac: brew install opencoarrays

include(CheckSourceRuns)

find_package(Coarray)

if(NOT (Coarray_FOUND AND MPI_Fortran_FOUND))
  message(STATUS "SKIP: Coarray")
  return()
endif()

# "sync all" call is necessary to actually verify dynamically linked MPI stack works.

set(CMAKE_REQUIRED_FLAGS)
set(CMAKE_REQUIRED_INCLUDES)
set(CMAKE_REQUIRED_LIBRARIES Coarray::Coarray)
check_source_runs(Fortran
"program test
sync all
end program"
f08coarray)

if(NOT f08coarray)
  message(STATUS "SKIP: Coarray")
  return()
endif()

check_source_runs(Fortran
"program test
real :: x[*]
call co_sum(x)
sync all
end program"
f18coarray)

add_executable(coarray_hello helloworld.f90)
target_link_libraries(coarray_hello PRIVATE Coarray::Coarray)
add_test(NAME coarray:Hello
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:coarray_hello>)
set_tests_properties(coarray:Hello PROPERTIES
RESOURCE_LOCK cpu_mpi
TIMEOUT 10)

if(f18coarray)
add_executable(coarray_pi pi.f90)
target_link_libraries(coarray_pi PRIVATE Coarray::Coarray)
add_test(NAME coarray:pi_sum
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:coarray_pi>)
set_tests_properties(coarray:pi_sum PROPERTIES
RESOURCE_LOCK cpu_mpi
TIMEOUT 10)
endif(f18coarray)
