"""Final safety checks on a sliced .gcode.3mf before it goes to the A1 mini.

Usage: python -I preflight.py <file.gcode.3mf> <PLA|PETG>
Exits 0 only if every check passes.
"""
import hashlib
import math
import re
import sys
import zipfile

sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
import bambu  # noqa: E402

BED = 180.0
# range of every move in Bambu-sliced A1 mini files (purge line, brush, wipe spot included),
# measured along arcs: the start-up nozzle wipe circles bulge to Y 186
REF = {"X": (-13.5, 187.0), "Y": (-4.0, 186.0), "Z": (-1.0, 180.0)}


def arc_points(start, end, i, j, clockwise, n=32):
    """Points along a G2/G3 arc in XY, end point included."""
    cx, cy = start[0] + i, start[1] + j
    r = math.hypot(start[0] - cx, start[1] - cy)
    a0 = math.atan2(start[1] - cy, start[0] - cx)
    a1 = math.atan2(end[1] - cy, end[0] - cx)
    sweep = ((a0 - a1) if clockwise else (a1 - a0)) % (2 * math.pi) or 2 * math.pi
    s = -1 if clockwise else 1
    return [(cx + r * math.cos(a0 + s * sweep * k / n), cy + r * math.sin(a0 + s * sweep * k / n))
            for k in range(1, n + 1)]


def walk(g):
    """Every point the nozzle passes (x, y, z), the printed ones, and the top layer height."""
    pos, rel, part, allm, zmax_layer = {"X": 0.0, "Y": 0.0, "Z": 0.0}, False, [], [], 0.0
    in_print = False
    for line in g.splitlines():
        if line.startswith("; CHANGE_LAYER"):
            in_print = True
        if line.startswith("; Z_HEIGHT:"):
            zmax_layer = max(zmax_layer, float(line.split(":")[1]))
        if "machine_end" in line.lower() and line.startswith(";="):
            in_print = False
        c = line.split(";")[0].strip()
        if c.startswith("G90"):
            rel = False
        elif c.startswith("G91"):
            rel = True
        elif re.match(r"G[0-3]\b", c):
            start = (pos["X"], pos["Y"])
            for k, v in re.findall(r"([XYZ])(-?[\d.]+)", c):
                pos[k] = pos[k] + float(v) if rel else float(v)
            pts = [(pos["X"], pos["Y"])]
            ij = dict(re.findall(r"([IJ])(-?[\d.]+)", c))
            if c[:2] in ("G2", "G3") and ij:
                pts = arc_points(start, pts[0], float(ij.get("I", 0)), float(ij.get("J", 0)), c.startswith("G2"))
            allm += [(x, y, pos["Z"]) for x, y in pts]
            if in_print and re.search(r"\bE\d*\.?\d+", c):
                part += pts
    return allm, part, zmax_layer


def main(path, material):
    z = zipfile.ZipFile(path)
    raw = z.read("Metadata/plate_1.gcode")
    g = raw.decode("utf-8", "replace")
    checks = []

    def check(name, ok, detail):
        checks.append(ok)
        print(f"  [{'PASS' if ok else 'FAIL'}] {name}: {detail}")

    md5 = z.read("Metadata/plate_1.gcode.md5").decode().strip().lower()
    check("file intact", hashlib.md5(raw).hexdigest() == md5, f"md5 {md5[:12]}...")
    head = re.search(r"^;===== machine: (.+?) =", g, re.M)
    check("sliced for A1 mini", bool(head) and head.group(1).strip() == "A1 mini", head.group(1) if head else "no header")
    area = re.search(r"^; printable_area = (.+)$", g, re.M).group(1)
    height = float(re.search(r"^; printable_height = (.+)$", g, re.M).group(1))
    check("bed size in file", area.strip() == "0x0,180x0,180x180,0x180" and height == BED, f"{area}, height {height:g}")

    allm, part, zmax_layer = walk(g)
    px = [p[0] for p in part]
    py = [p[1] for p in part]
    check("part inside the bed", min(px) >= 0 and max(px) <= BED and min(py) >= 0 and max(py) <= BED,
          f"X {min(px):.1f}..{max(px):.1f}, Y {min(py):.1f}..{max(py):.1f} (bed 0..180)")
    check("part height", zmax_layer <= BED, f"top layer at {zmax_layer:.2f} mm (limit 180)")
    lo = [min(p[i] for p in allm) for i in range(3)]
    hi = [max(p[i] for p in allm) for i in range(3)]
    check("all moves in A1 mini range (arcs followed)",
          all(REF[k][0] - 0.1 <= lo[i] and hi[i] <= REF[k][1] + 0.1 for i, k in enumerate("XYZ")),
          ", ".join(f"{k} {lo[i]:.1f}..{hi[i]:.1f}" for i, k in enumerate("XYZ")))
    fil = re.search(r"^; filament_type = (.+)$", g, re.M).group(1).strip()
    check("material matches", fil == material, f"file {fil}, expected {material}")

    rc, reps = bambu.mqtt_session()
    p = bambu.merged_print(reps)
    tray = p.get("vt_tray", {}).get("tray_type")
    check("printer reachable", rc == "Success", rc)
    check("printer idle", p.get("gcode_state") in ("IDLE", "FINISH", "FAILED"), p.get("gcode_state"))
    check("printer spool matches", tray == material, f"printer says {tray}")
    eta = re.search(r"total estimated time: (.+)$", g, re.M)
    print(f"  estimated time {eta.group(1) if eta else '?'}")
    return all(checks)


if __name__ == "__main__":
    ok = main(sys.argv[1], sys.argv[2])
    print("ALL CHECKS PASSED" if ok else "CHECKS FAILED - not sending")
    sys.exit(0 if ok else 1)
