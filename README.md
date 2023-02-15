# Fortran Coarray and MPI Examples

[![cmake](https://github.com/scivision/fortran-coarray-mpi-examples/actions/workflows/cmake.yml/badge.svg)](https://github.com/scivision/fortran-coarray-mpi-examples/actions/workflows/cmake.yml)
[![oneapi-linux](https://github.com/scivision/fortran-coarray-mpi-examples/actions/workflows/oneapi-linux.yml/badge.svg)](https://github.com/scivision/fortran-coarray-mpi-examples/actions/workflows/oneapi-linux.yml)

A few very basic examples, perhaps use to test Coarray and MPI library functionality.
GCC/Gfortran, Intel oneAPI, NAG, Cray, IBM XL and other compilers support Fortran 2008 Coarrays.

Free, popular MPI-3 interfaces for C and Fortran include:

* [OpenMPI](https://www.open-mpi.org/) (Linux, Mac)
* [MPICH](https://www.mpich.org/) (Linux, Mac)
* [Intel MPI](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/mpi-library.html) (Linux, Windows)

Build and self-test:

```sh
cmake --workflow --preset default
```

This repo also gives an example of a workaround for OpenMPI 4.x and mpiexec race condition with large CPU count by setting TMPDIR to a short path name so as not to exceed 100 characters for UNIX sockets.

## Message Passing

Pass data between two MPI threads.
In this usage, MPI_Recv blocks waiting for MPI_Send

```sh
mpirun -np 2 mpi/mpi_pass
```

## Notes

See
[OpenMPI docs](https://www.open-mpi.org/faq/?category=running#adding-ompi-to-path)
re: setting PATH and LD_LIBRARY_PATH if CMake has trouble finding OpenMPI for a compiler.

* https://hpc-forge.cineca.it/files/CoursesDev/public/2017/MasterCS/CalcoloParallelo/MPI_Master2017.pdf
