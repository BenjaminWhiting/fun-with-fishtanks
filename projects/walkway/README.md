# Walkway

A 1:48 Japanese garden boardwalk that clips onto the top of the back glass, with a fishing landing in the middle
and a bathhouse as the back-left end piece.
Story and pictures: https://benjaminwhiting.github.io/fun-with-fishtanks/projects/walkway.html

## Boardwalk and centre landing

- `boardwalk.scad`: `part` = `corner_plate`, `plate` (one 6" straight with its railings and key), `filler_plate`,
  `centre_plate` (the T, upside down), `centre_rails_plate`, `lantern_fit_test`, and previews (`corner_preview`,
  `centre_preview`, `preview`). `slot` sets the glass slot; `tank_len` the run.
- `stl/`, `print/`: every plate. Segments lock together with the bow-tie keys printed on each plate.
- The centre lanterns are off (`rails_lanterns = false`) until their pegs are refitted.

## Bathhouse (`bathhouse/`)

- `bathhouse.scad`: the whole model. `scene` picks a render (`corner`, `joint`, `tank`, `plan`, `elev`, ...); the
  scenes import the boardwalk STLs in `scenery/`.
- `bathhouse_parts.scad`: the printable split. `part` = `base`, `ground`, `middle`, `roof`, `top`, `guide`,
  `chimney`, `fit` (joint fit test), `assembly`, `exploded`.
- `centre.scad`, `landing.scad`: shared pieces (railings, lanterns, the fisherman).
- `print/`: four plates, about 14 3/4 h and 276 g of PETG, plus a 27-minute fit test. Plate 1 base, plate 2 ground
  floor (upside down on its top edge), plate 3 middle, plate 4 roofs + top tier + light guide + chimney (upside down
  on its cap, with a brim ring to snap off).
