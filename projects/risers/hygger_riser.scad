// Hygger aquarium light riser for rimless tanks
//
// The riser clamps over the top edge of the tank glass and carries a copy of that
// glass edge (the "fin") on top. The light's stock bracket sits on the fin exactly
// as it sat on the tank, so it works whatever shape the bracket foot is.
//
// Print 1 riser for the clear end panel. The end panel with the pump gets the pump
// gate instead (part = gate_legs and gate_beam), which straddles the pump and holds
// the light's foot at the same height. PETG on the Textured PEI plate, upright as
// modelled (slot down), no supports. Every hole is shaped to print without them.
//
// Axes: X runs along the glass, Y goes through the glass, Z is up.
// Z = 0 is the top edge of the tank glass.
//
// LOCKED 2026-10-29: PLA test prints of the bottom (slot and teeth) and the top
// (strip, cradle and end stops) both fit the real tank and light. Everything that
// sets those shapes stays as it is: lift_in, gauge_slot, fit_clear, clamp_depth,
// wall, fin_h, fin_chamfer, foot_len, foot_clear, stop_t, stop_h and width_base.
// The art only cuts the middle band (art_lo..art_hi), so it doesn't touch them.

/* [Main] */
lift_in = 5;          // [3:0.5:5] how much higher the light sits, in inches
glass_t = 8.0;        // tank glass thickness in mm
fit_clear = 0.2;      // gap on each side between the glass and the clamp
gauge_slot = 8.4;     // slot that fit on glass_gauge.scad (0 = use glass_t)

/* [Clamp] */
clamp_depth = 25;     // how far the clamp reaches down over the glass
wall = 4;             // clamp wall thickness

/* [Top fin (fake glass edge)] */
fin_h = 22;           // straight fin height: room for the bracket's foot or hook
fin_chamfer = 0.8;

/* [Light foot cradle] */
foot_len = 80;        // length of the light's foot along the glass
foot_clear = 1;       // play at each end of the foot
stop_t = 3;           // end-stop thickness
stop_h = 5;           // end-stop height above the strip

/* [Shape] */
width_base = 80;      // length along the glass

/* [Art: slatted bonsai, informal upright (B1)] */
tree_sx = 1.1;        // stretch of the tree drawing across...
tree_sz = 1.35;       // ...and up; more up than across keeps every limb steeper than 45 degrees
min_web = 1.4;        // thinnest wall left between two holes

/* [Pump gate: two legs and a beam over the pump] */
gate_beam_len = 300;  // spans an 8.5 in pump; printed in three pieces to fit the A1 mini bed
gate_teeth = 15;      // how far the beam's slot reaches down over the legs' fins
gate_solid = 18;      // beam between its slot and its strip; the leaf band is cut through it
gate_leg_base = 40;   // leg length along the glass at the clamp...
gate_leg_top = 25;    // ...and at its fin, where the beam sits
gate_open = 228;      // gap between the legs, for the assembly preview only
gate_split = 50;      // the beam's joints, either side of the middle (outside the end stops)
gate_tongue = 30;     // each end piece's tongue, which slides into the middle piece's slot
gate_root = 12;       // where the tongue starts, the end piece's own slot is filled solid
gate_leg_stop = 142;  // beyond this the slot is closed, so a leg's fin can't slide out of the beam's end
gate_pin = 4;         // square pins locking the tongues; their holes are 45-degree diamonds
// Three ginkgo leaves on the beam, all the same size: one upright in the middle and
// one at each end leaning in towards it on a curved stem. [x, z, fan radius, lean
// right in degrees, stem bend], where x, z is the foot of the stem (z up from the top
// of the beam's slot) and bend makes the stem's lower half that many degrees more
// upright, so it curves. The leaves rise through the strip's shoulder into the strip,
// keeping its top 3 mm solid under the light's foot.
gate_leaves = [
  [-100, 4.0, 26,  22,  14],
  [   0, 4.0, 26,   0,   0],
  [ 100, 4.0, 26, -22, -14],
];
ginkgo_spread = 66;   // half-angle of the fan's top edge
ginkgo_base = 28;     // half-angle of the narrow wedge where the fan meets its stem
ginkgo_notch = 0.22;  // depth of the notch between the two lobes, as a share of the radius
ginkgo_notch_w = 9;   // half-width of the notch, in degrees of the fan
ginkgo_corner = 0.08; // how much the fan's outer corners are rounded off
ginkgo_stem = 0.36;   // stem length, as a share of the radius
ginkgo_slot = [1.6, 3.0];  // finer than the bonsai's slots, for more veins

