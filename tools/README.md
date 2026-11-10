# Tools

Scripts for checking, slicing and printing on a Bambu Lab A1 mini in LAN mode, from Windows.

## Setup

1. `pip install -r requirements.txt` (from the repo root).
2. Put the printer in LAN mode with developer mode on, and add it in Bambu Studio once: the serial and LAN access
   code are read from Bambu Studio's config and never printed.
3. Copy `printer.example.json` to `printer.json` and set the printer's IP. `printer.json` is git-ignored.
4. Install [OpenSCAD](https://openscad.org) and Bambu Studio (`slice.py` expects it in `C:\Program Files\Bambu Studio`).

## The scripts

| Script | What it does |
| --- | --- |
| `printcheck.py <stl>` | Slices an STL every 0.2 mm and reports anything that would print in mid-air (islands, long ledges, long bridges). |
| `layer_check.py <stl>` | An older, simpler support check for parts whose holes run along X. |
| `audit_stl.py` | STL loading and measuring helpers. |
| `slice.py <out dir> <name.gcode.3mf> <filament.json> <model.stl>` | Runs Bambu Studio's command-line slicer. Run it from `presets/`. It clicks away the "DLLs have been injected" warning (from a sound driver) that otherwise hangs the slicer. |
| `scrub_3mf.py <file.gcode.3mf>` | Takes local folder paths (which include your user name) out of a sliced file's metadata. `slice.py` runs it for you; the G-code isn't touched. |
| `preflight.py <file.gcode.3mf> <PETG\|PLA>` | Checks a file before it's sent: intact, sliced for the A1 mini, every move (arcs included) inside the A1 mini's range, material, and the printer idle with the right spool. Only send a file that prints ALL CHECKS PASSED. |
| `plot_toolpath.py`, `gcode_envelope.py` | Draw and measure a file's moves. |
| `snapshot.py <out.jpg>` | Grabs one frame from the printer's camera, to see that the plate is clear. |
| `bambu.py status` / `upload <file> <name>` / `print <name>` | Printer status, upload over FTPS, and start a print. |
| `stop.py` | Stops the print at once and turns the heaters off. It takes no arguments. |
| `flatten.py` | Flattens Bambu Studio presets (resolving their `inherits`). |
| `collect_history.py` | Copies design images into the local, git-ignored `history/` archive. |

`presets/` holds the machine, process and filament settings. `machine.json` has no start or finish tune.

## Before every print

Run `preflight.py`, check the plate is empty (camera or in person), then upload and print. After any printer
fault, find and fix the cause before starting again.
