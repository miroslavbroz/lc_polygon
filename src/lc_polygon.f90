! lc_polygon.f90
! Test of lightcurve computation for a general polygonal mesh.
! Miroslav Broz (miroslav.broz@email.cz), Nov 1st 2022

! Notation:
!
! I_lambda       .. monochromatic intensity (ces. intenzita), W m^-2 sr^-1 m^-1
! I2_lambda      .. monochromatic intensity, scattered
! B_lambda       .. Planck monochromatic intensity
! Phi_lambda     .. monochromatic flux, W m^-2 m^-1
! Phi_lambda_cal .. monochromatic flux, calibration
! Phi_nu_cal     .. monochromatic flux, calibration, W m^-2 Hz^-1
! Phi_i          .. monochromatic flux, incoming
! Phi_V          .. passband flux, total, outgoing, W m^-2
! Phi_V_cal      .. passband flux, calibration
! J_lambda       .. monochromatic luminosity (ces. zarivost), W sr^-1 m^-1
! P_lambda       .. monochromatic power, W m^-1
! P_V            .. passband power, W
! mu_i           .. directional cosine, incoming, cos(alpha)
! mu_e           .. directional cosine, outgoing
! alpha          .. phase angle, sun-target-observer
! nu_i           .. shadowing, incoming, 0 or 1
! nu_e           .. shadowing, outgoing
! tau_i          .. visibility (mutual), cos(alpha)*cos(alpha')
! omega          .. solid angle, sr
! lambda_eff     .. effective wavelength, m
! Delta_eff      .. effective pasband, m
! f              .. bi-directional distribution function, 1
! f_L            .. Lambert law
! f_g            .. geometric law
! f_LS           .. Lommel-Seeliger law
! A_w            .. single-scattering albedo, 1
! A_hL           .. hemispherical albedo, Lambert
! A_gL           .. geometric albedo, Lambert
! A_BL           .. Bond albedo, Lambert

! nodes          .. nodes, m
! faces          .. triangular faces, 1
! elems          .. tetrahedral elements, 1
! poly1          .. sets of polygons, derived from triangles
! poly2          .. sets of polygons, transformed to line-of-sun
! poly3          .. sets of polygons, clipped (shadowing)
! poly4          .. sets of polygons, transformed to line-of-sight
! poly5          .. sets of polygons, clipped (visibility)
! normals        .. normals of polygons, 1
! centres        .. centres of polygons, m
! surf           .. surface of polygons, m^2
! vols           .. volumes of tetrahedra, m^3
! capR           .. radius, m
! capS           .. surface area, m^2
! capV           .. volume, m^3
! s              .. target->sun unitvector
! o              .. target->observer unitvector
! s_             .. ditto, 1st transformation
! o_             .. ditto, 1st transformation
! s__            .. ditto, 2nd transformation
! o__            .. ditto, 2nd transformation
! d1             .. target-sun distance, m
! d2             .. target-observer distance, m

program lc_polygon

use polytype_module
use input_module
use read_input_module
use read_face_module
use read_node_module
use write_node_module
use write_face_module
use write_poly_module
use write1_module
use normal_module
use centre_module
use to_poly_module
use uvw_module
use clip_module
use to_three_module
use surface_module
use planck_module
use hapke_module
use shadowing_module
use gnuplot_module

implicit none

integer, dimension(:,:), pointer :: faces, faces1, faces2
double precision, dimension(:,:), pointer :: nodes, nodes1, nodes2
type(polystype), dimension(:), pointer :: polys1, polys2, polys3, polys4, polys5

double precision, dimension(:,:), pointer :: normals, centres
double precision, dimension(:), pointer :: surf
double precision, dimension(:), pointer :: mu_i, mu_e, f, Phi_i
double precision, dimension(:), pointer :: I_lambda

integer :: i, j, k
double precision, dimension(3) :: r
double precision :: capR, capS, capV
double precision :: A_hL, A_gL, A_BL
double precision :: alpha, omega
double precision :: B_lambda, J_lambda, P_lambda, P_V, Phi_V, V0
double precision :: B_thermal, Phi_thermal
double precision :: tot, tmp
double precision :: t1, t2
character(len=80) :: str

! input parameters
call read_input()

! read 2 objects...
call read_node(f_node1, nodes1)
call read_face(f_face1, faces1)

call read_node(f_node2, nodes2)
call read_face(f_face2, faces2)

! units
nodes1 = nodes1*unit1
nodes2 = nodes2*unit2

! ... and merge them
allocate(nodes(size(nodes1,1)+size(nodes2,1), size(nodes1,2))) 
allocate(faces(size(faces1,1)+size(faces2,1), size(faces1,2))) 

do j = 1, size(nodes1,1)
  nodes(j,:) = nodes1(j,:)
enddo
do j = 1, size(nodes2,1)
  nodes(j+size(nodes1,1),:) = nodes2(j,:)
enddo
do j = 1, size(faces1,1)
  faces(j,:) = faces1(j,:)
enddo
do j = 1, size(faces2,1)
  faces(j+size(faces1,1),:) = faces2(j,:) + size(nodes1,1)
enddo

write(*,*) 'nnodes = ', size(nodes,1)
write(*,*) 'nfaces = ', size(faces,1)
write(*,*) ''

! allocation
allocate(polys1(size(faces,1)))
allocate(polys2(size(polys1,1)))
allocate(polys3(size(polys1,1)))
allocate(polys4(size(polys1,1)))
allocate(polys5(size(polys1,1)))
allocate(normals(size(polys1,1),3))
allocate(centres(size(polys1,1),3))
allocate(mu_i(size(polys1,1)))
allocate(mu_e(size(polys1,1)))
allocate(surf(size(polys1,1)))
allocate(f(size(polys1,1)))
allocate(Phi_i(size(polys1,1)))
allocate(I_lambda(size(polys1,1)))

! conversion
call to_poly(faces, nodes, polys1)

! geometry
call normal(polys1, normals)
call centre(polys1, centres)

call mu(normals, s, mu_i)
call mu(normals, o, mu_e)
alpha = acos(dot_product(s,o))

write(*,*) 'alpha = ', alpha, ' rad = ', alpha/deg, ' deg'

! stellar surface
B_lambda = planck(T_star, lambda_eff)
Phi_lambda = pi*B_lambda                ! over omega, half-space, cosine
J_lambda = pi*R_S**2 * B_lambda         ! over S, visible, cosine
P_lambda = 4.d0*pi * J_lambda           ! over omega, full-space
P_lambda = 4.d0*pi*R_S**2 * Phi_lambda  ! over S
P_V = Delta_eff*P_lambda                ! over lambda

write(*,*) '# at stellar surface:'
write(*,*) 'T_star = ', T_star, ' K'
write(*,*) 'lambda_eff = ', lambda_eff, ' m'
write(*,*) 'Delta_eff = ', Delta_eff, ' m'
write(*,*) 'B_lambda = ', B_lambda, ' W m^-2 sr^-1 m^-1'
write(*,*) 'Phi_lambda = ', Phi_lambda, ' W m^-2 m^-1'
write(*,*) 'J_lambda = ', J_lambda, ' W sr^-1 m^-1'
write(*,*) 'P_lambda = ', P_lambda, ' W m^-1'
write(*,*) 'P_V = ', P_V, ' W'
write(*,*) ''

! asteroid surface
Phi_lambda = P_lambda/(4.d0*pi*d1**2)
Phi_V = Phi_lambda*Delta_eff

f_L = A_w/(4.d0*pi)  ! sr^-1
A_hL = pi*f_L
A_gL = 2.d0/3.d0*pi*f_L
A_BL = pi*f_L

call init_hapke(alpha)

write(*,*) '# at asteroid surface:'
write(*,*) 'd1 = ', d1/au, ' au'
write(*,*) 'Phi_lambda = ', Phi_lambda, ' W m^-2 m^-1'
write(*,*) 'Phi_V = ', Phi_V, ' W m^-2'
write(*,*) 'f_L = ', f_L, ' sr^-1'
write(*,*) 'A_w = ', A_w
write(*,*) 'A_hL = ', A_hL
write(*,*) 'A_gL = ', A_gL
write(*,*) 'A_BL = ', A_BL
write(*,*) ''

B_thermal = planck(T_eq, lambda_eff)
Phi_thermal = pi*B_thermal

write(*,*) 'T_eq = ', T_eq, ' K'
write(*,*) 'B_thermal = ', B_thermal, ' W m^-2 sr^-1 m^-1'
write(*,*) 'Phi_thermal = ', Phi_thermal, ' W m^-2 m^-1'
write(*,*) ''

! observer location
omega = 1.d0/(d2**2)  ! sr

write(*,*) '# at observer location:'
write(*,*) 'd2 = ', d2/au, ' au'
write(*,*) 'omega = ', omega, ' sr'

! calibration
Phi_lambda_cal = Phi_nu_cal*clight/lambda_eff**2
Phi_V_cal = Delta_eff*Phi_lambda_cal

write(*,*) 'Phi_nu_cal = ', Phi_nu_cal, ' W m^-2 Hz^-1'
write(*,*) 'Phi_lambda_cal = ', Phi_lambda_cal, ' W m^-2 m^-1'
write(*,*) 'Phi_V_cal = ', Phi_V_cal, ' W m^-2'
write(*,*) ''

do k = 1, nsteps
  call cpu_time(t1)

  ! orbital motion (simplified)
  r = r_ + v_*dt*k

  do j = 1, size(nodes1,1)
    nodes(j,:) = nodes1(j,:)
  enddo
  do i = 1, size(nodes2,1)
    nodes(i+size(nodes1,1),:) = nodes2(i,:) + r
  enddo
  call to_poly(faces, nodes, polys1)
  call normal(polys1, normals)
  call centre(polys1, centres)

  ! non-illuminated || non-visible won't be computed
  call non(mu_i, mu_e, polys1)

  ! 1st transformation
  call uvw(s, polys1, polys2)
  call uvw_(nodes)
  call uvw_(normals)
  call uvw_(centres)

  o_ = (/dot_product(hatu,o), dot_product(hatv,o), dot_product(hatw,o)/)
  s_ = (/dot_product(hatu,s), dot_product(hatv,s), dot_product(hatw,s)/)

  ! shadowing
  call clip(polys2, polys3)

  ! back-projecion
  call to_three(normals, centres, polys3)

  ! 2nd transformation
  call uvw(o_, polys3, polys4)
  call uvw_(nodes)
  call uvw_(normals)
  call uvw_(centres)

  o__ = (/dot_product(hatu,o_), dot_product(hatv,o_), dot_product(hatw,o_)/)
  s__ = (/dot_product(hatu,s_), dot_product(hatv,s_), dot_product(hatw,s_)/)

  ! shadowing
  call clip(polys4, polys5)

  ! back-projecion
  call to_three(normals, centres, polys5)

  ! geometry
  capS = surface(polys5, normals, surf)

  ! integration
  include 'integrate_over_S.inc'

  ! lightcurve
  Phi_V = Delta_eff*omega*tot
  V0 = 0.d0 - 2.5d0*log10(Phi_V/Phi_V_cal)

  call cpu_time(t2)
  write(*,*) 'k = ', k, ' cpu_time = ', t2-t1, ' s'

  write(*,*) 'Phi_V = ', Phi_V, ' W m^-2'
  write(*,*) 'V0 = ', V0, ' mag'

  open(unit=20, file='lc.dat', access='append')
  write(20,*) k, V0
  close(20)

  ! debugging
  if (debug) then
    if ((k.eq.1).or.(k.eq.49).or.(k.eq.50)) then

      write(str,'(i0.2)') k
      call write_node("output.node." // trim(str), nodes)
      call write_face("output.face." // trim(str), faces)
      call write_node("output.normal." // trim(str), normals)
      call write_node("output.centre." // trim(str), centres)
  
      call write_poly("output.poly1." // trim(str), polys1)
      call write_poly("output.poly2." // trim(str), polys2)
      call write_poly("output.poly3." // trim(str), polys3)
      call write_poly("output.poly4." // trim(str), polys4)
      call write_poly("output.poly5." // trim(str), polys5)
  
      call write1("output.f." // trim(str), f)
      call write1("output.mu_i." // trim(str), mu_i)
      call write1("output.Phi_i." // trim(str), Phi_i)
      call write1("output.surf." // trim(str), surf)
      call write1("output.I_lambda." // trim(str), I_lambda)
    endif
  endif

  ! gnuplotting
  if (debug) then
    if (k.eq.1) then
      call gnuplot()
    endif
  endif

enddo  ! k

end program lc_polygon