/* [Output] */
part = "riser";        // [riser, test_bottom, test_top, gate_legs, gate_beam, gate]
test_above_glass = 10; // test_bottom: how much of the body to keep above the glass
test_below_fin = 12;   // test_top: how much solid body to keep under the strip

/* [Hidden] */
$fn = 64;

lift = lift_in * 25.4;
slot = gauge_slot > 0 ? gauge_slot : glass_t + 2 * fit_clear;
fin_t = slot - 2 * fit_clear;  // as thick as the glass, so the bracket fits as before
thick = slot + 2 * wall;
taper_h = (thick - fin_t) / 2;
z_fin = lift - fin_h;          // where the straight fin starts
z_taper = z_fin - taper_h;     // where the body starts narrowing to the fin
top_len = foot_len + 2 * foot_clear + 2 * stop_t;  // strip length, end stops included
span = max(width_base, top_len) + 2;

// The gate's beam stands on the legs' fins the way the riser stands on the glass,
// so leg_lift + beam_lift is exactly the riser's lift and the light stays level.
beam_lift = gate_solid + taper_h + fin_h;    // beam: top of its slot to top of its strip
leg_lift = lift - beam_lift;                  // leg: glass edge to top of its fin
leg_fin_h = gate_teeth + 1;                   // 1 mm under the beam's teeth, so it rests on the fin top
gate_clear_h = leg_lift - gate_teeth;         // headroom over the glass under the beam
gate_clear_w = 2 * (gate_leg_stop - gate_leg_top);  // widest gap between the legs
gate_clear_min = 2 * (gate_split + gate_root);    // narrowest: the tongues fill the slot near the joints

// window the see-through art has to stay inside
art_lo = 6;
art_hi = z_taper - 6;
art_x = width_base / 2 - 6;

// The tree is drawn in its own units with the bottom of the pot at 0 (the B1
// mock-up), then stretched by tree_sx / tree_sz and centred in the art window.
// Trunk and branches are chains of [x, z, r]; every link climbs at least as much
// as it moves sideways.
trunk = [[0, 19.4, 3.6], [-5, 26, 3.1], [2, 34, 2.6], [-3, 42.5, 2.1], [2, 50, 1.7], [1, 55.5, 1.4]];
branches = [
  [[-4.6, 26.5, 1.6], [-10, 31.9, 1.1], [-13, 35,   0.9]],
  [[ 1.5, 34.5, 1.5], [  7, 40,   1.0], [ 10, 43.2, 0.8]],
  [[-2.8, 43,   1.3], [ -8, 48.2, 0.9], [-11, 51.4, 0.75]],
];
// foliage pads: [x, z, half width, dome height]
pads = [[-17, 31.5, 11.5, 6], [15, 41, 12, 6.2], [-15, 50, 10, 5.5], [3, 57.6, 9.5, 5.5]];
pot = [
  [[-14, 0], [14, 0], [17.5, 9.4], [-17.5, 9.4]],  // bowl
  [[-20, 11], [20, 11], [20, 14], [-20, 14]],      // rim
];
tree_h = 63.1;        // pot bottom to the top of the highest pad
tree_half_w = 28.5;   // widest reach either side of the trunk
leaf_slot = [2.0, 3.4];  // foliage slot width and pitch, in mm whatever the stretch
pot_slot = [2.2, 3.8];
tree_z0 = art_lo + (art_hi - art_lo - tree_h * tree_sz) / 2;
assert(tree_h * tree_sz <= art_hi - art_lo && tree_half_w * tree_sx <= art_x, "bonsai doesn't fit the art window");

// cross-section through the glass (2D x = Y, 2D y = Z)
module side_profile(top = lift, fh = fin_h, bottom = clamp_depth) {
  c = fin_chamfer;
  zf = top - fh;
  zt = zf - taper_h;
  polygon([
    [-thick / 2, -bottom], [thick / 2, -bottom],
    [thick / 2, zt], [fin_t / 2, zf],
    [fin_t / 2, top - c], [fin_t / 2 - c, top],
    [-fin_t / 2 + c, top], [-fin_t / 2, top - c],
    [-fin_t / 2, zf], [-thick / 2, zt],
  ]);
}

