! shadowing.f90
! Shadowing, non-convex version.
! Miroslav Broz (miroslav.broz@email.cz), Oct 26th 2022

module shadowing_module

contains

! Dicrectional cosine.

subroutine mu(normals, s, mu_i)

implicit none
double precision, dimension(:,:), pointer, intent(in) :: normals
double precision, dimension(3), intent(in) :: s
double precision, dimension(:), pointer, intent(out) :: mu_i

integer :: i

!$omp parallel do private(i) shared(normals,mu_i,s)
do i = 1, size(normals,1)
  mu_i(i) = max(dot_product(normals(i,:), s), 0.d0)
enddo
!$omp end parallel do

return
end subroutine mu

! Non-illuminated || non-visible won't be computed.

subroutine non(mu_i, mu_e, polys)

use polytype_module

implicit none
double precision, dimension(:), intent(in) :: mu_i, mu_e
type(polystype), dimension(:), intent(inout) :: polys

integer :: i

!$omp parallel do private(i) shared(mu_i,mu_e,polys)
do i = 1, size(mu_i,1)
  if ((mu_i(i).eq.0.d0).or.(mu_e(i).eq.0.d0)) then
    polys(i)%c = 0
  endif
enddo
!$omp end parallel do

return
end subroutine non

end module shadowing_module


