add_executable(mpi_basic_C basic.c)
target_link_libraries(mpi_basic_C PRIVATE MPI::MPI_C)
add_test(NAME MPIbasicC COMMAND mpi_basic_C)
test_mpi_launcher(mpi_basic_C MPIbasicC 1)

add_executable(mpi_version_C mpivers.c)
target_link_libraries(mpi_version_C PRIVATE MPI::MPI_C)
add_test(NAME MPIversionC COMMAND mpi_version_C)
test_mpi_launcher(mpi_version_C MPIversionC 1)

# --- Fortran MPI-3

add_executable(mpi_basic_Fortran basic.f90)
target_link_libraries(mpi_basic_Fortran PRIVATE MPI::MPI_Fortran)
add_test(NAME MPIbasicFortran COMMAND mpi_basic_Fortran)
test_mpi_launcher(mpi_basic_Fortran MPIbasicFortran 1)

add_executable(mpi_version_Fortran mpivers.f90)
target_link_libraries(mpi_version_Fortran PRIVATE MPI::MPI_Fortran)
add_test(NAME MPIversionFortran COMMAND mpi_version_Fortran)
test_mpi_launcher(mpi_version_Fortran MPIversionFortran 1)


# --- more than one MPI image

add_executable(mpi_hello helloworld.f90)
target_link_libraries(mpi_hello PRIVATE MPI::MPI_Fortran)
add_test(NAME MPIhello COMMAND mpi_hello)
test_mpi_launcher(mpi_hello MPIhello ${MPIEXEC_MAX_NUMPROCS})
set_property(TEST MPIhello PROPERTY FIXTURES_SETUP mpi_fxt)

# --- actual message passing

if(MPI_Fortran_VERSION VERSION_GREATER 3.0)

add_executable(mpi_pass thread_pass.f90)
target_link_libraries(mpi_pass PRIVATE MPI::MPI_Fortran)

add_test(NAME MPIpass COMMAND mpi_pass)
test_mpi_launcher(mpi_pass MPIpass 2)

set_tests_properties(MPIpass PROPERTIES
LABELS "Fortran"
DISABLED $<VERSION_LESS:${MPIEXEC_MAX_NUMPROCS},2>
FIXTURES_REQUIRED mpi_fxt
)


endif()

# --- test properties

get_property(tests DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set_tests_properties(${tests} PROPERTIES
RESOURCE_LOCK mpi
SKIP_REGULAR_EXPRESSION "No host list provided"
)

set_tests_properties(MPIbasicC MPIversionC PROPERTIES LABELS "C")
set_tests_properties(MPIbasicFortran MPIversionFortran MPIhello
PROPERTIES LABELS "Fortran")
