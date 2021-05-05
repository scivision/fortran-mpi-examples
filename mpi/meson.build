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
