"""Copy every design image into history/, grouped by project and named by date so they sort
in the order they were made, then rebuild history/README.md. Safe to re-run: it copies only
what isn't there yet and never deletes. Usage: python -I tools/collect_history.py [scratchpad dir]"""
import os, re, shutil, sys, time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
H = os.path.join(ROOT, "history")
SCRATCH = sys.argv[1] if len(sys.argv) > 1 else None

# project folders, and the file-name patterns that belong to each
PROJECTS = [
    ("1_light_riser", "The light riser", r"^(bonsai_|riser_design|hygger_riser|glass_gauge|gauge_|riser_test|riser_top|riser_b1|b1_front|r5_front|top_iso|true_)"),
    ("2_pump_gate", "The pump-side gate", r"^(pump_gate|ginkgo|riser_set_diagram|beam_|gopt_|gate_|dia_|set_)"),
    ("3_boardwalk", "The boardwalk", r"^(boardwalk_|bathhouse_|cat_fisherman|bw_|piece_|pieces_|plate_|plates_|guide_v|arm1|arm2|done|plate|tank|close_|front_|land_close|land_front_\d|plan\.|c_(hero|explode|plate))"),
    ("4_printer_camera", "From the printer's camera", r"^bed_"),
    ("5_floating_ring", "The floating ring", r"^(floater_ring|ring_)"),
]

