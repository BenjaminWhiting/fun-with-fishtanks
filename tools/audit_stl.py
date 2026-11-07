"""Measure printed geometry straight from STL files (no trust in the design code).

measure(path, origin, direction) casts a ray through the mesh and returns the
material intervals along it. overhangs(path) lists downward-facing surfaces that
are flatter than 45 degrees and not on the bed, grouped into clusters.
"""
import re
import sys

import numpy as np


def load(path):
    data = open(path, "rb").read()
    v = np.array(re.findall(rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", data), dtype=float)
    return v.reshape(-1, 3, 3)


def hits(tris, origin, direction):
    """Distances along the ray where it crosses the surface (Moller-Trumbore, all triangles at once)."""
    o, d = np.asarray(origin, float), np.asarray(direction, float)
    v0, e1, e2 = tris[:, 0], tris[:, 1] - tris[:, 0], tris[:, 2] - tris[:, 0]
    p = np.cross(d, e2)
    det = np.einsum("ij,ij->i", e1, p)
    ok = np.abs(det) > 1e-12
    inv = np.where(ok, 1.0 / np.where(ok, det, 1), 0)
    s = o - v0
    u = np.einsum("ij,ij->i", s, p) * inv
    q = np.cross(s, e1)
    w = (q @ d) * inv
    t = np.einsum("ij,ij->i", e2, q) * inv
    good = ok & (u >= -1e-9) & (w >= -1e-9) & (u + w <= 1 + 1e-9)
    ts = np.sort(t[good])
    # a ray through a shared edge hits both triangles; merge near-duplicates
    out = []
    for x in ts:
        if not out or x - out[-1] > 1e-6:
            out.append(x)
    return out


def measure(tris, origin, direction):
    """Material intervals [(start, end), ...] along the ray, as coordinates on that axis."""
    ts = hits(tris, origin, direction)
    axis = int(np.argmax(np.abs(direction)))
    base = origin[axis]
    return [(round(base + a, 3), round(base + b, 3)) for a, b in zip(ts[0::2], ts[1::2])]


def overhangs(tris, limit_deg=45.0, cluster_mm=4.0):
    n = np.cross(tris[:, 1] - tris[:, 0], tris[:, 2] - tris[:, 0])
    area = np.linalg.norm(n, axis=1) / 2
    n = n / np.maximum(np.linalg.norm(n, axis=1, keepdims=True), 1e-12)
    zmin = tris[:, :, 2].min(axis=1)
    # face angle from horizontal: 0 = flat ceiling (bridge), 90 = vertical wall
    ang = np.degrees(np.arccos(np.clip(-n[:, 2], -1, 1)))
    down = (n[:, 2] < 0) & (ang < limit_deg - 0.5) & (zmin > 0.05) & (area > 1e-6)
    idx = np.where(down)[0]
    cents = tris[idx].mean(axis=1)
    clusters = []
    for i, c in zip(idx, cents):
        for cl in clusters:
            if np.min(np.linalg.norm(cl["c"] - c, axis=1)) < cluster_mm:
                cl["i"].append(i); cl["c"] = np.vstack([cl["c"], c]); break
        else:
            clusters.append({"i": [i], "c": c[None]})
    out = []
    for cl in clusters:
        t = tris[cl["i"]]
        lo, hi = t.reshape(-1, 3).min(0), t.reshape(-1, 3).max(0)
        a = ang[cl["i"]]
        out.append(dict(z=round(float(lo[2]), 1), size=tuple(np.round(hi - lo, 1)), min_angle=round(float(a.min()), 1),
                        flat=bool(a.min() < 1), area=round(float(area[cl["i"]].sum()), 1)))
    return sorted(out, key=lambda r: (-r["area"]))


if __name__ == "__main__":
    for path in sys.argv[1:]:
        t = load(path)
        lo, hi = t.reshape(-1, 3).min(0), t.reshape(-1, 3).max(0)
        print(path, "size", np.round(hi - lo, 2), "min", np.round(lo, 2))
