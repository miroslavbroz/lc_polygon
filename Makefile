
f90 = gfortran
cc = g++

opt = -O3 -Jsrc
opt = -O3 -Jsrc -pg
opt = -O3 -Jsrc -fopenmp -flto -Ofast

obj = \
  src/polytype.o \
  src/vector_product.o \
  src/normalize.o \
  src/read_node.o \
  src/read_face.o \
  src/write_node.o \
  src/write_face.o \
  src/write_poly.o \
  src/centre.o \
  src/normal.o \
  src/to_poly.o \
  src/uvw.o \
  src/boundingbox.o \
  src/clip.o \
  src/to_three.o \

objc = \
  src/clip_in_c.o \
  src/clipper.engine.o \

inc = \

lib = -lstdc++

src/lc_polygon: src/lc_polygon.f90 $(obj) $(objc) $(inc)
	$(f90) $(opt) $(obj) $(objc) -o $@ $< $(lib)

$(obj): %.o:%.f90
	$(f90) $(opt) -o $@ -c $<

$(objc): %.o:%.cpp
	$(cc) $(opt) -o $@ -c $<

clean:
	rm src/*.mod
	rm $(obj)

