project('FortranMPIexamples', 'fortran', 'c',
meson_version: '>= 1.5.0'
)


fc = meson.get_compiler('fortran')

mpi = dependency('mpi', language : 'fortran', required : true)

code = '''
use mpi
integer :: i
call mpi_init(i)
call mpi_finalize(i)
end program'''

fc.links(code, dependencies : mpi, name: 'Fortran MPI links', required: true)

mpiexec = find_program('mpiexec', required : true)
# MS-MPI has only mpiexec

subdir('test')
