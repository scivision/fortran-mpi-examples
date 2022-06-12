set_directory_properties(PROPERTIES LABELS coarray)

add_executable(coarray_hello helloworld.f90)
target_link_libraries(coarray_hello PRIVATE Coarray::Coarray)
add_test(NAME cobasic
COMMAND ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} $<TARGET_FILE:coarray_hello>)

add_executable(coarray_pi pi.f90)
target_link_libraries(coarray_pi PRIVATE Coarray::Coarray)
add_test(NAME pisum
COMMAND ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} $<TARGET_FILE:coarray_pi>)


set_tests_properties(cobasic pisum PROPERTIES
RESOURCE_LOCK cpu_mpi
TIMEOUT 10)
