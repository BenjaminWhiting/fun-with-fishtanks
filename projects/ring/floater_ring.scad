// Floating corral rings for red root floaters, A1 mini (180 x 180 bed), PETG.
// PETG sinks (1.27 g/cm3), so each ring floats on air sealed inside its hollow channel.
// The channel is split into chambers, so one leak can't sink it. Two solid lugs carry a
// vertical hole for fishing line, a suction-cup tether or the chain's end clip. Prints flat,
// no supports: the chambers have a 45-degree peaked roof.
// Three sizes share one cross-section (so they float alike) and nest on one plate.

OD = 176;        // the large ring's outside diameter (bed is 180)
SIZES = [[176, 8], [132, 6], [88, 4]];   // large, medium, small: [outside diameter, chambers]
W = 8;           // ring width, outside to inside (was 12: slimmer, 2026-11-07)
H = 10;          // height (was 14)
T = 1.26;        // side walls: 3 perimeters (slice with wall_loops = 3)
FL = 1.0;        // floor (5 layers)
TOP = 1.0;       // skin over the roof peak
CH = 0.6;        // chamfer on the top edges
bulk = 1.6;      // bulkhead between chambers
lugs = [0, 180]; // angles of the tie lugs (they replace a bulkhead)
lug_len = 10;    // solid length of a lug
lug_d = 3.2;     // tether hole
// hook loops: a pointed arch on top of each lug, opening outward, so a line or clip can hook on front and back
loop_open = 4.6;   // width of the opening
loop_leg = 2.6;    // straight part of the opening before its 45-degree roof
loop_bar = 1.8;    // thickness of the arch
loop_depth = 2.4;  // radial thickness
$fn = 360;

module hook_loop() {
    a = loop_open / 2; b = loop_bar;
    rotate([90, 0, 90]) translate([0, -0.5, -loop_depth / 2]) linear_extrude(height = loop_depth) difference() {
        polygon([[-a - b, 0], [a + b, 0], [a + b, loop_leg + 0.5], [0, loop_leg + 0.5 + a + b], [-a - b, loop_leg + 0.5]]);
        polygon([[-a, -1], [a, -1], [a, loop_leg + 0.5], [0, loop_leg + 0.5 + a], [-a, loop_leg + 0.5]]);
    }
}

function is_lug(a) = len([for (l = lugs) if (abs(l - a) < 0.01) 1]) > 0;

module ring(od = OD, chambers = 8) {
    R1 = od / 2;
    R0 = R1 - W;
    Rm = (R0 + R1) / 2;
    vw = W - 2 * T;  // chamber width
    peak = vw / 2;   // 45-degree roof
    difference() {
        rotate_extrude() polygon([[R0, 0], [R1, 0], [R1, H - CH], [R1 - CH, H], [R0 + CH, H], [R0, H - CH]]);
        difference() {
            rotate_extrude() polygon([[R0 + T, FL], [R1 - T, FL], [R1 - T, H - TOP - peak], [Rm, H - TOP], [R0 + T, H - TOP - peak]]);
            for (i = [0:chambers - 1]) let(a = i * 360 / chambers, th = is_lug(a) ? lug_len : bulk)
                rotate(a) translate([R0 - 1, -th / 2, -1]) cube([W + 2, th, H + 2]);
        }
        for (a = lugs) rotate(a) translate([Rm, 0, 0]) {
            translate([0, 0, -1]) cylinder(d = lug_d, h = H + 2, $fn = 32);
            translate([0, 0, -0.01]) cylinder(d1 = lug_d + 0.8, d2 = lug_d, h = 0.4, $fn = 32);  // no elephant's foot
            translate([0, 0, H - 0.39]) cylinder(d1 = lug_d, d2 = lug_d + 0.8, h = 0.4, $fn = 32);
        }
    }
    for (a = lugs) rotate(a) translate([Rm, 0, H]) hook_loop();
}

