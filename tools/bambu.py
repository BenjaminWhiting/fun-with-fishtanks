"""Tiny local-network client for a Bambu A1 mini in LAN mode (MQTT status/print, FTPS upload).
The printer's IP comes from tools/printer.json (copy printer.example.json; it is git-ignored) or
the BAMBU_IP environment variable. The serial and LAN access code are read from Bambu Studio's
config and never printed."""
import json, os, ssl, sys, time, ftplib, socket
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "pylib"))
import paho.mqtt.client as mqtt

HERE = os.path.dirname(os.path.abspath(__file__))
LOCAL = os.path.join(HERE, "printer.json")
SETTINGS = json.load(open(LOCAL)) if os.path.exists(LOCAL) else {}
IP = os.environ.get("BAMBU_IP") or SETTINGS.get("ip")
if not IP:
    sys.exit("No printer IP: copy tools/printer.example.json to tools/printer.json and fill it in")
CONF = os.path.join(os.environ["APPDATA"], "BambuStudio", "BambuStudio.conf")

def creds():
    raw = open(CONF, encoding="utf-8").read()
    conf = json.loads(raw[:raw.rfind("}") + 1])
    codes = conf["access_code"]
    serial = SETTINGS.get("serial") or conf["app"].get("user_last_selected_machine") or next(iter(codes))
    return serial, codes[serial]

def tls():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE   # printer uses a self-signed certificate
    return ctx

def mqtt_session(publish=None, wait=8):
    """Connect, optionally publish one request, collect report messages for `wait` s."""
    serial, code = creds()
    reports, state = [], {}
    c = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, protocol=mqtt.MQTTv311)
    c.username_pw_set("bblp", code)
    c.tls_set_context(tls())
    def on_connect(cl, ud, flags, rc, props=None):
        state["rc"] = str(rc)
        cl.subscribe(f"device/{serial}/report")
        cl.publish(f"device/{serial}/request", json.dumps({"pushing": {"sequence_id": "1", "command": "pushall"}}))
        if publish:
            cl.publish(f"device/{serial}/request", json.dumps(publish))
    c.on_connect = on_connect
    c.on_message = lambda cl, ud, m: reports.append(json.loads(m.payload))
    c.connect(IP, 8883, keepalive=30)
    c.loop_start()
    time.sleep(wait)
    c.loop_stop()
    c.disconnect()
    return state.get("rc"), reports

def merged_print(reports):
    out = {}
    for r in reports:
        out.update(r.get("print", {}))
    return out

class ImplicitFTPS(ftplib.FTP_TLS):
    """Bambu printers speak implicit FTPS on port 990 and want the TLS session reused."""
    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self._sock = None
    @property
    def sock(self):
        return self._sock
    @sock.setter
    def sock(self, value):
        if value is not None and not isinstance(value, ssl.SSLSocket):
            value = self.context.wrap_socket(value)
        self._sock = value
    def ntransfercmd(self, cmd, rest=None):
        conn, size = ftplib.FTP.ntransfercmd(self, cmd, rest)
        if self._prot_p:
            conn = self.context.wrap_socket(conn, server_hostname=self.host, session=self.sock.session)
        return conn, size

def ftp():
    serial, code = creds()
    f = ImplicitFTPS(context=tls())
    f.connect(IP, 990, timeout=20)
    f.login("bblp", code)
    f.prot_p()
    return f

