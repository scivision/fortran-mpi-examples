mpiexec = find_program('mpiexec', required : false, disabler: true)  # MS-MPI has only mpiexec

# -- Fortran coarray

coarray = dependency('coarray', required : false, disabler: true)
# must be "run" in case of broken MPI library that only shows up on run.
if not (fc.run('sync all; end', dependencies: coarray, name:'Coarray').returncode() == 0)
  coarray = disabler()
endif

# ---

hello = executable('coarray_hello', 'helloworld.f90', dependencies : coarray)
test('Coarray Hello', hello, timeout: 20, suite: 'coarray', is_parallel : false)

pi = executable('coarray_pi', 'pi.f90', dependencies : coarray)

test('Coarray Pi', pi, timeout: 20, suite: 'coarray', is_parallel : false)
