"""Layer-by-layer support check for parts whose holes run straight through X.

For each 0.2 mm layer it casts rays along Y at a few X positions and compares the
material with the layer below. It reports island starts (material with nothing
under it), and the longest one-sided overhang step and bridge per layer.
Usage: python -I layer_check.py <stl> [z_from z_to [x1,x2,...]]
"""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).parent))
from audit_stl import load, measure


def runs_not_under(iv, below):
    """Parts of the intervals iv not over any interval in below: (start, end, left_ok, right_ok)."""
    out = []
    for a, b in iv:
        cuts = [(max(a, c), min(b, d)) for c, d in below if min(b, d) > max(a, c)]
        if not cuts:
            out.append((a, b, False, False))
            continue
        x = a
        for c, d in cuts:
            if c > x + 1e-6:
                out.append((x, c, x > a + 1e-6 or False, True))
            x = max(x, d)
        if b > x + 1e-6:
            out.append((x, b, True, False))
    return out


def check(path, z0, z1, xs=(-6.0, 0.0, 6.0), step=0.2):
    tris = load(path)
    islands, worst_cant, worst_bridge = [], (0, None), (0, None)
    for x in xs:
        below = measure(tris, (x, -200, z0), (0, 1, 0))
        for z in np.arange(z0 + step, z1, step):
            iv = measure(tris, (x, -200, z), (0, 1, 0))
            for a, b, l_ok, r_ok in runs_not_under(iv, below):
                w = b - a
                if not l_ok and not r_ok:
                    islands.append((round(z, 2), x, round(a, 2), round(b, 2)))
                elif l_ok and r_ok:
                    if w > worst_bridge[0]:
                        worst_bridge = (round(w, 2), (round(z, 2), x, a, b))
                elif w > worst_cant[0]:
                    worst_cant = (round(w, 2), (round(z, 2), x, a, b))
            below = iv
    return islands, worst_cant, worst_bridge


if __name__ == "__main__":
    z0, z1 = (float(sys.argv[2]), float(sys.argv[3])) if len(sys.argv) > 3 else (0.2, None)
    xs = tuple(float(v) for v in sys.argv[4].split(",")) if len(sys.argv) > 4 else (-6.0, 0.0, 6.0)
    tris = load(sys.argv[1])
    z1 = z1 or float(tris[:, :, 2].max())
    isl, cant, bridge = check(sys.argv[1], z0, z1, xs)
    print("island starts (material with nothing below):", len(isl))
    for i in isl:
        print("   z %.2f  x %.1f  y %.2f..%.2f" % i)
    print("longest one-sided overhang step per 0.2 mm layer:", cant[0], "mm at", cant[1])
    print("longest bridge:", bridge[0], "mm at", bridge[1])
