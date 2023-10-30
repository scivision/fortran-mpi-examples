set_property(DIRECTORY PROPERTY LABELS mpi)

add_executable(mpi_basic-C basic.c)
target_link_libraries(mpi_basic-C MPI::MPI_C)
add_test(NAME mpi_Cbasic
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 1 $<TARGET_FILE:mpi_basic-C>
)

add_executable(mpi_version-C mpivers.c)
target_link_libraries(mpi_version-C MPI::MPI_C)
add_test(NAME mpi_Cversion
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 1 $<TARGET_FILE:mpi_version-C>
)

# --- Fortran MPI-3

add_executable(mpi_basic basic.f90)
target_link_libraries(mpi_basic MPI::MPI_Fortran)
add_test(NAME mpi_Fbasic
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 1 $<TARGET_FILE:mpi_basic>
)

add_executable(mpi_version mpivers.f90)
target_link_libraries(mpi_version MPI::MPI_Fortran)
add_test(NAME mpi_version
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 1 $<TARGET_FILE:mpi_version>
)

# --- more than one MPI image

add_executable(mpi_hello helloworld.f90)
target_link_libraries(mpi_hello MPI::MPI_Fortran)

add_test(NAME mpi:hello
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:mpi_hello>
)
set_property(TEST mpi:hello PROPERTY FIXTURES_SETUP mpi_fxt)

# --- actual message passing

add_executable(mpi_pass thread_pass.f90)
target_link_libraries(mpi_pass MPI::MPI_Fortran)

if(MPIEXEC_MAX_NUMPROCS GREATER_EQUAL 2)

add_test(NAME mpi:pass
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:mpi_pass>
)
set_property(TEST mpi:pass PROPERTY FIXTURES_REQUIRED mpi_fxt)

endif()


get_property(tests DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_property(TEST ${tests} PROPERTY cpu_mpi)

if(DEFINED mpi_tmpdir)
  set_property(TEST ${tests} PROPERTY ENVIRONMENT TMPDIR=${mpi_tmpdir})
endif()
