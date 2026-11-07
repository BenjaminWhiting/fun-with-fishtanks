# Fun with Fishtanks

Designing and 3D-printing things for a 36" rimless aquarium: a riser for the light, a 1:48 Japanese
boardwalk that clips onto the glass, a crooked bathhouse at the end of it, and whatever the tank needs next.

**The story, with pictures: https://benjaminwhiting.github.io/fun-with-fishtanks/**

| Project | What it is | Status |
| --- | --- | --- |
| [Risers](projects/risers) | Lift a Hygger light 5": a clamp-on riser with a slatted bonsai, and a gate over the filter pump | Riser printed |
| [Walkway](projects/walkway) | 1:48 garden boardwalk along the back glass, with a fishing landing and a bathhouse end piece | Printing |
| [Ring](projects/ring) | A 6 15/16" floating corral for red root floaters, with eight sealed air chambers | Not printed yet |

## What's in here

```
projects/<name>/        OpenSCAD source (risers, walkway, walkway/bathhouse, ring), plus
    stl/                exported models
    print/              sliced, ready-to-print files (.gcode.3mf)
tools/                  slicing, checking and printer tools (see tools/README.md)
docs/                   the GitHub Pages site
```

## Printing

- The `.gcode.3mf` files are sliced for a **Bambu Lab A1 mini** (0.4 mm nozzle, textured PEI plate), mostly in
  PETG, with no start or finish tune. For any other printer, slice the STL yourself.
- Nothing needs supports. Parts join with pegs, bow-tie keys or tongue-and-groove joints, with no glue.
- The clamps are sized for 8 mm glass (an 8.4 mm slot). For other glass, print `projects/risers/glass_gauge.scad`,
  find the slot that fits, and change `slot` / `gauge_slot` in the source.

## Rebuilding a model

The sources need [OpenSCAD](https://openscad.org) (made with 2021.01). Each file has its settings at the top and a
`part` setting that picks what to build, for example:

```
openscad -o corner.stl -D 'part="corner_plate"' projects/walkway/boardwalk.scad
```
