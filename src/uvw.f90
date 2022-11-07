! uvw.f90
! Compute (u, v, w) coordinates
! Miroslav Broz (miroslav.broz@email.cz), Nov 5th 2022

! Note: see polytype.f90

module uvw_module

double precision, dimension(3) :: hatu, hatv, hatw

contains

subroutine uvw(s, polys1, polys2)

use polytype_module
use vector_product_module

implicit none
double precision, dimension(3), intent(in) :: s
type(polystype), dimension(:), pointer, intent(in) :: polys1
type(polystype), dimension(:), pointer, intent(out) :: polys2

integer :: i, j, k
double precision :: tmp

! new basis
hatw = s
hatu = (/-s(2), s(1), 0.d0/)
tmp = sqrt(dot_product(hatu,hatu))
if (tmp.gt.0.d0) then
  hatu = hatu/tmp
else
  hatu = (/1.d0, 0.d0, 0.d0/)
endif
hatv = -vector_product(hatu, hatw)

!$omp parallel do private(i,j,k) shared(polys1,polys2,hatu,hatv,hatw)
do i = 1, size(polys1,1)

  polys2(i)%c = polys1(i)%c

  do j = 1, polys1(i)%c

    polys2(i)%s(j)%c = polys1(i)%s(j)%c

    do k = 1, polys1(i)%s(j)%c

      polys2(i)%s(j)%p(k,1) = dot_product(hatu, polys1(i)%s(j)%p(k,:))
      polys2(i)%s(j)%p(k,2) = dot_product(hatv, polys1(i)%s(j)%p(k,:))
      polys2(i)%s(j)%p(k,3) = dot_product(hatw, polys1(i)%s(j)%p(k,:))

    enddo
  enddo
enddo
!$omp end parallel do

return
end subroutine uvw

subroutine uvw_(normals)

implicit none
double precision, dimension(:,:), pointer, intent(inout) :: normals

integer :: i
double precision :: u, v, w

!$omp parallel do private(i,u,v,w) shared(normals,hatu,hatv,hatw)
do i = 1, size(normals,1)
  u = dot_product(hatu, normals(i,:))
  v = dot_product(hatv, normals(i,:))
  w = dot_product(hatw, normals(i,:))
  normals(i,:) = (/u, v, w/)
enddo
!$omp end parallel do

return
end subroutine uvw_

end module uvw_module


