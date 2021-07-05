# Coarrays are easier to use than MPI and more general as an intrinsic part of Fortran 2008.

# Linux: apt install libcoarrays-dev open-coarrays-bin
# Mac: brew install opencoarrays

include(CheckSourceRuns)

find_package(Coarray)

if(NOT Coarray_FOUND)
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
COMMAND ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} $<TARGET_FILE:coarray_hello>)
set_tests_properties(coarray:Hello PROPERTIES
RESOURCE_LOCK cpu_mpi
TIMEOUT 10)

if(f18coarray)
add_executable(coarray_pi pi.f90)
target_link_libraries(coarray_pi PRIVATE Coarray::Coarray)
add_test(NAME coarray:pi_sum
COMMAND ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} $<TARGET_FILE:coarray_pi>)
set_tests_properties(coarray:pi_sum PROPERTIES
RESOURCE_LOCK cpu_mpi
TIMEOUT 10)
endif(f18coarray)
