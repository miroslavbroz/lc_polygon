! normal.f90
! Compute normals of faces.
! Miroslav Broz (miroslav.broz@email.cz), Aug 7th 2020

module normal_module

contains

subroutine normal(polys, normals)

use polytype_module
use vector_product_module
use normalize_module

implicit none
type(polystype), dimension(:), pointer, intent(in) :: polys
double precision, dimension(:,:), pointer, intent(out) :: normals

integer :: i
double precision, dimension(3) :: a, b, c, d

do i = 1, size(polys,1)
  if (polys(i)%c > 0) then
    a = polys(i)%s(1)%p(1,:)
    b = polys(i)%s(1)%p(2,:)
    c = polys(i)%s(1)%p(3,:)

    d = -vector_product(b-a, c-b)  ! minus; works for sphere.1.* (Blender), 22.1.* (Damit)
    d = normalize(d)
    normals(i,:) = d
  endif
enddo

end subroutine normal

end module normal_module


