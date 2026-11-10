# Ring

A floating hoop that keeps red root floaters in one patch, with a printed chain and a clip to hold it in place.
Story and pictures: https://benjaminwhiting.github.io/fun-with-fishtanks/projects/ring.html

PETG sinks, so the ring floats on air sealed inside it, split into eight chambers so one leak can't sink it.

## The thin ring (the one that printed)

6 15/16" across, 5/32" wide from above and 1/4" deep: a flat top with a rounded keel underneath. It prints upside
down, flat top on the plate, with no supports, and floats flat side up with about 1/32" showing. A chain eye hangs
under the front and the back.

- `floater_ring.scad`: `part = "d_large"` (also `d_medium`, `d_small`, and `d_cut` to see inside). Slice it with two
  wall loops.
- `tether.scad`: the print-in-place chain (27 links, about 6", a snap hook at each end), a one-hook chain, and the
  clip for the tank's 8 mm glass. `part = "plate"` puts the ring, the chain and the clip on one plate.
- `print/ring_tether_petg.gcode.3mf`: ring, chain and clip together, 41 m, 10 g PETG.
- `print/ring_thin_large_petg.gcode.3mf`: the ring alone, 27 m, 8 g.
- `print/chain_snap_hooks_petg.gcode.3mf`, `print/chain_one_hook_petg.gcode.3mf`: the chains alone, 16 m each.

## Earlier tries

- The first design was a box section 1/2" wide and 9/16" tall (`part = "ring"` with `W = 12`, `H = 14`, `T = 1.7`):
  `print/floater_ring_petg.gcode.3mf`, 2 h 10 m, 52 g. Three sizes of it nested on one plate
  (`print/rings_3_nested_petg.gcode.3mf`) looked far too thick once they started printing.
- A slimmer box, 5/16" by 3/8" (the current `W`, `H` and `T`), was sliced and never printed:
  `print/ring_large_slim_petg.gcode.3mf` and `print/ring_medium_slim_petg.gcode.3mf`.
- `float_calc.py` works out weight and float line for a box ring from its STL:
  `python -I float_calc.py stl/floater_ring.stl 176 8 10`.
