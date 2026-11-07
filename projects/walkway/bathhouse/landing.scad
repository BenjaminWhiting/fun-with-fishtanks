// Concept mock-ups of a bigger fishing landing for the middle of the front run, with three
// ideas for its far (water-side) edge. Not print-ready: shapes only, at true size.
// which: 0 fishing pavilion (tsuridono), 1 old pine, 2 red parasol and bench
use <centre.scad>
which = 0;
fisher_on = true;
M = "scenery/";  // boardwalk pieces, for the scene renders only
$fn = 24;

WOOD = [0.55, 0.38, 0.24]; GROOVE = [0.30, 0.20, 0.13]; DARKWOOD = [0.38, 0.26, 0.17];
VERM = [0.80, 0.22, 0.13]; ROOF = [0.27, 0.26, 0.27]; RIDGE = [0.16, 0.15, 0.16];
BARK = [0.36, 0.30, 0.26]; PINE = [0.20, 0.36, 0.22]; PINE_L = [0.27, 0.45, 0.27];
CLOTH = [0.72, 0.11, 0.12]; STONE = [0.64, 0.64, 0.61];
LBRONZE = [0.40, 0.31, 0.18]; LIT = [0.99, 0.85, 0.52];
GLASS = [0.75, 0.90, 0.90, 0.30]; WATER = [0.45, 0.68, 0.80, 0.25];

Lc = 134.3; seg = 152.4; arm = 81.25; T = 914.4; D = 381; xr = T - 8;
xc = arm + 2 * seg + Lc / 2;
z_top = 13.3; post = 3.2; rail_y = 13.2; water_z = -25;

// ---------- the landing: the whole length of the centre segment, reaching 2 in over the water ----------
ld = 50.8;                         // how far it reaches past the walk
y0 = 16; y1 = y0 + ld;             // its near and far edges
sx = Lc / 2 - 1.6;                 // its side rails, in line with the joint posts
slab = 3.5;
// ---------- a grand lantern post for each of the platform's four outer corners ----------
// a taller, heavier post carrying a six-sided bronze lantern: lit paper windows, a roof with
// curled tips, and a jewel (hoju) finial; about 1 11/16 in above the deck
lantern_corners = true;
lp = 4.2; lph = 24;                  // post width and height
module post_lantern(x, y) translate([x, y, z_top]) {
  color(WOOD) {
    translate([-lp / 2, -lp / 2, -1]) cube([lp, lp, lph + 1]);
    translate([-3, -3, lph - 1]) cube([6, 6, 1]);
  }
  color(LBRONZE) {
    translate([0, 0, lph]) cylinder(d = 8.4, h = 1.2, $fn = 6);
    translate([0, 0, lph + 1.2]) cylinder(d = 6.6, h = 0.6, $fn = 6);
    // the fire box frame: top and bottom rings, a window in each face
    translate([0, 0, lph + 1.8]) difference() {
      cylinder(d = 7.6, h = 7.2, $fn = 6);
      translate([0, 0, 0.7]) cylinder(d = 6.4, h = 5.8, $fn = 6);
      for (a = [30:60:330]) rotate([0, 0, a]) translate([3.3, 0, 3.6]) cube([2, 2.5, 5.2], center = true);
    }
    translate([0, 0, lph + 9]) cylinder(d1 = 14, d2 = 12, h = 0.8, $fn = 6);          // eaves
    translate([0, 0, lph + 9.8]) cylinder(d1 = 12, d2 = 2, h = 5, $fn = 6);           // roof
    for (a = [0:60:300]) rotate([0, 0, a]) translate([7, 0, lph + 9.5]) sphere(d = 1.5, $fn = 8);   // curled tips
    translate([0, 0, lph + 14.6]) cylinder(d = 1.6, h = 1.1, $fn = 12);
    translate([0, 0, lph + 16.6]) sphere(d = 2.8, $fn = 16);                         // the jewel
    translate([0, 0, lph + 17.6]) cylinder(d1 = 1.6, d2 = 0, h = 1.8, $fn = 12);
  }
  color(LIT) translate([0, 0, lph + 2.5]) cylinder(d = 6.3, h = 5.8, $fn = 6);        // the glowing paper
}