# captions for the sheets that were shown along the way; everything else is a working render
CAPTIONS = {
    "hygger_riser_preview": "The first riser model: a clamp on the side glass that lifts the light.",
    "bonsai_design_ideas": "Bonsai art: a cut-out, or slats and a moon. You kept the slats and dropped the moon.",
    "bonsai_options": "Four bonsai styles: you picked B1, informal upright.",
    "riser_design_ideas": "The first art ideas for the riser: angelfish, hidden fish, jellyfish, 8-bit fish, barcode shark, coral.",
    "glass_gauge_preview": "A gauge to measure the glass: the 8.4 mm slot fitted best.",
    "gauge_toolpath_check": "The toolpath check added after the first gauge print had the wrong printer's start moves.",
    "riser_test_bottom_toolpath": "PLA test of the clamp bottom.",
    "riser_test_bottom_first_layer": "Its first layer.",
    "riser_test_top_toolpath": "PLA test of the top cradle that holds the light's foot.",
    "riser_top_cradle_preview": "The top cradle.",
    "riser_b1_preview": "B1 informal upright: the bonsai you picked.",
    "riser_b1_toolpath": "B1 toolpath.",
    "riser_b1_true_mockup": "The true mock-up you approved: \"I like it.\"",
    "riser_b1_petg_toolpath": "The final riser in PETG: 5\" lift.",
    "pump_gate_mockup": "The pump-side gate: two legs and a beam over the pump.",
    "pump_gate_clouds_mockup": "Art on the beam, first try: slatted clouds.",
    "ginkgo_beam_options": "Ginkgo leaves instead: you picked the bigger leaves.",
    "pump_gate_ginkgo_mockup": "Ginkgo leaves on the beam.",
    "riser_set_diagram": "The set in inches.",
    "riser_set_diagram_v2": "The whole riser set in inches: bonsai riser on the clear end, the 3-piece ginkgo gate over the pump.",
    "riser_set_diagram_v3": "The 3-piece 11 13/16\" beam for the 8.5\" pump, locked so it can't slide off the legs.",
    "pump_gate_legs_toolpath": "Gate legs toolpath.",
    "pump_gate_beam_toolpath": "Gate beam toolpath.",
    "boardwalk_corner": "The first boardwalk corner piece.",
    "boardwalk_corner_toolpath": "Corner toolpath check.",
    "boardwalk_pieces": "Each piece type, separately.",
    "boardwalk_full": "The whole boardwalk on the 36\" tank.",
    "boardwalk_plates": "The print plates.",
    "boardwalk_plates_v2": "The print plates, with keys and joint posts.",
    "boardwalk_corner_assembly": "How to put a corner together.",
    "boardwalk_centrepiece_ideas": "Centrepiece ideas: drum bridge, torii, or fishing landing. You picked the landing.",
    "boardwalk_landing_ideas": "The bigger fishing landing, with a pavilion, a pine, or a parasol on its far edge.",
    "boardwalk_centre_balcony": "You asked for it to hang off the room side too, to keep it even: a matching 2\" balcony, railed all round, makes a T on the glass. Then: grand bronze lanterns on the four corner posts.",
    "boardwalk_centre_locked": "LOCKED: the pavilion removed. Landing + balcony + four corner lanterns, its weight right over the glass.",
    "boardwalk_centre_print_set": "The centre piece designed for printing: the T in one piece (upside down) plus a rails-and-lanterns plate. Sliced, not printed yet.",
    "boardwalk_centre_toolpath": "The T's toolpath check.",
    "boardwalk_centre_rails_toolpath": "The centre rails and lanterns toolpath check.",
    "boardwalk_centre_braces": "The centre T printed, but its thin knee braces broke off mid-print (they climb on their own at 45 degrees when it prints upside down). Braces and joists made 4 mm thick, re-sliced and checked; the bathhouse's beams got the same fix.",
    "boardwalk_straight_assembly": "How to put a straight segment together: both railings are the same part, turned round.",
    "bathhouse_v1_grid": "Bathhouse, first try: a Miyazaki-style tower inside a front corner. You: \"it looks like a bath house but the theming is too serious\", and it belongs in the back-left corner.",
    "bathhouse_v2_front": "Second try, after the Spirited Away stills: playful, in the back-left corner, with a side door off the walk and a terrace out front.",
    "bathhouse_v2_tank": "You: \"take up the whole space and let the walk ways connect directly. I don't need a deck facing forward.\"",
    "boardwalk_bathhouse": "Third try, after your diorama photo: the bathhouse IS the back-left corner piece. The walks run straight into its doors; crimson body, lattice boxes, golden gable, leaning turret, chimney with steam, carp, a cat on the roof terrace.",
    "boardwalk_bathhouse_v4": "v4, your changes: a thinner core so the wooden floor juts out 1/2\" on stepped brackets; no flag, smoke, cat or tub; the boiler moved to the back and the porch to the front; pipes, valves and a water tank all over the outside.",
    "boardwalk_bathhouse_v5": "v5, your changes: no plants or towels; every pipe about twice as thick and kept to its own level, so none crosses a roof (a try with pipes down into the tank's water, and one looping them round the eaves, were dropped on your word); a thicker carp pole strapped to the chimney.",
    "boardwalk_bathhouse_v6": "v6, your changes: the pump house closed up with no gaps under its roof; the star window became a lattice box; the turret became three lattice window boxes on the main roof's right slope; no gold spinner. Then a full clipping check: lanterns re-hung, front pipes moved off a window, and the solid model made one piece (it was 71).",
    "boardwalk_bathhouse_v7": "v7: you asked for one more tier (nothing is above the tank). A smaller top floor rises out of the main roof behind its golden gable, with a red balcony and its own steeper roof and gable; about 1 3/8\" taller, the chimney and carp pole stretched to 7 1/2\" to stay the tallest.",
    "boardwalk_bathhouse_v8": "v8, lit from inside: you asked to slide a small disc light into the middle. A Bambu MH001 puck lies on a tray that slides in through the back wall; hollow floors joined by a light shaft up into the top tier; the windows real openings in bump-out frames with grid bars, paper behind.",
    "boardwalk_bathhouse_v9": "v9: every window an open grid with no glass or paper, the lattice boxes, roof window boxes and pump house hollow and lit too; no tray, the back opening left open and the puck sliding in to a curb; two 5/16\" hose holes up through the floor in the tank's corner for an air hose; every pipe running from one thing into another, with real bends and flanges.",
    "boardwalk_bathhouse_v10": "v10: you asked for a bigger back opening (now 1\" tall and about 3 1/8\" wide, two back windows dropped) and, rather than thicken the carp tails, to remove the whole carp pole; the chimney is now the tallest point.",
    "boardwalk_bathhouse_v11": "v11: you asked for fewer pipes and a cleaner look rather than risk print quality, then a full clipping audit. Only the steam line, the pump's two pipes and the tank outlet stay. The audit found the main and top roofs' curled corners lifting off the walls (fixed: flat undersides over the walls) and three hidden clips (window frames, pump pipe flanges, pipe ends inside rooms).",
    "boardwalk_bathhouse_v12": "v12: you saw walls clipping the roofs and gaps under the bump-outs. The walls' tops had sat a hair under the roofs' surfaces and showed through; now they sit 1/32\" or more inside (the windows unchanged), and the lattice boxes' walls rise to meet their sloping roofs.",
    "cat_fisherman_mock14": "Cat fisherman, mock 14: a solid hat sitting on top of his head, one piece, ears coming up through it as triangles; crisper legs and tail.",
    "cat_fisherman_mock15": "Cat fisherman, mock 15: the hat sunk down onto his head so its brim sits just above his eyes; ears re-fitted, cleaner brim edge.",
    "cat_fisherman_mock13": "Cat fisherman, mock 13: one piece (hat fused, ears shorter), legs tucked under a round belly, no gaps at the tail or cushion.",
    "cat_fisherman_mock12": "Cat fisherman, mock 12: full audit. Clean sealed meshes, two print parts that need no supports, a chain channel, and a read pass: arms on the belly, whole paws, triangular ears, a proper foot, slimmer collar.",
    "cat_fisherman_mock11": "Cat fisherman, mock 11: smaller ears, legs rebuilt as a defined cross-legged pair, the tail curled up his back.",
    "cat_fisherman_mock10": "Cat fisherman, mock 10: face laid out like a cat's (nose on top, ω mouth below, fanned whiskers), crisper creases for definition, shoulders lower and wider.",
    "cat_fisherman_mock9": "Cat fisherman, mock 9: no second cap under the hat (it slides down until it rests on his head), lower shoulders, slimmer limbs, ears through the hat.",
    "cat_fisherman_mock8": "Cat fisherman, mock 8: after a look at Buddha-style cat figurines, rebuilt as one smoothly blended sculpt: pear body, short thick arms, cross-legged base, closed smiling eyes; the hat is part of the surface so it sits on his head.",
    "cat_fisherman_mock7": "Cat fisherman, mock 7: arms bent at the elbow, elbows tucked against his sides, paws forward on the line.",
    "cat_fisherman_mock6": "Cat fisherman, mock 6: a headband lining inside the hat follows his head, so the hat sits right on it with no gap; ears up through it.",
    "cat_fisherman_mock5": "Cat fisherman, mock 5: hat tipped a little forward (40 degrees) and still seated on his head; rounder head and body.",
    "cat_fisherman_mock4": "Cat fisherman, mock 4: double was too big, so the hat is 1 1/2 times the original, tipped back and resting on his head, ears popping out through it.",
    "cat_fisherman_mock3": "Cat fisherman, mock 3: the straw hat twice the size and tipped right back, framing his face like a halo.",
    "cat_fisherman_mock2": "Cat fisherman, mock 2: lucky-cat shape on a zabuton cushion behind the landing's front rail, both paws on an articulated float line; whiskers and tail lie flat; three nesting ring sizes.",
    "cat_fisherman_mock1": "Cat fisherman, mock 1: a 1:48 cat on the landing's open edge holding a 9\" float line clipped to the floating ring; a stopper behind him sets the length for refills. Umbrella or both paws on the line.",
    "boardwalk_filter_bridge_v1": "You asked for the walk to go up and over the filter and still be a riser. Concept: the walk turns the printed back-right corner and climbs 12 steps, crosses the filter on a span that lifts off, and comes down to a landing at the front; a small roofed gate in the middle carries the light, its ridge the riser's locked cradle. The ridge looks too tall for the roof.",
    "boardwalk_bathhouse_v13_parts": "v13: split into seven printable parts for the A1 mini, as you asked: snap-together (tongue-and-groove walls, a pegged chimney), no supports, no lanterns for now, 1/2\" teeth. Undersides reshaped to 45 degrees, the front gable filled, the pipes resting on things; four silent PETG plates.",
    "bed_now": "The plate before a gate print.",
    "bed_corner": "The plate before the first corner.",
    "bed_straight1": "The plate before the first straight segment.",
    "bed_straight_stop": "The first straight stopped before layer 1 with HMS 0300-1800-0001-0005; the plate is still empty.",
}
PHOTOS = {"photo1": "Your reference photo for the boardwalk: \"This style, and then I want to eventually make 3D-printed fishermen.\"",
          "photo2": "Your reference for the bathhouse end piece: a model of the bathhouse from Spirited Away."}


