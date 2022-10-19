set_property(DIRECTORY PROPERTY LABELS coarray)

add_executable(coarray_hello helloworld.f90)
target_link_libraries(coarray_hello PRIVATE Coarray::Coarray)
add_test(NAME cobasic
COMMAND ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} $<TARGET_FILE:coarray_hello>)

add_executable(coarray_pi pi.f90)
target_link_libraries(coarray_pi PRIVATE Coarray::Coarray)
add_test(NAME pisum
COMMAND ${Coarray_EXECUTABLE} ${Coarray_NUMPROC_FLAG} ${Coarray_MAX_NUMPROCS} $<TARGET_FILE:coarray_pi>)


set_property(TEST cobasic pisum PROPERTY RESOURCE_LOCK cpu_mpi)
