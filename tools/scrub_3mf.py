"""Take local folder paths out of a sliced .gcode.3mf.

Bambu Studio writes each model's full path (C:\\Users\\<you>\\...) into the file's metadata. This keeps only the
file name. The G-code isn't touched, so the file's md5 still matches and it prints exactly as before.
slice.py runs this on everything it slices; run it by hand on files sliced any other way.
Usage: python -I tools/scrub_3mf.py <file.gcode.3mf> [more files]"""
import hashlib
import os
import re
import sys
import zipfile

# a quoted absolute path: a drive letter, a network share, or a home folder
ABS_PATH = re.compile(rb'(?<=")(?:[A-Za-z]:[\\/]+|\\\\\\\\|/(?:home|Users)/)[^"<>|\r\n]*[\\/]([^\\/"<>|\r\n]+)(?=")')
TEXT = (".config", ".json", ".model", ".xml", ".rels")


def scrub(path):
    """Rewrite the archive in place. Returns how many paths were shortened."""
    changed, members = 0, []
    with zipfile.ZipFile(path) as z:
        for info in z.infolist():
            data = z.read(info.filename)
            if info.filename.endswith(TEXT):
                data, n = ABS_PATH.subn(rb"\1", data)
                changed += n
            members.append((info, data))
    if not changed:
        return 0
    tmp = path + ".tmp"
    with zipfile.ZipFile(tmp, "w") as out:
        for info, data in members:
            out.writestr(info, data)
    with zipfile.ZipFile(tmp) as z:   # the G-code must still match its checksum
        names = z.namelist()
        for n in names:
            if n.endswith(".gcode") and n + ".md5" in names:
                if hashlib.md5(z.read(n)).hexdigest().lower() != z.read(n + ".md5").decode().strip().lower():
                    os.remove(tmp)
                    sys.exit(f"{path}: G-code checksum changed; left as it was")
    os.replace(tmp, path)
    return changed


if __name__ == "__main__":
    for f in sys.argv[1:]:
        n = scrub(f)
        print(f"{os.path.basename(f)}: {n} local path{'' if n == 1 else 's'} shortened" if n else f"{os.path.basename(f)}: clean")
