project('FortranMPIexamples', 'fortran', 'c',
  version : files('VERSION'),
  meson_version: '>= 0.57.0',
  default_options : ['default_library=static', 'buildtype=release'])


fc = meson.get_compiler('fortran')

mpi = dependency('mpi', language : 'fortran', required : false, disabler: true)
code = '''
use mpi
integer :: i
call mpi_init(i)
call mpi_finalize(i)
end program'''
if not fc.links(code, dependencies : mpi, name: 'Fortran MPI links')
  mpi = disabler()
endif

mpiexec = find_program('mpiexec', required : false, disabler: true)  # MS-MPI has only mpiexec

subdir('mpi')