// a platform off the walk's +y side, `depth` past it: the landing as is, the balcony mirrored
module platform(depth, far_rail = false) let(yf = y0 + depth) {
  color(WOOD) {
    translate([-Lc / 2 + 0.05, y0 - 0.1, z_top - slab]) cube([Lc - 0.1, depth + 0.1, slab]);
    // joists out to the far edge, each held by a 45-degree knee brace off the clamp's tooth
    for (x = [-Lc / 2 + 6, -22, 22, Lc / 2 - 6]) {
      translate([x - 1.2, y0, z_top - slab - 3]) cube([2.4, depth, 3]);
      hull() {
        translate([x - 1.2, 8.2, -12]) cube([2.4, 2, 2]);
        translate([x - 1.2, 8.2 + 16.8, z_top - slab - 3 - 2]) cube([2.4, 2, 2]);
      }
    }
    translate([-Lc / 2 + 0.05, yf - 3, z_top - slab - 3]) cube([Lc - 0.1, 3, 3]);   // the far-edge beam
  }
  color(GROOVE) for (y = [y0 + 3.2:3.2:yf - 1]) translate([-Lc / 2 + 0.05, y, z_top]) cube([Lc - 0.1, 0.45, 0.08]);
  // side rails, turning off the walk's rail at the joints
  color(WOOD) for (s = [-1, 1]) let(x = s * sx) {
    mpost(x, y0 + depth / 2, z_top);
    if (!lantern_corners) mpost(x, yf - 1.6, z_top);
    for (z = [7, 15]) rail_between([x, rail_y, z_top + z], [x, yf - 1.6, z_top + z]);
  }
  if (lantern_corners) for (s = [-1, 1]) post_lantern(s * sx, yf - 1.6);
  if (far_rail) color(WOOD) {
    for (x = [-33.575, 0, 33.575]) mpost(x, yf - 1.6, z_top);
    for (z = [7, 15]) rail_between([-sx, yf - 1.6, z_top + z], [sx, yf - 1.6, z_top + z]);
  }
  // the neighbours' rails end on half posts at the joints: these are the other halves
  color(WOOD) for (s = [-1, 1]) mpost(s * (Lc / 2 - 0.8), rail_y, z_top, 18, 1.55);
}
module landing() platform(ld);                       // the far edge stays open for fishing

// ---------- the balcony: the same platform out over the room side, railed all round ----------
bd = 50.8;                         // as far out over the room as the landing reaches over the water
balcony_on = false;
module balcony() mirror([0, 1, 0]) platform(bd, true);
module balcony_lanterns() for (s = [-1, 1]) toro(s * (Lc / 2 - 9), -(y0 + bd - 9), z_top);

// ---------- 0: a tsuridono, the fishing pavilion of old Japanese pond gardens ----------
pw = 52; pd = 28; pyc = y1 - 4 - pd / 2;   // post spacing along the walk and across, and its middle
he = 44;                                    // eaves, about 7 ft at 1:48
module pavilion() {
  ow = pw / 2 + 9; od = pd / 2 + 8;         // the eaves' overhang
  color(DARKWOOD) {
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx * pw / 2 - 1.3, pyc + sy * pd / 2 - 1.3, z_top]) cube([2.6, 2.6, he]);
    // the beams the roof sits on
    for (sy = [-1, 1]) translate([-pw / 2 - 2, pyc + sy * pd / 2 - 1.3, z_top + he - 3]) cube([pw + 4, 2.6, 3]);
    for (sx = [-1, 1]) translate([sx * pw / 2 - 1.3, pyc - pd / 2 - 2, z_top + he - 3]) cube([2.6, pd + 4, 3]);
    // a low rail along the back: the fisherman leans on it
    translate([-pw / 2, pyc + pd / 2 - 0.8, z_top + 9]) cube([pw, 1.6, 1.6]);
  }
  // a hipped roof with a flared skirt, ridge along the walk so its broad side faces the room
  zr = z_top + he;
  module ring(w, d, z, t = 0.8) translate([-w, pyc - d, z]) cube([2 * w, 2 * d, t]);
  color(ROOF) {
    hull() { ring(ow, od, zr); ring(ow - 7, od - 7, zr + 3.2); }
    hull() { ring(ow - 7, od - 7, zr + 3.2); translate([-pw / 2 + 6, pyc - 0.6, zr + 21]) cube([pw - 12, 1.2, 0.8]); }
  }
  color(RIDGE) {
    translate([-pw / 2 + 5, pyc, zr + 21.6]) rotate([0, 90, 0]) cylinder(d = 2.8, h = pw - 10, $fn = 12);
    for (sx = [-1, 1]) translate([sx * (pw / 2 - 5) - 1.6, pyc - 1.8, zr + 20]) cube([3.2, 3.6, 3.4]);
  }
}

// ---------- 1: an old pine, the landing built round it, leaning out over the water ----------
// a flat silhouette facing the room, in three layers: trunk and branches, back pads, front pads
trunk = [[40, 0, 6.5], [43, 14, 5.6], [38, 28, 5], [26, 40, 4.4], [10, 49, 3.8], [-8, 55, 3.2], [-24, 57, 2.6]];
limbs = [[[38, 28, 3], [54, 36, 2]], [[26, 40, 3], [30, 58, 2.2]], [[10, 49, 2.6], [2, 68, 2]], [[-8, 55, 2.4], [-20, 66, 1.8]]];
pads_back = [[56, 37, 15, 5.5], [30, 60, 17, 6], [2, 70, 15, 5.5], [-28, 58, 17, 5.5], [-14, 67, 11, 4.5]];
pads_front = [[52, 34, 11, 4], [34, 57, 12, 4.5], [-2, 66, 11, 4], [-32, 55, 12, 4], [12, 51, 9, 3.5]];
module path2d(pts) for (i = [0:len(pts) - 2]) hull() for (p = [pts[i], pts[i + 1]]) translate([p[0], p[1]]) circle(d = p[2]);
module pads2d(ps) for (p = ps) translate([p[0], p[1]]) scale([p[2], p[3]]) circle(r = 1, $fn = 36);
module pine() translate([0, y1 - 9, z_top]) {
  thru = [0, 0, 1];
  color(BARK) rotate([90, 0, 0]) linear_extrude(height = 4, center = true) { path2d(trunk); for (l = limbs) path2d(l); }
  color(PINE) translate([0, 2.6, 0]) rotate([90, 0, 0]) linear_extrude(height = 3, center = true) pads2d(pads_back);
  color(PINE_L) translate([0, -2.6, 0]) rotate([90, 0, 0]) linear_extrude(height = 3, center = true) pads2d(pads_front);
  color(STONE) for (a = [0:40:359]) translate([40 + 6 * cos(a), 4 * sin(a), 0]) scale([1, 0.8, 0.6]) sphere(d = 3.4, $fn = 10);
}