def stamp(path):
    return time.strftime("%Y-%m-%d_%H%M", time.localtime(os.path.getmtime(path)))


def project_of(name):
    for folder, _, pat in PROJECTS:
        if re.match(pat, name): return folder
    return None


def sources():
    """(path, is a sheet shown along the way) for every image in the workspace and scratchpad."""
    for d in (ROOT, os.path.join(ROOT, "sheets")):   # design sheets live in sheets/ (git-ignored)
        for n in os.listdir(d) if os.path.isdir(d) else []:
            if n.lower().endswith((".png", ".jpg")): yield os.path.join(d, n), True
    if SCRATCH:
        for sub in ("", "guide", "mocks", "ct", "sguide", "ring", "bridge"):
            d = os.path.join(SCRATCH, sub)
            if not os.path.isdir(d): continue
            for n in os.listdir(d):
                if n.lower().endswith((".png", ".jpg")): yield os.path.join(d, n), False


copied = 0
for src, sheet in sources():
    name = os.path.basename(src); stem = os.path.splitext(name)[0]
    folder = project_of(name)
    if not folder: continue
    # camera frames and anything with a caption go at the top of the folder; the rest are working renders
    dest_dir = os.path.join(H, folder) if (sheet or stem in CAPTIONS or folder == "4_printer_camera") else os.path.join(H, folder, "working_renders")
    os.makedirs(dest_dir, exist_ok=True)
    dest = os.path.join(dest_dir, f"{stamp(src)}_{name}")
    if not os.path.exists(dest):
        shutil.copy2(src, dest); copied += 1

