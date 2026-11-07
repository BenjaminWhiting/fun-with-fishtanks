"""Stop the print now, then turn both heaters off. Usage: python -I tools/stop.py
It acts the moment it runs, so it takes no arguments: any argument (even --help) just prints this."""
import sys
if len(sys.argv) > 1:
    sys.exit(__doc__)
sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
import bambu

rc, reps = bambu.mqtt_session(publish={"print": {"sequence_id": "90", "command": "stop", "param": ""}}, wait=3)
print("stop:", rc, [r["print"].get("result") for r in reps if r.get("print", {}).get("command") == "stop"])
rc, reps = bambu.mqtt_session(publish={"print": {"sequence_id": "91", "command": "gcode_line", "param": "M104 S0\nM140 S0\n"}}, wait=4)
p = bambu.merged_print(reps)
print("state:", p.get("gcode_state"), "| nozzle target", p.get("nozzle_target_temper"), "| bed target", p.get("bed_target_temper"))
