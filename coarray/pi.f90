program test_pi
!! implements calculation:
!! $$ \pi = \int^1_{-1} \frac{dx}{\sqrt{1-x^2}}

use, intrinsic:: iso_fortran_env, only: int64
implicit none

real, parameter :: x0 = -1, x1 = 1
real, parameter :: pi = 4*atan(1.)
real :: psum[*]  ! this is a scalar coarray
integer(int64) :: rate,tic,toc
real :: f,x,telaps, dx
integer :: i, stat, im, Ni
character(16) :: cbuf

psum = 0

if (command_argument_count() > 0) then
  call get_command_argument(1, cbuf)
  read(cbuf,*, iostat=stat) dx
  if (stat/=0) error stop 'must input real number for resolution e.g. 1e-6'
else
  dx = 1e-6
endif

Ni = int((x1-x0) / dx)    ! (1 - (-1)) / interval
im = this_image()

!---------------------------------
if (im == 1) then
  call system_clock(tic)
  print '(A,I3)', 'number of Fortran coarray images:', num_images()
  print *,'approximating pi in ',Ni,' steps.'
end if
!---------------------------------

do i = im, Ni-1, num_images() ! Each image works on a subset of the problem
  x = x0 + i*dx
  f = dx / sqrt(1 - x**2)
  psum = psum + f
!  print *,x,f,psum
end do

call co_sum(psum)

if (im == 1)  then
  print *,'pi:',pi,'  iterated pi: ',psum
  print '(A,E10.3)', 'pi error', pi - psum
endif

if (im == 1) then
  call system_clock(toc)
  call system_clock(count_rate=rate)
  telaps = real(toc - tic)  / real(rate)
  print '(A,E10.3,A,I3,A)', 'Elapsed wall clock time ', telaps, ' seconds, using',num_images(),' images.'
end if

end program
