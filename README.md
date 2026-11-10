# Fun with Fishtanks

An experiment in pairing a 3D printer with an AI, using a 36" rimless aquarium as the test bench. I described what
I wanted in plain words; the AI wrote the models as code, checked them, sliced them and sent them to the printer;
I held the results against the glass and said what was wrong. So far that has made a riser for the light, a 1:48
Japanese boardwalk that clips onto the glass with a crooked bathhouse on its corner, and a floating ring for the plants.

**The story, with pictures: https://benjaminwhiting.github.io/fun-with-fishtanks/**

| Project | What it is | Status |
| --- | --- | --- |
| [Risers](projects/risers) | Lift a Hygger light 5": a clamp-on riser with a slatted bonsai, and a gate over the filter pump | Riser printed |
| [Walkway](projects/walkway) | 1:48 garden boardwalk along the back glass, with a fishing landing and a bathhouse end piece | Printing |
| [Ring](projects/ring) | A thin floating hoop for red root floaters, 6 15/16" across, with a printed chain and a clip for the glass | Printed |

## What's in here

```
projects/<name>/        OpenSCAD source (risers, walkway, walkway/bathhouse, ring), plus
    stl/                exported models
    print/              sliced, ready-to-print files (.gcode.3mf)
tools/                  slicing, checking and printer tools (see tools/README.md)
docs/                   the GitHub Pages site
CLAUDE.md               the standing rules the AI reads at the start of every session
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

## License

Models, print files, images and the site: [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).
Code in `tools/`: MIT. Details, including the Bambu Studio presets, in [LICENSE.md](LICENSE.md).
