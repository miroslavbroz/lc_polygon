
f90 = gfortran
cc = g++

opt = -O3 -Jsrc
opt = -O3 -Jsrc -pg
opt = -O3 -Jsrc -fopenmp -flto -Ofast

obj = \
  src/const.o \
  src/input.o \
  src/polytype.o \
  src/vector_product.o \
  src/normalize.o \
  src/lambert.o \
  src/lommel.o \
  src/hapke.o \
  src/read_input.o \
  src/read_node.o \
  src/read_face.o \
  src/write_node.o \
  src/write_face.o \
  src/write_poly.o \
  src/write1.o \
  src/centre.o \
  src/normal.o \
  src/to_poly.o \
  src/uvw.o \
  src/boundingbox.o \
  src/clip.o \
  src/to_three.o \
  src/surface.o \
  src/planck.o \
  src/shadowing.o \
  src/gnuplot.o \

objc = \
  src/clip_in_c.o \
  clipper2/clipper.engine.o \

inc = \
  src/polytype.inc \
  src/integrate_over_S.inc \
  src/c1.inc \
  src/clip_in_c.h \

lib = -lstdc++

src/lc_polygon: src/lc_polygon.f90 $(obj) $(objc) $(inc)
	$(f90) $(opt) $(obj) $(objc) -o $@ $< $(lib)

$(obj): %.o:%.f90 $(inc)
	$(f90) $(opt) -o $@ -c $<

$(objc): %.o:%.cpp $(inc)
	$(cc) $(opt) -o $@ -c $<

clean:
	rm -f src/*.mod
	rm $(obj)

