project('FortranMPIexamples', 'fortran', 'c',
  version : files('VERSION'),
  meson_version: '>= 0.57.0',
  default_options : ['default_library=static', 'buildtype=release'])

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

basic = executable('basic_f', 'basic.f90', dependencies : mpi)
test('MPI Basic', basic, timeout : 5)


ver = executable('mpivers', 'mpivers.f90', dependencies : mpi)
test('MPI version check', ver, timeout: 10)

hello = executable('mpi_hello', 'helloworld.f90',
  dependencies : mpi)
test('MPI Hello World', mpiexec,
  is_parallel : false,
  args: ['-np', '2', hello],
  timeout: 20)


pass = executable('mpi_pass', 'thread_pass.f90', dependencies : mpi)
test('MPI thread pass', mpiexec,
  is_parallel : false,
  args: ['-np', '2', pass],
  timeout: 20)