# the scratchpad's mock-up models and sheet scripts, so the drawings can be rebuilt
if SCRATCH:
    for sub in ("", "guide", "mocks", "ct", "sguide", "bath", "bridge"):
        d = os.path.join(SCRATCH, sub)
        if not os.path.isdir(d): continue
        for n in os.listdir(d):
            if n.endswith((".scad", ".py")):
                dd = os.path.join(H, "sources", sub or "scratchpad"); os.makedirs(dd, exist_ok=True)
                shutil.copy2(os.path.join(d, n), os.path.join(dd, n))


def caption(fn):
    m = re.match(r"\d{4}-\d\d-\d\d_\d{4}_(.+)\.\w+$", fn)
    return CAPTIONS.get(m.group(1), "") if m else ""


md = ["# Tank projects: how they evolved", "",
      "Every image from the design work, oldest first in each project. Re-run `python -I tools/collect_history.py <scratchpad>` to add new ones.", ""]
pdir = os.path.join(H, "0_photos_you_sent")
if os.path.isdir(pdir):
    md += ["## Photos you sent", ""]
    for fn in sorted(os.listdir(pdir)):
        key = re.search(r"(photo\d+)", fn)
        md += [f"**{fn[:10]}**: {PHOTOS.get(key.group(1), '') if key else ''}", "", f"<img src=\"0_photos_you_sent/{fn}\" width=\"480\">", ""]
for folder, title, _ in PROJECTS:
    d = os.path.join(H, folder)
    if not os.path.isdir(d): continue
    files = sorted(f for f in os.listdir(d) if os.path.isfile(os.path.join(d, f)))
    md += [f"## {title}", ""]
    for fn in files:
        md += [f"**{fn[:10]} {fn[11:13]}:{fn[13:15]}**: {caption(fn)}", "", f"<img src=\"{folder}/{fn}\" width=\"720\">", ""]
    wr = os.path.join(d, "working_renders")
    if os.path.isdir(wr):
        thumbs = sorted(os.listdir(wr))
        md += [f"<details><summary>Working renders ({len(thumbs)})</summary>", ""]
        md += [" ".join(f"<img src=\"{folder}/working_renders/{t}\" width=\"230\" title=\"{t}\">" for t in thumbs), "", "</details>", ""]
open(os.path.join(H, "README.md"), "w", encoding="utf-8").write("\n".join(md))
print("copied", copied, "new images; README rebuilt")
