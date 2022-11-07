! lc_polygon.f90
! Test of lightcurve computation for a general polygonal mesh.
! Miroslav Broz (miroslav.broz@email.cz), Nov 1st 2022

program lc_polygon

use polytype_module
use read_face_module
use read_node_module
use write_node_module
use write_face_module
use write_poly_module
use normal_module
use centre_module
use to_poly_module
use uvw_module
use clip_module
use to_three_module

implicit none

integer, dimension(:,:), pointer :: faces, faces1, faces2
double precision, dimension(:,:), pointer :: nodes, nodes1, nodes2
type(polystype), dimension(:), pointer :: polys1, polys2, polys3, polys4, polys5

double precision, dimension(:,:), pointer :: normals, centres

double precision, dimension(3) :: s, o, o_

integer :: i, j, k
double precision :: t1, t2

! read 2 objects...
call read_node("sphere.1.node", nodes1)
call read_face("sphere.1.face", faces1)

call read_node("sphere.1.node", nodes2)
call read_face("sphere.1.face", faces2)

! ... and merge them
allocate(nodes(size(nodes1,1)+size(nodes2,1), size(nodes1,2))) 
allocate(faces(size(faces1,1)+size(faces2,1), size(faces1,2))) 

do j = 1, size(nodes1,1)
  nodes(j,:) = nodes1(j,:)
enddo
do j = 1, size(nodes2,1)
  nodes(j+size(nodes1,1),:) = nodes2(j,:) + (/0.5d0, 0.d0, 2.5d0/)
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

call cpu_time(t1)

! conversion
call to_poly(faces, nodes, polys1)

! geometry
call normal(polys1, normals)
call centre(polys1, centres)

! 1st projection
s = (/0.d0, 0.d0, 1.d0/)
call uvw(s, polys1, polys2)
call uvw_(normals)
call uvw_(centres)

call write_poly("output.poly1", polys1)
call write_poly("output.poly2", polys2)

call write_node("output.node", nodes)
call write_face("output.face", faces)
call write_node("output.normal", normals)
call write_node("output.centre", centres)

! shadowing
call clip(polys2, polys3)

! back-projecion
call to_three(normals, centres, polys3)

! 2nd projection
o = (/0.d0, 0.d0, 1.d0/)
o_ = (/dot_product(hatu,o), dot_product(hatv,o), dot_product(hatw,o)/)
call uvw(o_, polys3, polys4)
call uvw_(normals)
call uvw_(centres)

! shadowing
call clip(polys4, polys5)

! back-projecion
call to_three(normals, centres, polys5)

call cpu_time(t2)
write(*,*) 'cpu_time = ', t2-t1, ' s'

! output
call write_poly("output.poly3", polys3)
call write_poly("output.poly4", polys4)
call write_poly("output.poly5", polys5)



end program lc_polygon


