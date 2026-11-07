// Floating corral ring for red root floaters, A1 mini (180 x 180 bed), PETG.
// PETG sinks (1.27 g/cm3), so the ring floats on air sealed inside its hollow channel.
// The channel is split into 8 chambers, so one leak can't sink it. Two solid lugs carry a
// vertical hole for fishing line or a suction-cup tether. Prints flat, no supports: the
// chambers have a 45-degree peaked roof.

OD = 176;        // outside diameter (bed is 180)
W = 12;          // ring width, outside to inside
H = 14;          // height
T = 1.7;         // side walls: 4 perimeters
FL = 1.0;        // floor (5 layers)
TOP = 1.0;       // skin over the roof peak
CH = 0.8;        // chamfer on the top edges
chambers = 8;
bulk = 1.6;      // bulkhead between chambers
lugs = [0, 180]; // angles of the tie lugs (they replace a bulkhead)
lug_len = 10;    // solid length of a lug
lug_d = 3.2;     // tether hole

R1 = OD / 2;
R0 = R1 - W;
Rm = (R0 + R1) / 2;
vw = W - 2 * T;  // chamber width
peak = vw / 2;   // 45-degree roof
$fn = 360;

module section() polygon([[R0, 0], [R1, 0], [R1, H - CH], [R1 - CH, H], [R0 + CH, H], [R0, H - CH]]);
module chamber_section()
    polygon([[R0 + T, FL], [R1 - T, FL], [R1 - T, H - TOP - peak], [Rm, H - TOP], [R0 + T, H - TOP - peak]]);

function is_lug(a) = len([for (l = lugs) if (abs(l - a) < 0.01) 1]) > 0;

module ring() difference() {
    rotate_extrude() section();
    difference() {
        rotate_extrude() chamber_section();
        for (i = [0:chambers - 1]) let(a = i * 360 / chambers, th = is_lug(a) ? lug_len : bulk)
            rotate(a) translate([R0 - 1, -th / 2, -1]) cube([W + 2, th, H + 2]);
    }
    for (a = lugs) rotate(a) translate([Rm, 0, 0]) {
        translate([0, 0, -1]) cylinder(d = lug_d, h = H + 2, $fn = 32);
        translate([0, 0, -0.01]) cylinder(d1 = lug_d + 0.8, d2 = lug_d, h = 0.4, $fn = 32);  // no elephant's foot
        translate([0, 0, H - 0.39]) cylinder(d1 = lug_d, d2 = lug_d + 0.8, h = 0.4, $fn = 32);
    }
}

part = "ring";   // ring | cut (half, to show the chambers)
if (part == "ring") ring();
if (part == "cut") intersection() { ring(); rotate(22.5) translate([-OD, 0, -1]) cube([2 * OD, OD, H + 2]); }  // cut through a chamber