// glass slot, with a lead-in chamfer at the mouth
module slot_profile(depth = clamp_depth) {
  m = 1;
  polygon([
    [-slot / 2 - m, -depth - 0.01], [slot / 2 + m, -depth - 0.01],
    [slot / 2, -depth + m], [slot / 2, 0],
    [-slot / 2, 0], [-slot / 2, -depth + m],
  ]);
}

// silhouette seen side-on (2D x = X, 2D y = Z)
// The strip is longer than the body so the light's whole foot fits between the end
// stops; it widens at 45 degrees so the wider top still prints without supports.
module front_outline() {
  wb = width_base / 2;
  wt = top_len / 2;
  c = 2;    // bottom chamfer
  flare = max(wt - wb, 0);
  polygon([
    [-wb + c, -clamp_depth], [wb - c, -clamp_depth], [wb, -clamp_depth + c],
    [wb, z_fin], [wt, z_fin + flare], [wt, lift],
    [-wt, lift], [-wt, z_fin + flare], [-wb, z_fin], [-wb, -clamp_depth + c],
  ]);
}

// blocks at each end of the strip that stop the light's foot sliding off
module end_stops(top = lift) {
  for (s = [-1, 1])
    translate([s * (top_len - stop_t) / 2, 0, top + (stop_h - 1) / 2])
      cube([stop_t, fin_t, stop_h + 1], center = true);
}

// tree units -> riser mm
function tp(p) = [p[0] * tree_sx, tree_z0 + p[1] * tree_sz];

// foliage pad in mm, centred on c: domed top, flatter bottom
function pad_mm(c, a, b, n = 40) =
  concat([for (i = [0:n]) c + [a * cos(180 * i / n), b * sin(180 * i / n)]],
         [for (i = [1:n - 1]) c + [-a * cos(180 * i / n), -0.45 * b * sin(180 * i / n)]]);
// a bonsai pad given in tree units
function pad_pts(p) = pad_mm(tp(p), p[2] * tree_sx, p[3] * tree_sz);

// trunk or branch slot; grow widens it, to keep the foliage slots clear of it
module limb(pts, grow = 0) {
  for (i = [0:len(pts) - 2]) hull()
    for (p = [pts[i], pts[i + 1]]) translate(tp(p)) circle(r = p[2] * tree_sx + grow, $fn = 24);
}

// vertical slots across a window (the riser's art window unless told), one centred on x = 0
module slots(w, pitch, half = art_x, z0 = art_lo, z1 = art_hi) {
  n = ceil(half / pitch);
  for (k = [-n:n]) translate([k * pitch - w / 2, z0 - 1]) square([w, z1 - z0 + 2]);
}

// drop any sliver of a hole narrower than 2 * t (0.8 mm by default); the nozzle can't draw it
module no_slivers(t = 0.4) { offset(r = t) offset(delta = -t) children(); }

// Slatted bonsai cut as a see-through silhouette. Foliage and pot are rows of
// vertical slots whose tops are short flat bridges; trunk and branches lean no more
// than 45 degrees, so nothing needs supports.
module art() {
  no_slivers() intersection() {
    for (p = pot) polygon([for (q = p) tp(q)]);
    slots(pot_slot[0], pot_slot[1]);
  }
  limb(trunk);
  // Each branch stops a web short of the trunk. A branch slot that opened into the
  // trunk slot would make a Y, and the material in the fork of a Y starts as a
  // point with nothing under it.
  no_slivers() difference() {
    for (b = branches) limb(b);
    limb(trunk, min_web);
  }
  no_slivers() difference() {
    intersection() {
      for (p = pads) polygon(pad_pts(p));
      slots(leaf_slot[0], leaf_slot[1]);
    }
    limb(trunk, min_web);
    for (b = branches) limb(b, min_web);
  }
}

module riser(with_art = true) {
  difference() {
    intersection() {
      rotate([90, 0, 90]) linear_extrude(height = span, center = true) side_profile();
      rotate([90, 0, 0]) linear_extrude(height = thick + 2, center = true) front_outline();
    }
    rotate([90, 0, 90]) linear_extrude(height = span + 2, center = true) slot_profile();
    if (with_art)
      rotate([90, 0, 0]) linear_extrude(height = thick + 4, center = true) art();
  }
  end_stops();
}

