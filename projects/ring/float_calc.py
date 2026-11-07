"""Mesh volume, PETG mass and float line of the ring. Usage: python -I float_calc.py <stl> <OD> <W> <H>"""
import sys, re
import numpy as np
stl, OD, W, H = sys.argv[1], *map(float, sys.argv[2:5])
data = open(stl, "rb").read()
if data[:5] == b"solid":
    v = np.array([list(map(float, m)) for m in re.findall(rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", data)]).reshape(-1, 3, 3)
else:
    n = int.from_bytes(data[80:84], "little")
    v = np.frombuffer(data[84:84 + n * 50], dtype=np.dtype([("n", "<3f4"), ("v", "<9f4"), ("a", "<u2")]))["v"].reshape(-1, 3, 3).astype(float)
vol = np.einsum("ij,ij->i", v[:, 0], np.cross(v[:, 1], v[:, 2])).sum() / 6 / 1000   # cm3, voids subtracted
lo, hi = v.reshape(-1, 3).min(0), v.reshape(-1, 3).max(0)
foot = np.pi * ((OD / 2) ** 2 - (OD / 2 - W) ** 2) / 100                            # cm2 waterline area
for rho, name in [(1.27, "PETG"), (1.24, "PLA")]:
    m = vol * rho
    draft = m / foot * 10                                                              # mm, fresh water
    print(f"{name}: plastic {vol:.1f} cm3, {m:.0f} g, sits {draft:.1f} mm deep, {H - draft:.1f} mm above water")
env = foot * H / 10
print(f"bounding box {lo.round(2)} .. {hi.round(2)}; outside volume {env:.1f} cm3, so it holds up {env - vol * 1.27:.0f} g more before sinking")
