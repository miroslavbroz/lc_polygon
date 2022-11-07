
Test of lightcurve computation for a general polygonal mesh.

The following physics was already implemented:

- insolation
- shadowing (non-convex), eclipses, transits, ...
- Lambert law
- Lommel law
- Hapke law
- above-horizon test
- bounding-box test
- Openmp parallelization
- simplified motion
- lightcurve

![Screenshot](test_2spheres/output.I_lambda.01.png)
![Screenshot](test_2spheres/output.I_lambda.49.png)

2DO list:

- visibility (mutual)
- scatterring (mutual)
- simplified thermal contribution
- body rotation
- synthetic image (AO)
- integration with Vispy
- integration with Xitau?