// ---------- 2: a red parasol (nodate-gasa) over a bench draped in red cloth ----------
module parasol_bench() {
  bx = 12; by = y1 - 11;
  color(DARKWOOD) for (sx = [-1, 1], sy = [-1, 1]) translate([bx + sx * 17 - 0.9, by + sy * 4.5 - 0.9, z_top]) cube([1.8, 1.8, 8.6]);
  color(CLOTH) {
    translate([bx - 19, by - 6.5, z_top + 8.6]) cube([38, 13, 1.1]);
    translate([bx - 19, by - 6.6, z_top + 4.5]) cube([38, 0.3, 4.2]);     // the cloth hanging down the front
  }
  px = -22; py = by - 2;
  color(DARKWOOD) translate([px, py, z_top]) rotate([0, 7, 0]) cylinder(d = 1.6, h = 56, $fn = 8);
  color(VERM) translate([px, py, z_top]) rotate([0, 7, 0]) translate([0, 0, 44]) {
    cylinder(r1 = 27, r2 = 2, h = 11, $fn = 48);
    translate([0, 0, 10.5]) cylinder(d = 3.4, h = 1.4);
  }
  // the ribs, as fine lines on the canopy
  color([0.55, 0.12, 0.08]) translate([px, py, z_top]) rotate([0, 7, 0]) translate([0, 0, 44])
    for (a = [0:15:359]) rotate([0, 0, a]) hull() { translate([2, 0, 11]) sphere(d = 0.5, $fn = 6); translate([27, 0, 0.1]) sphere(d = 0.6, $fn = 6); }
}

// ---------- the front run ----------
// which 3: the landing alone; which 9: magenta markers only, to map the plan view's pixels
mk_pts = [[xc - 60, 0, 0], [xc + 60, 60, 0]];
solo = false;                      // the centre piece alone, on a slice of glass, for the side section
module markers() color([1, 0, 1]) for (p = mk_pts) translate(p) sphere(d = 3);
if (which == 9) markers(); else {
  if (!solo) color(WOOD) {
    import(str(M, "bw_x_c.stl"));
    translate([xr, 0, 0]) rotate([0, 0, 90]) import(str(M, "bw_x_c.stl"));
    for (x = [arm + seg / 2, arm + 3 * seg / 2, xc + Lc / 2 + seg / 2, xc + Lc / 2 + 3 * seg / 2]) translate([x, 0, 0]) import(str(M, "guide/seg.stl"));
  }
  translate([xc, 0, 0]) {
    color(WOOD) import(str(M, balcony_on ? "mocks/f_bare.stl" : "mocks/f_open.stl"));
    landing();
    if (balcony_on) balcony();
    if (which == 0) pavilion();
    if (which == 1) pine();
    if (which == 2) parasol_bench();
    if (!balcony_on && which <= 2) toro(Lc / 2 - 10, y0 + 9, z_top);
    if (fisher_on) {
      if (which == 0) translate([-44, y1 - 7, z_top]) fisher();
      if (which == 1) translate([-46, y1 - 6, z_top]) fisher();
      if (which == 2) translate([46, y1 - 6, z_top]) fisher();
      if (which == 3) translate([-30, y1 - 7, z_top]) fisher();     // the locked design: just the fisherman on the open edge
    }
  }
  if (solo) {
    color([0.62, 0.80, 0.80]) translate([xc - Lc / 2, -4, -120]) cube([Lc, 8, 120]);
    color([0.55, 0.74, 0.86]) translate([xc - Lc / 2, 4, -120]) cube([Lc, 140, 120 + water_z]);
  }
  if (!solo) color(GLASS) {
    translate([-4, -4, -300]) cube([T, 8, 300]);
    translate([-4, -4, -300]) cube([8, D, 300]);
    translate([xr - 4, -4, -300]) cube([8, D, 300]);
    translate([-4, D - 12, -300]) cube([T, 8, 300]);
  }
  if (!solo) color(WATER) translate([4, 4, -300]) cube([xr - 8, D - 16, 300 + water_z]);
}