// Pump-gate leg: the riser's clamp with a plain fin on top for the beam. Its inner
// face (x = 0, toward the pump) is upright; its outer face narrows from the clamp
// to the fin, which keeps a long foot on the glass and a short fin under the beam.
module gate_leg() {
  zt = leg_lift - leg_fin_h - taper_h;
  c = 2;
  difference() {
    intersection() {
      translate([gate_leg_base / 2, 0, 0]) rotate([90, 0, 90])
        linear_extrude(height = gate_leg_base + 2, center = true) side_profile(leg_lift, leg_fin_h);
      rotate([90, 0, 0]) linear_extrude(height = thick + 2, center = true) polygon([
        [c, -clamp_depth], [gate_leg_base - c, -clamp_depth], [gate_leg_base, -clamp_depth + c],
        [gate_leg_base, 0], [gate_leg_top, zt], [gate_leg_top, leg_lift],
        [0, leg_lift], [0, -clamp_depth + c],
      ]);
    }
    translate([gate_leg_base / 2, 0, 0]) rotate([90, 0, 90])
      linear_extrude(height = gate_leg_base + 4, center = true) slot_profile();
  }
}

// Ginkgo fan, apex at the origin, opening up. Its sides leave the stem as a narrow
// wedge and flare out (quadratic curves) to the corners of the broad top edge, which
// is split into two lobes by a notch.
function ginkgo_edge(r, n = 60) = [for (i = [0:n]) let(t = -ginkgo_spread + 2 * ginkgo_spread * i / n,
    k = 1 - ginkgo_notch * max(0, 1 - abs(t) / ginkgo_notch_w) - ginkgo_corner * pow(abs(t) / ginkgo_spread, 6))
  r * k * [sin(t), cos(t)]];
function ginkgo_pts(r, n = 60, m = 16) = let(
    edge = ginkgo_edge(r, n),
    c = 0.5 * r * [sin(ginkgo_base), cos(ginkgo_base)],
    side = function(u, end, ctl) 2 * (1 - u) * u * ctl + u * u * end)
  concat([[0, 0]],
         [for (j = [1:m - 1]) side(j / m, edge[0], [-c[0], c[1]])],
         edge,
         [for (j = [m - 1:-1:1]) side(j / m, edge[n], c)]);

// a leaf's stem as [foot, middle, apex]
function ginkgo_stem_pts(x, z, r, tilt, bend) = let(
    h = ginkgo_stem * r / 2,
    mid = [x, z] + h * [sin(tilt - bend), cos(tilt - bend)])
  [[x, z], mid, mid + h * [sin(tilt), cos(tilt)]];

// the leaf's outline, or just its top edge (left to right), in beam coordinates
function ginkgo_place(pts, x, z, r, tilt, bend) = let(apex = ginkgo_stem_pts(x, z, r, tilt, bend)[2])
  [for (u = pts) apex + [u[0] * cos(tilt) + u[1] * sin(tilt), -u[0] * sin(tilt) + u[1] * cos(tilt)]];
function ginkgo_outline(x, z, r, tilt, bend) = ginkgo_place(ginkgo_pts(r), x, z, r, tilt, bend);

// height of a left-to-right polyline at x, and its lowest point over [x0, x1]
function line_z(pts, x) = let(
    xc = min(max(x, pts[0][0]), pts[len(pts) - 1][0]),
    i = [for (j = [0:len(pts) - 2]) if (pts[j][0] <= xc && xc <= pts[j + 1][0]) j][0],
    a = pts[i], b = pts[i + 1])
  a[1] + (b[1] - a[1]) * (xc - a[0]) / max(b[0] - a[0], 1e-9);
function line_min(pts, x0, x1) = min(concat([line_z(pts, x0), line_z(pts, x1)], [for (q = pts) if (q[0] > x0 && q[0] < x1) q[1]]));

