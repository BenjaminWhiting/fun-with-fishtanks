# Ring

A floating corral for red root floaters, as big as the A1 mini's bed allows: 6 15/16" across, 1/2" wide, 9/16" tall.
Story and pictures: https://benjaminwhiting.github.io/fun-with-fishtanks/projects/ring.html

PETG sinks, so the ring floats on air sealed inside its hollow channel, split into eight chambers so one leak can't
sink it. The chambers have a 45-degree peaked roof, so it prints flat with no supports. Two solid lugs carry a
1/8" hole for fishing line or a suction-cup tether.

- `floater_ring.scad`: `OD`, `W`, `H`, wall `T`, `chambers` and the lugs are settings. `part = "cut"` shows the
  inside.
- `float_calc.py`: weight and float line from the STL: `python -I float_calc.py stl/floater_ring.stl 176 12 14`.
- `print/floater_ring_petg.gcode.3mf`: 2 h 10 m, 52 g PETG, four walls, no brim.

Float-test it in a bucket for a day before it goes in the tank: if one side sits low, a chamber leaks.
