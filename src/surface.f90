! surface.f90
! Compute surface area of polygons.
! Miroslav Broz (miroslav.broz@email.cz), Nov 7th 2022

! Note: Some polygons have negative S, if they represent "holes".

module surface_module

contains

double precision function surface(polys, normals, surf)

use polytype_module

implicit none
type(polystype), dimension(:), pointer, intent(in) :: polys
double precision, dimension(:,:), pointer, intent(in) :: normals
double precision, dimension(:), pointer, intent(out) :: surf

integer :: i, j, k
double precision :: S, tmp
double precision, dimension(3) :: a, b, c, d

S = 0.d0
surf = 0.d0

do i = 1, size(polys,1)
  d = normals(i,:)
  do j = 1, polys(i)%c
    tmp = 0.d0
    do k = 2, polys(i)%s(j)%c-1
      a = polys(i)%s(j)%p(1,:)
      b = polys(i)%s(j)%p(k,:)
      c = polys(i)%s(j)%p(k+1,:)
      tmp = s1(a, b, c, d)
    enddo
    surf(i) = tmp
    S = S + surf(i)
  enddo
enddo

surface = S
return
end function surface

double precision function s1(a, b, c, d)

use vector_product_module

implicit none

double precision, dimension(3), intent(in) :: a, b, c, d
double precision, dimension(3) :: tmp

tmp = vector_product(b-a, c-a)
s1 = 0.5d0*sqrt(dot_product(tmp, tmp))
if (dot_product(tmp, d).lt.0.d0) then
  s1 = -s1
endif

end function s1

end module surface_module


