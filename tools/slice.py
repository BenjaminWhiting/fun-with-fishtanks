"""Run Bambu Studio's command-line slicer on this PC.

Bambu Studio shows a modal "DLLs have been injected" warning at startup because
Dell's Alienware Sound Center injects NahimicOSD.dll into every process. On the
command line nobody can click it, so the slicer waits forever. This launcher
clicks OK on that one warning and stops (showing the text) on any other dialog.

Usage: python -I slice.py <out dir> <name.gcode.3mf> <filament.json> <model.stl> [more models]
Run it from tools/presets: machine.json / process.json are read from the current folder.
"""
import ctypes
import subprocess
import sys
import time
from ctypes import wintypes
from pathlib import Path

EXE = r"C:\Program Files\Bambu Studio\bambu-studio.exe"
u32 = ctypes.WinDLL("user32")
EnumProc = ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
BM_CLICK = 0x00F5


def text(h):
    b = ctypes.create_unicode_buffer(4096)
    u32.GetWindowTextW(h, b, 4096)
    return b.value


def cls(h):
    b = ctypes.create_unicode_buffer(256)
    u32.GetClassNameW(h, b, 256)
    return b.value


def dialogs(pid):
    hits = []

    @EnumProc
    def cb(hwnd, _):
        owner = wintypes.DWORD()
        u32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value == pid and cls(hwnd) == "#32770" and u32.IsWindowVisible(hwnd):
            hits.append(hwnd)
        return True
    u32.EnumWindows(cb, 0)
    return hits


def children(hwnd):
    kids = []

    @EnumProc
    def cb(h, _):
        kids.append((cls(h), text(h), h))
        return True
    u32.EnumChildWindows(hwnd, cb, 0)
    return kids


def main():
    out_dir, name, filament, *models = sys.argv[1:]
    Path(out_dir).mkdir(parents=True, exist_ok=True)
    args = [EXE, "--debug", "2", "--arrange", "1", "--orient", "0",
            "--curr-bed-type", "Textured PEI Plate", "--slice", "0",
            "--load-settings", "machine.json;process.json", "--load-filaments", filament,
            "--outputdir", out_dir, "--export-3mf", name, *models]
    proc = subprocess.Popen(args, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    start, dismissed = time.time(), 0
    while proc.poll() is None:
        if time.time() - start > 300:
            proc.kill()
            sys.exit("gave up after 300 s")
        for d in dialogs(proc.pid):
            kids = children(d)
            body = " ".join(t for c, t, _ in kids if c == "Static")
            ok = [h for c, t, h in kids if c == "Button" and t.replace("&", "") == "OK"]
            if "DLLs have been injected" in body and ok:
                u32.SendMessageW(ok[0], BM_CLICK, 0, 0)
                dismissed += 1
                print("clicked OK on the injected-DLL warning")
            else:
                proc.kill()
                sys.exit(f"stopped: unexpected dialog '{text(d)}': {body[:600]}")
        time.sleep(0.3)
    print(f"exit code {proc.returncode} after {time.time() - start:.0f} s")
    for f in sorted(Path(out_dir).glob("*")):
        print(f"  {f.name}  {f.stat().st_size} bytes")


main()
