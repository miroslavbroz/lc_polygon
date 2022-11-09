! gnuplot.f90
! Gnuplotting.
! Miroslav Broz (miroslav.broz@email.cz), Nov 8th 2022

module gnuplot_module

contains

subroutine gnuplot()

use input_module

open(unit=10, file='output.gnu', status='unknown')
write(10,*) 's1 = ', s(1)
write(10,*) 's2 = ', s(2)
write(10,*) 's3 = ', s(3)
write(10,*) 'o1 = ', o(1)
write(10,*) 'o2 = ', o(2)
write(10,*) 'o3 = ', o(3)
write(10,*) 's1_ = ', s_(1)
write(10,*) 's2_ = ', s_(2)
write(10,*) 's3_ = ', s_(3)
write(10,*) 'o1_ = ', o_(1)
write(10,*) 'o2_ = ', o_(2)
write(10,*) 'o3_ = ', o_(3)
write(10,*) 's1__ = ', s__(1)
write(10,*) 's2__ = ', s__(2)
write(10,*) 's3__ = ', s__(3)
write(10,*) 'o1__ = ', o__(1)
write(10,*) 'o2__ = ', o__(2)
write(10,*) 'o3__ = ', o__(3)
close(10)

return
end subroutine gnuplot

end module gnuplot_module


