"""Support check for an STL in its print orientation, straight from the mesh.

Slices it every 0.2 mm, rasterizes each layer at 0.1 mm, and compares it with the layer below (grown by
0.3 mm, about a 56-degree overhang). Whatever is left is unsupported; each piece of it is reported as an
island (touching nothing printed), a bridge (held at two or more places; span about twice its reach), or
a ledge (held on one side; its reach is how far it sticks out).
Usage: python -I printcheck.py <stl> [ledge_mm=2.0] [bridge_mm=15]
"""
import re
import sys

import numpy as np
from scipy import ndimage

RES, STEP, GROW = 0.1, 0.2, 3      # mm per pixel, layer height, growth per layer in pixels


def load(path):
    data = open(path, "rb").read()
    if data[:5] == b"solid" and b"facet" in data[:400]:
        v = np.array(re.findall(rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", data), dtype=float)
        return v.reshape(-1, 3, 3)
    n = int(np.frombuffer(data[80:84], np.uint32)[0])
    rec = np.frombuffer(data[84:84 + 50 * n], dtype=np.dtype([("n", "<f4", 3), ("v", "<f4", (3, 3)), ("a", "<u2")]))
    return rec["v"].astype(float)


def section(tris, z):
    """Segments where the plane z cuts the mesh: array (m, 2, 2)."""
    zs = tris[:, :, 2]
    above = zs > z
    cnt = above.sum(1)
    t = tris[(cnt == 1) | (cnt == 2)]
    a = above[(cnt == 1) | (cnt == 2)]
    segs = []
    for i, j in ((0, 1), (1, 2), (2, 0)):
        m = a[:, i] != a[:, j]
        p, q = t[:, i], t[:, j]
        f = (z - p[:, 2]) / np.where(m, q[:, 2] - p[:, 2], 1)
        pt = p[:, :2] + (q[:, :2] - p[:, :2]) * f[:, None]
        segs.append((m, pt))
    out = []
    for k in range(len(t)):
        pts = [s[1][k] for s in segs if s[0][k]]
        if len(pts) == 2:
            out.append(pts)
    return np.array(out).reshape(-1, 2, 2)


def section_fast(tris, z):
    zs = tris[:, :, 2]
    above = zs > z
    cnt = above.sum(1)
    keep = (cnt == 1) | (cnt == 2)
    t, a = tris[keep], above[keep]
    pts = []
    for i, j in ((0, 1), (1, 2), (2, 0)):
        m = a[:, i] != a[:, j]
        # the lower end first, so the two triangles on an edge compute exactly the same point
        sw = (t[:, i, 2] > t[:, j, 2])[:, None]
        p, q = np.where(sw, t[:, j], t[:, i]), np.where(sw, t[:, i], t[:, j])
        d = np.where(m, q[:, 2] - p[:, 2], 1.0)
        f = (z - p[:, 2]) / d
        pts.append(np.where(m[:, None], p[:, :2] + (q[:, :2] - p[:, :2]) * f[:, None], np.nan))
    P = np.stack(pts, 1)                      # (n, 3, 2), two valid per row
    ok = ~np.isnan(P[:, :, 0])
    order = np.argsort(~ok, axis=1, kind="stable")[:, :2]
    S = np.take_along_axis(P, order[:, :, None], axis=1)
    return S


def raster(segs, x0, y0, nx, ny):
    """Even-odd fill of the closed loops in segs, sampled at pixel centres."""
    img = np.zeros((ny, nx), bool)
    if len(segs) == 0:
        return img
    ya, yb = segs[:, 0, 1], segs[:, 1, 1]
    xa, xb = segs[:, 0, 0], segs[:, 1, 0]
    lo, hi = np.minimum(ya, yb), np.maximum(ya, yb)
    r0 = np.ceil((lo - y0) / RES - 0.5).astype(int)
    r1 = np.ceil((hi - y0) / RES - 0.5).astype(int)      # rows with lo <= yc < hi
    r0, r1 = np.clip(r0, 0, ny), np.clip(r1, 0, ny)
    n = np.maximum(r1 - r0, 0)
    if n.sum() == 0:
        return img
    idx = np.repeat(np.arange(len(segs)), n)
    rows = np.concatenate([np.arange(a, b) for a, b in zip(r0[n > 0], r1[n > 0])])
    yc = y0 + (rows + 0.5) * RES
    f = (yc - ya[idx]) / (yb[idx] - ya[idx])
    xc = xa[idx] + (xb[idx] - xa[idx]) * f
    o = np.lexsort((xc, rows))
    rows, xc = rows[o], xc[o]
    # pair up crossings within each row
    starts = np.r_[0, np.flatnonzero(np.diff(rows)) + 1]
    for s, e in zip(starts, np.r_[starts[1:], len(rows)]):
        r = rows[s]
        xs = xc[s:e]
        for k in range(0, len(xs) - 1, 2):
            c0 = int(np.ceil((xs[k] - x0) / RES - 0.5))
            c1 = int(np.ceil((xs[k + 1] - x0) / RES - 0.5))
            if c1 > c0:
                img[r, max(c0, 0):min(c1, nx)] = True
    return img


def disk(r):
    y, x = np.mgrid[-r:r + 1, -r:r + 1]
    return x * x + y * y <= r * r + 0.5


def check(path, ledge_mm=2.0, bridge_mm=15.0, quiet=False):
    tris = load(path)
    mn, mx = tris.reshape(-1, 3).min(0), tris.reshape(-1, 3).max(0)
    x0, y0 = mn[0] - 1, mn[1] - 1
    nx, ny = int((mx[0] - x0 + 1) / RES) + 1, int((mx[1] - y0 + 1) / RES) + 1
    prev = None
    k_grow = disk(GROW)
    found = []
    z = mn[2] + STEP / 2
    while z < mx[2]:
        cur = raster(section_fast(tris, z), x0, y0, nx, ny)
        if prev is not None and cur.any():
            sup_zone = ndimage.binary_dilation(prev, k_grow)
            un = cur & ~sup_zone
            if un.any():
                supported = cur & sup_zone
                dist = ndimage.distance_transform_edt(~supported) * RES
                lab, n = ndimage.label(un, np.ones((3, 3)))
                for i in range(1, n + 1):
                    reg = lab == i
                    area = reg.sum() * RES * RES
                    reach = dist[reg].max()
                    if area < 0.05 and reach < 0.5:
                        continue
                    ring = ndimage.binary_dilation(reg, np.ones((3, 3))) & supported
                    nanch = ndimage.label(ring, np.ones((3, 3)))[1]
                    ys, xs = np.nonzero(reg)
                    c = (x0 + (xs.mean() + 0.5) * RES, y0 + (ys.mean() + 0.5) * RES)
                    kind = "island" if nanch == 0 else ("bridge" if nanch >= 2 else "ledge")
                    if kind == "ledge":
                        # held at the middle of two opposite edges by one U-shaped edge (a ceiling held on three
                        # sides): a bridge, its span about twice its reach
                        ry, rx = np.nonzero(ring)
                        midy = (ry >= np.percentile(ys, 25)) & (ry <= np.percentile(ys, 75))
                        midx = (rx >= np.percentile(xs, 25)) & (rx <= np.percentile(xs, 75))
                        both_x = ((rx <= xs.min() + 2) & midy).any() and ((rx >= xs.max() - 2) & midy).any()
                        both_y = ((ry <= ys.min() + 2) & midx).any() and ((ry >= ys.max() - 2) & midx).any()
                        if both_x or both_y:
                            kind = "bridge"
                    bad = kind == "island" or (kind == "ledge" and reach > ledge_mm) or (kind == "bridge" and 2 * reach > bridge_mm)
                    found.append((round(z - mn[2], 2), kind, round(reach, 2), round(area, 2), (round(c[0], 1), round(c[1], 1)), bad))
        prev = cur
        z += STEP
    bad = [f for f in found if f[5]]
    if not quiet:
        print(f"{path}: {len(tris)} triangles, size {mx[0]-mn[0]:.1f} x {mx[1]-mn[1]:.1f} x {mx[2]-mn[2]:.1f} mm")
        print(f"  unsupported pieces: {len(found)}; over the limits (ledge > {ledge_mm} mm, bridge > {bridge_mm} mm, islands): {len(bad)}")
        for f in bad[:60]:
            print("   ", f[:5])
    return found, bad


if __name__ == "__main__":
    a = sys.argv[1:]
    check(a[0], float(a[1]) if len(a) > 1 else 2.0, float(a[2]) if len(a) > 2 else 15.0)
