# Fun with Fishtanks: notes for Claude

3D-printed things for a 36" rimless aquarium (8 mm glass), designed in OpenSCAD and printed on a Bambu Lab A1 mini
in LAN mode. The repo is public, and `docs/` is its GitHub Pages site.

## Layout

- `projects/risers/`, `projects/walkway/` (with `bathhouse/`), `projects/ring/`: OpenSCAD source, plus `stl/` and
  `print/` (sliced `.gcode.3mf`). One site page per project: Risers, Walkway, Ring.
- `tools/`: checks, slicing and printer control (see `tools/README.md`). Site images are web-size WebP
  renders in `docs/img/<project>/`.
- Local only (git-ignored): `history/` (the design-history archive: camera frames and other people's photos),
  `sheets/` (full-size design sheets), `tools/printer.json` (printer IP), `tools/pylib/`.

## The printer

- **Never start, upload to, or stop the printer without the user's explicit go for that specific file.** An earlier
  "go ahead" doesn't carry over.
- Before every print: `python -I tools/preflight.py <file> <PETG|PLA>` must print ALL CHECKS PASSED, then check the
  plate is clear (`tools/snapshot.py` frame, or ask the user). Tell the user what prints, how long, and the material.
- Never run a printer-control script just to test it; test with `tools/bambu.py status`. `stop.py` acts the moment
  it runs.
- After any printer fault, don't restart until the user has found and fixed the cause.
- **No sound, ever:** no `M1006` lines in any print file. `tools/presets/machine.json` has none; check every new file.

## Publishing

- The repo is public: it holds sources, STLs, print files, rendered images, and real-world photos the user hands over
  for the site.
- Bambu Studio writes each model's full local path into a sliced file's metadata. `tools/slice.py` takes those out;
  run `tools/scrub_3mf.py` on any print file made another way before it's committed.
- Creating the GitHub repo, pushing and changing Pages settings need the user's go.
- Commits: no `Co-Authored-By` trailers and no "Generated with" lines.
- Licenses: models, images and the site are CC BY-NC-SA 4.0; the code in `tools/` is MIT (see `LICENSE.md`).

## Designing parts

- For a figure, character or stylised object, look at reference models and images first (a few, from the web), note what makes them read right, then model. Keep third-party images out of the repo.
- No supports: 45-degree undersides, flat faces on the plate. Check the exported STL with `tools/printcheck.py`.
- Parts plug together (pegs, bow-tie keys, tongue-and-groove with chamfered tips and mouths), never glue. Offer a
  small fit test before trusting a press fit on a big part.
- A part standing on a thin edge needs the full wall width on the plate. No brim on parts with holes near the edge.
- When feedback changes a design's direction, restate it and ask a few deciding questions before modelling.
- Sizes for the user are in inches (1/16" fractions); millimetres stay inside the CAD files.

## Working on this machine

- Windows with Git Bash. Bash heredocs can drop backslashes from Windows paths, so write any Python that contains
  Windows paths to a file instead of passing it through a heredoc.
- OpenSCAD 2021.01: `"C:/Program Files/OpenSCAD/openscad.com"`. Slicing: run `tools/slice.py` from `tools/presets`.