// Slatted ginkgo leaf on a curved stem. The slots stay upright whatever the lean, and
// each slot's top is cut flat at the lowest point of the leaf's edge above it, so it
// is a short bridge even under the notch (a slot top that dipped to a point there
// would leave a sliver of material starting in mid-air). The stem runs into the middle slot like
// a centre vein and stays a web clear of all the others, so the holes never fork;
// neither half of the stem leans more than 45 degrees.
module ginkgo(x, z, r, tilt = 0, bend = 0) {
  stem = ginkgo_stem_pts(x, z, r, tilt, bend);
  assert(abs(tilt) <= 45 && abs(tilt - bend) <= 45, "ginkgo stem leans too far to print");
  w = ginkgo_slot[0];
  n = ceil(1.5 * r / ginkgo_slot[1]);
  module stem(grow = 0)
    for (i = [0:1]) hull() for (q = [stem[i], stem[i + 1]]) translate(q) circle(r = 0.9 + grow, $fn = 24);
  edge = ginkgo_place(ginkgo_edge(r), x, z, r, tilt, bend);
  module blade(ks) intersection() {
    polygon(ginkgo_outline(x, z, r, tilt, bend));
    for (k = ks) let(x0 = stem[2][0] + k * ginkgo_slot[1] - w / 2, top = line_min(edge, x0, x0 + w))
      if (top > z) translate([x0, z]) square([w, top - z]);
  }
  stem();
  // the middle slot, carried right down to the stem at full width so the narrow base
  // of the fan doesn't pinch it off
  translate([stem[2][0] - w / 2, stem[2][1]]) square([w, 2]);
  no_slivers() blade([0]);
  no_slivers(0.6) difference() {
    blade([for (k = [-n:n]) if (k != 0) k]);
    stem(min_web);
  }
}

// True if an outline (beam coordinates) keeps 3 mm of solid above the beam's slot,
// 6 mm from its ends and its joints, and 3 mm under the top of the strip.
function fits_beam(o) =
  min([for (q = o) q[1]]) >= 3 && max([for (q = o) abs(q[0])]) <= gate_beam_len / 2 - 6
  && min([for (q = o) abs(abs(q[0]) - gate_split)]) >= 6 && max([for (q = o) q[1]]) <= beam_lift - 3;

// the beam's leaves, in beam coordinates (2D x along the beam, 2D y up from its slot)
module gate_beam_art() {
  for (p = gate_leaves) {
    assert(fits_beam(concat(ginkgo_outline(p[0], p[1], p[2], p[3], p[4]), [[p[0], p[1] - 0.9]])),
           str("ginkgo leaf ", p, " leaves its room on the beam"));
    ginkgo(p[0], p[1], p[2], p[3], p[4]);
  }
}

// Pump-gate beam. Its underside is a smaller copy of the riser's clamp: a slot along
// its whole length that drops over the legs' fins wherever the pump needs them. Its
// top is the riser's strip and cradle, centred; three slatted ginkgo leaves cut through it.
module gate_beam() {
  c = 2;
  e = gate_beam_len / 2;
  difference() {
    intersection() {
      rotate([90, 0, 90]) linear_extrude(height = gate_beam_len, center = true)
        side_profile(beam_lift, fin_h, gate_teeth);
      rotate([90, 0, 0]) linear_extrude(height = thick + 2, center = true) polygon([
        [-e + c, -gate_teeth], [e - c, -gate_teeth], [e, -gate_teeth + c],
        [e, beam_lift], [-e, beam_lift], [-e, -gate_teeth + c],
      ]);
    }
    rotate([90, 0, 90]) linear_extrude(height = gate_beam_len + 2, center = true) slot_profile(gate_teeth);
    rotate([90, 0, 0]) linear_extrude(height = thick + 4, center = true) gate_beam_art();
  }
  end_stops(beam_lift);
}

// The beam is too long for the bed, so it prints as three pieces. The end pieces each
// carry a tongue, a glass-thick plate that slides into the middle piece's slot and is
// locked there by two square pins through diamond holes (45-degree tops, so they print
// on their side). Under the light the pieces' end faces press together at the top and
// the pins hold the bottom, so the joints carry the load like solid beam.
module gate_pin_holes()
  for (s = [-1, 1], d = [9, 21])
    translate([s * (gate_split - d), 0, -gate_teeth / 2]) rotate([90, 0, 0])
      linear_extrude(height = thick + 2, center = true) rotate(45) square(gate_pin + 0.4, center = true);

