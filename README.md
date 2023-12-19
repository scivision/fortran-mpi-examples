# Fortran MPI Examples

[![cmake](https://github.com/scivision/fortran-mpi-examples/actions/workflows/cmake.yml/badge.svg)](https://github.com/scivision/fortran-mpi-examples/actions/workflows/cmake.yml)
A few very basic examples, perhaps use to test MPI-3 Fortran library functionality.

Free, popular MPI-3 interfaces for C and Fortran include:

* [OpenMPI](https://www.open-mpi.org/) (Linux, Mac)
* [MPICH](https://www.mpich.org/) (Linux, Mac)
* [Intel MPI](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/mpi-library.html) (Linux, Windows)

Build and self-test:

```sh
cmake --workflow --preset default
```

or step-by-step

```sh
cmake -Bbuild

cmake --build build

ctest --test-dir build -V
```

This repo also gives an example of a workaround for OpenMPI 4.x and mpiexec race condition with large CPU count by setting TMPDIR to a short path name so as not to exceed 100 characters for UNIX sockets.

## Message Passing

Pass data between two MPI threads.
In this usage, MPI_Recv blocks waiting for MPI_Send

```sh
mpiexec -np 2 mpi/mpi_pass
```

## Notes

See
[OpenMPI docs](https://www.open-mpi.org/faq/?category=running#adding-ompi-to-path)
re: setting PATH and LD_LIBRARY_PATH if CMake has trouble finding OpenMPI for a compiler.

* https://hpc-forge.cineca.it/files/CoursesDev/public/2017/MasterCS/CalcoloParallelo/MPI_Master2017.pdf

### MPI-3 Fortran

If "mpi_f08.mod" is not found, typically the MPI include directories are also missing.
You can manually check if mpi_f08.mod is preset under the include "-I" directories from:

```sh
mpif90 -show
```
