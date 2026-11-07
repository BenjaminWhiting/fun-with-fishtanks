"""Resolve a Bambu system preset's 'inherits' chain into one standalone JSON."""
import json, sys
from pathlib import Path
BBL = Path(r"C:\Program Files\Bambu Studio\resources\profiles\BBL")
index = {}
for f in BBL.glob("*/*.json"):
    try:
        d = json.loads(f.read_text(encoding="utf-8"))
    except Exception:
        continue
    if isinstance(d, dict) and "name" in d:
        index.setdefault((f.parent.name, d["name"]), d)

SKIP = {"name", "type", "instantiation", "inherits", "include", "from", "setting_id"}

def resolve(kind, name):
    d = dict(index[(kind, name)])
    parent = d.pop("inherits", None)
    # printer-specific G-code (start, end, layer change...) lives in separate
    # "template" presets pulled in by "include"; missing them silently falls back
    # to the parent's G-code, which belongs to a different printer
    for inc in d.pop("include", []):
        d.update({k: v for k, v in resolve(kind, inc).items() if k not in SKIP})
    if parent:
        base = resolve(kind, parent)
        base.update(d)
        d = base
    return d

kind, name, out = sys.argv[1:4]
d = resolve(kind, name)
# the CLI only accepts these as matching presets if they look like system presets
# and carry their own settings id
d["from"] = "system"
d.pop("instantiation", None)
id_key = {"machine": "printer_settings_id", "process": "print_settings_id", "filament": "filament_settings_id"}[kind]
d[id_key] = [d["name"]] if kind == "filament" else d["name"]
Path(out).write_text(json.dumps(d, indent=2), encoding="utf-8")
print(out, len(d), "keys")