// the beam's slot filled solid between x0 and x1
module gate_slot_fill(x0, x1)
  intersection() {
    translate([(x0 + x1) / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = abs(x1 - x0), center = true) slot_profile(gate_teeth);
    translate([min(x0, x1), -thick, -gate_teeth]) cube([abs(x1 - x0), 2 * thick, gate_teeth]);
  }

// An end piece's tongue, rooted by filling the start of its own slot, and the plug
// that closes the far end of that slot. Each leg's fin is trapped between the two,
// so the beam can't slide off a leg; it lowers onto the fins from above.
module gate_tongue(s) {
  translate([s * (gate_split - gate_tongue / 2), 0, -gate_teeth / 2]) cube([gate_tongue, fin_t, gate_teeth], center = true);
  gate_slot_fill(s * gate_split, s * (gate_split + gate_root));
  gate_slot_fill(s * gate_leg_stop, s * gate_beam_len / 2);
}

// piece 0 is the middle (cradle and centre leaf); -1 and 1 are the end pieces
module gate_beam_piece(piece) {
  e = gate_beam_len / 2;
  difference() {
    union() {
      intersection() {
        gate_beam();
        if (piece == 0) cube([2 * gate_split - 0.1, 3 * thick, 4 * beam_lift], center = true);
        else translate([piece * (gate_split + e) / 2, 0, 0]) cube([e - gate_split, 3 * thick, 4 * beam_lift], center = true);
      }
      if (piece != 0) gate_tongue(piece);
    }
    gate_pin_holes();
  }
}

// a square pin with chamfered ends, lying on its side as printed
module gate_pin_part() {
  l = thick - 0.4;
  hull() {
    cube([l - 1, gate_pin, gate_pin], center = true);
    cube([l, gate_pin - 1, gate_pin - 1], center = true);
  }
}

// the gate as it sits on the glass, legs gate_open apart
module gate() {
  assert(gate_open <= gate_clear_w && gate_open >= gate_clear_min, "legs outside the range the beam allows");
  for (s = [-1, 1]) translate([s * gate_open / 2, 0, 0]) mirror([s < 0 ? 1 : 0, 0, 0]) gate_leg();
  translate([0, 0, leg_lift]) for (piece = [-1, 0, 1]) gate_beam_piece(piece);
}

echo(str("pump gate: legs ", gate_clear_min, " to ", gate_clear_w, " mm apart, ", gate_clear_h,
         " mm headroom over the glass; leg ", leg_lift, " + beam ", beam_lift, " = ", leg_lift + beam_lift));

// Sitting on the bed, turned so the long side runs along the A1 mini's moving
// bed (Y). The tall, thin part then only sways in its stiff direction.
rotate([0, 0, 90])
  if (part == "test_bottom")
    // just the clamp and a solid band above the glass, to try the fit cheaply
    translate([0, 0, clamp_depth]) intersection() {
      riser(with_art = false);
      translate([-span, -thick, -clamp_depth - 1]) cube([2 * span, 2 * thick, clamp_depth + 1 + test_above_glass]);
    }
  else if (part == "test_top")
    // just the strip and end stops on a solid band, to try the light's foot
    translate([0, 0, test_below_fin - z_fin]) intersection() {
      riser(with_art = false);
      translate([-span, -thick, z_fin - test_below_fin]) cube([2 * span, 2 * thick, test_below_fin + fin_h + stop_h + 1]);
    }
  else if (part == "gate_legs")
    // both legs upright on their clamps, brims kept apart
    for (s = [-1, 1]) translate([0, s * 18, clamp_depth])
      mirror([s < 0 ? 1 : 0, 0, 0]) translate([-gate_leg_base / 2, 0, 0]) gate_leg();
  else if (part == "gate_beam") {
    // the three beam pieces side by side, upright on their slots, and the four pins
    for (piece = [-1, 0, 1])
      translate([-piece * (gate_split - gate_tongue + gate_beam_len / 2) / 2, piece * 36, gate_teeth])
        gate_beam_piece(piece);
    for (i = [0:3]) translate([-36 + 24 * i, 62, gate_pin / 2]) gate_pin_part();
  }
  else if (part == "gate")
    gate();
  else
    translate([0, 0, clamp_depth]) riser();
