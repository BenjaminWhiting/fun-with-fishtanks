"""Report the real (absolute) X/Y/Z envelope of every move in a G-code file, honouring G90/G91."""
import re, sys

def envelope(path):
    pos = {"X": 0.0, "Y": 0.0, "Z": 0.0}
    rel = False
    lo = {k: 1e9 for k in pos}; hi = {k: -1e9 for k in pos}
    for line in open(path, encoding="utf-8", errors="replace"):
        code = line.split(";")[0].strip()
        if code.startswith("G90"): rel = False
        elif code.startswith("G91"): rel = True
        elif code.startswith("G28"): pos.update(X=pos["X"], Y=pos["Y"])  # homing: position comes from later moves
        elif re.match(r"G[0-3]\b", code):
            for k, v in re.findall(r"([XYZ])(-?[\d.]+)", code):
                pos[k] = pos[k] + float(v) if rel else float(v)
                lo[k] = min(lo[k], pos[k]); hi[k] = max(hi[k], pos[k])
    return lo, hi

if __name__ == "__main__":
    for p in sys.argv[1:]:
        lo, hi = envelope(p)
        print(p.split("/")[-1].split("\\")[-1], " ".join(f"{k} {lo[k]:.1f}..{hi[k]:.1f}" for k in "XYZ"))
