"""Draw every move of a G-code file over the A1 mini's 180 x 180 mm bed (top view).

Usage: python -I plot_toolpath.py <plate_1.gcode> <out.png> [title]
Extrusion is blue, travel grey, anything past the bed's back edge red.
"""
import re
import sys

from PIL import Image, ImageDraw, ImageFont


def moves(path):
    pos = {"X": 0.0, "Y": 0.0}
    rel = False
    out = []
    for line in open(path, encoding="utf-8", errors="replace"):
        c = line.split(";")[0].strip()
        if c.startswith("G90"):
            rel = False
        elif c.startswith("G91"):
            rel = True
        elif re.match(r"G[0-3]\b", c):
            prev = (pos["X"], pos["Y"])
            for k, v in re.findall(r"([XY])(-?[\d.]+)", c):
                pos[k] = pos[k] + float(v) if rel else float(v)
            if (pos["X"], pos["Y"]) != prev:
                out.append((prev, (pos["X"], pos["Y"]), bool(re.search(r"\bE\d*\.?\d+", c))))
    return out


def plot(path, out_png, title):
    s, x0, y0, x1, y1 = 3, -25, -15, 205, 215
    w, h = int((x1 - x0) * s), int((y1 - y0) * s) + 60
    im = Image.new("RGB", (w, h), (250, 250, 250))
    d = ImageDraw.Draw(im)
    big = ImageFont.truetype(r"C:\Windows\Fonts\segoeuib.ttf", 24)
    small = ImageFont.truetype(r"C:\Windows\Fonts\segoeui.ttf", 18)
    tx = lambda x, y: ((x - x0) * s, h - (y - y0) * s)
    d.rectangle([tx(0, 180), tx(180, 0)], fill=(225, 238, 230), outline=(40, 120, 70), width=3)
    d.text(tx(4, 176), "A1 mini bed 180 x 180 mm", fill=(40, 120, 70), font=small)
    past = 0
    for a, b, ext in moves(path):
        bad = not (-15 <= b[1] <= 186)
        past += bad
        col = (220, 30, 30) if bad else ((30, 90, 200) if ext else (170, 170, 170))
        d.line([tx(*a), tx(*b)], fill=col, width=4 if bad else (2 if ext else 1))
    d.text((12, 8), title, fill=(30, 30, 30), font=big)
    d.text((12, 38), f"moves past the bed's back edge: {past}", fill=(200, 30, 30) if past else (40, 120, 70), font=small)
    im.save(out_png)
    return past


if __name__ == "__main__":
    n = plot(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "")
    print("moves past back edge:", n)