// ---------- the thin D ring (2026-11-07): flat top at the waterline, rounded bottom underneath ----------
// As thin a band as still floats on its own: 4 mm wide from above, with a chain eye hanging under the front and back.
// Modelled as printed: flat top on the plate (z = 0), the rounded bottom upward. In the tank it floats flat side up, about 1 mm proud of the water, like a thin float.
// A sealed chamber follows the curve, so it floats back up even if a refill swamps it (about 1.8 g, 21%, to spare).
// The walls can't get thinner than 2 perimeters, so a narrower band needs a deeper bottom: a half-ellipse 6 mm deep.
// Thinner still: 3.5 mm wide needs 7 mm deep for only 15% to spare; 3 mm can't carry its own walls.
DW = 4;          // band width, seen from above (5/32")
DD = 6;          // depth of the rounded bottom (1/4")
DT = 0.84;       // shell: 2 perimeters (slice with wall_loops = 2)
DFL = 0.6;       // flat top skin (3 layers)
DCH = 0.3;       // chamfer on the flat top's edges (no elephant's foot on the plate)
d_lug_len = 10;  // solid length under each chain eye
// chain eyes: a pointed arch standing on the rounded bottom (on top as printed, so no supports), front and back.
// In the tank it hangs under the ring, out of sight; the opening faces outward for the chain's J-hook.
eye_open = 4.6;  // width of the opening (3/16")
eye_leg = 2.0;   // straight part of the opening above the keel, before its 45-degree roof
eye_bar = 1.8;   // thickness of the arch
eye_depth = 2.4; // radial thickness
eye_sink = 1.4;  // how far the legs run down into the keel

module d_section(R1) let(r = DW / 2)
    translate([R1 - r, 0]) intersection() {
        scale([r, DD]) circle(r = 1, $fn = 120);
        polygon([[-r + DCH, 0], [r - DCH, 0], [r, DCH], [r, DD], [-r, DD], [-r, DCH]]);
    }
module d_chamber(R1)   // the section shrunk evenly by the shell, floored at the flat skin
    intersection() { offset(r = 0.25, $fn = 16) offset(r = -DT - 0.25, $fn = 16) d_section(R1); translate([0, DFL]) square([R1 + 1, DD]); }   // tip rounded: no knife edge

module d_ring(od = OD, chambers = 8) {
    R1 = od / 2; Rm = R1 - DW / 2;
    difference() {
        rotate_extrude() d_section(R1);
        difference() {
            rotate_extrude() d_chamber(R1);
            for (i = [0:chambers - 1]) let(a = i * 360 / chambers, th = is_lug(a) ? d_lug_len : bulk)
                rotate(a) translate([Rm - DW, -th / 2, -1]) cube([2 * DW, th, DD + 2]);
        }
    }
    for (a = lugs) rotate(a) translate([Rm, 0, DD]) d_eye();
}

module d_eye() {   // in the tangent-vertical plane, z = 0 at the keel's crest
    a = eye_open / 2; b = eye_bar; s = eye_sink; top = eye_leg + a;
    rotate([90, 0, 90]) translate([0, 0, -eye_depth / 2]) linear_extrude(height = eye_depth) difference() {
        polygon([[-a - b, -s], [a + b, -s], [a + b, eye_leg], [0, top + b * sqrt(2)], [-a - b, eye_leg]]);
        polygon([[-a, -s - 1], [a, -s - 1], [a, eye_leg], [0, top], [-a, eye_leg]]);
    }
}

part = "d_large";   // d_large | d_medium | d_small | d_cut | (old box rings:) ring | medium | small | plate3 | cut
if (part == "d_large") d_ring(SIZES[0][0], SIZES[0][1]);
if (part == "d_medium") d_ring(SIZES[1][0], SIZES[1][1]);
if (part == "d_small") d_ring(SIZES[2][0], SIZES[2][1]);
if (part == "d_cut") intersection() { d_ring(SIZES[0][0], SIZES[0][1]); rotate(22.5) translate([-OD, 0, -1]) cube([2 * OD, OD, 20]); }
if (part == "ring") ring(SIZES[0][0], SIZES[0][1]);
if (part == "medium") ring(SIZES[1][0], SIZES[1][1]);
if (part == "small") ring(SIZES[2][0], SIZES[2][1]);
if (part == "plate3") for (s = SIZES) ring(s[0], s[1]);
if (part == "cut") intersection() { ring(SIZES[0][0], SIZES[0][1]); rotate(22.5) translate([-OD, 0, -1]) cube([2 * OD, OD, H + 2]); }  // cut through a chamber
