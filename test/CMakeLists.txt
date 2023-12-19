add_executable(mpi_basic_C basic.c)
target_link_libraries(mpi_basic_C PRIVATE MPI::MPI_C)
add_test(NAME mpi_basic_C COMMAND mpi_basic_C)

add_executable(mpi_version_C mpivers.c)
target_link_libraries(mpi_version_C PRIVATE MPI::MPI_C)
add_test(NAME mpi_version_C COMMAND mpi_version_C)

# --- Fortran MPI-3

add_executable(mpi_basic_Fortran basic.f90)
target_link_libraries(mpi_basic_Fortran PRIVATE MPI::MPI_Fortran)
add_test(NAME mpi_basic_Fortran COMMAND mpi_basic_Fortran)

add_executable(mpi_version_Fortran mpivers.f90)
target_link_libraries(mpi_version_Fortran PRIVATE MPI::MPI_Fortran)
add_test(NAME mpi_version_Fortran COMMAND mpi_version_Fortran)

# --- more than one MPI image

add_executable(mpi_hello helloworld.f90)
target_link_libraries(mpi_hello PRIVATE MPI::MPI_Fortran)
add_test(NAME mpi_hello COMMAND mpi_hello)
set_property(TEST mpi_hello PROPERTY FIXTURES_SETUP mpi_fxt)

# --- actual message passing

add_executable(mpi_pass thread_pass.f90)
target_link_libraries(mpi_pass PRIVATE MPI::MPI_Fortran)

if(MPIEXEC_MAX_NUMPROCS GREATER_EQUAL 2)

add_test(NAME mpi_pass COMMAND mpi_pass)
set_property(TEST mpi_pass PROPERTY FIXTURES_REQUIRED mpi_fxt)

endif()

# --- test properties

get_property(tests DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set_property(TEST ${tests} PROPERTY cpu_mpi)

set_property(TEST ${tests} PROPERTY SKIP_REGULAR_EXPRESSION "No host list provided")

# convenience vars
set(single mpi_basic_C mpi_version_C mpi_basic_Fortran mpi_version_Fortran)
set(_m ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG})

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.29)

set_property(TEST ${single} PROPERTY TEST_LAUNCHER ${_m} 1)
set_property(TEST mpi_hello PROPERTY TEST_LAUNCHER ${_m} ${MPIEXEC_MAX_NUMPROCS})
set_property(TEST mpi_pass PROPERTY TEST_LAUNCHER ${_m} 2)

else()

set_property(TARGET ${single} PROPERTY CROSSCOMPILING_EMULATOR ${_m} 1)
set_property(TARGET mpi_hello PROPERTY CROSSCOMPILING_EMULATOR ${_m} ${MPIEXEC_MAX_NUMPROCS})
set_property(TARGET mpi_pass PROPERTY CROSSCOMPILING_EMULATOR ${_m} 2)

endif()

if(DEFINED mpi_tmpdir)
  set_property(TEST ${tests} PROPERTY ENVIRONMENT TMPDIR=${mpi_tmpdir})
endif()