if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "status":
        rc, reps = mqtt_session()
        p = merged_print(reps)
        print("connect:", rc, "| messages:", len(reps))
        keys = ["gcode_state", "mc_print_stage", "print_type", "gcode_file", "nozzle_temper", "bed_temper",
                "sdcard", "home_flag", "lights_report", "wifi_signal", "nozzle_diameter"]
        for k in keys:
            if k in p:
                print(f"  {k}: {p[k]}")
        vt = p.get("vt_tray", {})
        print("  external spool:", {k: vt.get(k) for k in ("tray_type", "tray_sub_brands", "tray_color", "tray_info_idx", "nozzle_temp_min", "nozzle_temp_max")})
        ams = p.get("ams", {})
        if ams.get("ams"):
            for unit in ams["ams"]:
                for t in unit.get("tray", []):
                    print("  AMS slot", unit.get("id"), t.get("id"), t.get("tray_type"), t.get("tray_color"))
    elif cmd == "ls":
        f = ftp()
        for d in ("/", "/cache"):
            try:
                print(d, f.nlst(d)[:30])
            except Exception as e:
                print(d, "->", e)
        f.quit()

def set_external_spool(tray_type, info_idx, color, tmin, tmax):
    """Set what the printer thinks is on the external spool holder (A1 mini without AMS)."""
    cmd = {"print": {"sequence_id": "2", "command": "ams_filament_setting", "ams_id": 255, "tray_id": 254,
                     "tray_info_idx": info_idx, "tray_color": color, "nozzle_temp_min": tmin,
                     "nozzle_temp_max": tmax, "tray_type": tray_type}}
    rc, reps = mqtt_session(publish=cmd, wait=6)
    replies = [r["print"] for r in reps if r.get("print", {}).get("command") == "ams_filament_setting"]
    return rc, replies

if __name__ == "__main__" and sys.argv[1] == "setspool":
    rc, replies = set_external_spool("PETG", "GFG99", "161616FF", 220, 260)   # Generic PETG, black
    print("connect:", rc)
    for r in replies:
        print("  reply:", {k: r.get(k) for k in ("result", "reason", "tray_type", "tray_info_idx", "err_code")})
    if not replies:
        print("  no reply to the setting command")

def upload(local, remote_name):
    """Store a file in the printer's storage root (skips the TLS unwrap that Bambu's FTP server stalls on)."""
    f = ftp()
    with open(local, "rb") as src, f.transfercmd("STOR " + remote_name) as conn:
        while chunk := src.read(65536):
            conn.sendall(chunk)
    f.voidresp()
    size = f.size(remote_name)
    f.quit()
    return size

if __name__ == "__main__" and sys.argv[1] == "upload":
    local, name = sys.argv[2], sys.argv[3]
    print("uploaded", name, "-", upload(local, name), "bytes on printer;", os.path.getsize(local), "bytes local")

def start_print(remote_name):
    """Start a sliced .gcode.3mf already in the storage root, from the external spool."""
    cmd = {"print": {"sequence_id": "3", "command": "project_file", "param": "Metadata/plate_1.gcode",
                     "project_id": "0", "profile_id": "0", "task_id": "0", "subtask_id": "0",
                     "subtask_name": remote_name.replace(".gcode.3mf", ""),
                     "url": f"file:///sdcard/{remote_name}", "md5": "",
                     "timelapse": False, "bed_type": "auto", "bed_levelling": True, "flow_cali": False,
                     "vibration_cali": False, "layer_inspect": False, "use_ams": False,
                     "ams_mapping": [-1]}}
    rc, reps = mqtt_session(publish=cmd, wait=10)
    p = merged_print(reps)
    replies = [r["print"] for r in reps if r.get("print", {}).get("command") == "project_file"]
    return rc, replies, p.get("gcode_state"), p.get("mc_print_stage")

if __name__ == "__main__" and sys.argv[1] == "setspool-pla-grey":
    rc, replies = set_external_spool("PLA", "GFL99", "8E9089FF", 190, 240)   # Generic PLA, grey
    print("connect:", rc, [{k: r.get(k) for k in ("result", "err_code")} for r in replies])

if __name__ == "__main__" and sys.argv[1] == "print":
    rc, replies, state, stage = start_print(sys.argv[2])
    print("connect:", rc, "| replies:", [{k: r.get(k) for k in ("result", "reason", "err_code")} for r in replies])
    print("state now:", state, "stage:", stage)
