! surface.f90
! Compute surface area of polygons.
! Miroslav Broz (miroslav.broz@email.cz), Nov 8th 2022

! Note: Some polygons have negative S, if they represent "holes".

! Reference: https://math.stackexchange.com/questions/3207981/how-do-you-calculate-the-area-of-a-2d-polygon-in-3d

module surface_module

contains

double precision function surface(polys, surf)

use polytype_module
use vector_product_module

implicit none
type(polystype), dimension(:), pointer, intent(in) :: polys
double precision, dimension(:), pointer, intent(out) :: surf

integer :: i, j, k, l
double precision :: S
double precision, dimension(3) :: a, b, c, tmp

S = 0.d0
surf = 0.d0

!$omp parallel do reduction(+:S) private(i,j,k,tmp,a,b,c) shared(polys,surf)
do i = 1, size(polys,1)
  surf(i) = 0.d0
  do j = 1, polys(i)%c
    tmp = 0.d0
    l = polys(i)%s(j)%c
    a = polys(i)%s(j)%p(1,:)
    do k = 2, l-1
      b = polys(i)%s(j)%p(k,:)
      c = polys(i)%s(j)%p(k+1,:)
      tmp = tmp + vector_product(b-a,c-a)
    enddo
    surf(i) = surf(i) + 0.5d0*sqrt(dot_product(tmp,tmp))
  enddo
  S = S + surf(i)
enddo
!$omp end parallel do

surface = S
return
end function surface

end module surface_module


