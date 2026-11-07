// Concept mock-ups of three centrepieces for the middle of the tank's front run, in place
// of the filler. Not print-ready: shapes only, at true size on the real boardwalk.
// which: 0 drum bridge, 1 torii gate, 2 fishing landing
which = 0;
fisher_on = true;
M = "scenery/";  // boardwalk pieces, for the scene renders only
$fn = 20;

WOOD = [0.55, 0.38, 0.24]; PLANK = [0.66, 0.50, 0.33]; GROOVE = [0.30, 0.20, 0.13];
VERM = [0.80, 0.22, 0.13]; BLACK = [0.14, 0.13, 0.13]; BRONZE = [0.62, 0.50, 0.26];
STONE = [0.64, 0.64, 0.61]; STONE_D = [0.40, 0.40, 0.38];
GLASS = [0.75, 0.90, 0.90, 0.30]; WATER = [0.45, 0.68, 0.80, 0.25];

Lc = 134.3; seg = 152.4; arm = 81.25; T = 914.4; D = 381; xr = T - 8;
xc = arm + 2 * seg + Lc / 2;     // the run's middle
z_top = 13.3; post = 3.2; rail_y = 13.2; water_z = -25;

// ---------- the scale figure: a 1:48 fisherman about 1 7/16 in tall, rod out over the water ----------
module fisher(rod = true, rod_dir = 90) {
  color([0.20, 0.22, 0.30]) for (s = [-1, 1]) translate([0, s * 1.6, 0]) cylinder(d = 2.6, h = 13);
  color([0.27, 0.38, 0.58]) translate([0, 0, 10]) cylinder(d1 = 8.5, d2 = 6.4, h = 17);
  color([0.27, 0.38, 0.58]) translate([0, 0, 25]) sphere(d = 7);
  color([0.88, 0.73, 0.58]) translate([0, 0, 30]) sphere(d = 5.4);
  color([0.84, 0.72, 0.45]) translate([0, 0, 31.6]) cylinder(d1 = 15, d2 = 0.6, h = 5.2);
  if (rod) rotate([0, 0, rod_dir - 90]) {
    tip = [0, 2.5 + 48 * cos(35), 21 + 48 * sin(35)];
    color([0.25, 0.17, 0.1]) hull() { translate([0, 2.5, 21]) sphere(d = 1.1); translate(tip) sphere(d = 0.5); }
    color([0.92, 0.92, 0.92]) translate(tip) mirror([0, 0, 1]) cylinder(d = 0.25, h = 100, $fn = 6);
  }
}

// ---------- simple railing pieces for the mock ----------
module mpost(x, y, z0, h = 18, w = post) {
  translate([x - w / 2, y - post / 2, z0 - 1]) cube([w, post, h + 1]);
  translate([x, y, z0 + h]) rotate([90, 0, 0]) linear_extrude(height = post, center = true)
    polygon([[-w / 2, 0], [w / 2, 0], [0, w / 2]]);
}
module rail_between(a, b, d = 1.6) hull() { translate(a) sphere(d = d, $fn = 10); translate(b) sphere(d = d, $fn = 10); }

// a giboshi: the bronze onion cap on a bridge post
module giboshi(x, y, z) translate([x, y, z]) {
  cylinder(d = 4.2, h = 0.9);
  translate([0, 0, 0.9]) cylinder(d = 3.0, h = 0.8);
  translate([0, 0, 3.4]) scale([1, 1, 1.1]) sphere(d = 4.6);
  translate([0, 0, 5.4]) cylinder(d1 = 1.8, d2 = 0, h = 3.2);
}

// ---------- 0: taiko-bashi, a drum bridge ----------
rise = 16;     // 5/8 in at the crown
N = 48;
function bump(x) = rise * (1 + cos(180 * x / (Lc / 2))) / 2;
function top(x) = z_top + bump(x);
function xi(i) = -Lc / 2 + i * Lc / N;
// the straight segment's cross-section with its neck raised by b: clamp, 45-degree flare, deck
module spine(x) translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 0.01)
  polygon([[-8.2, -12], [8.2, -12], [8.2, 2 + bump(x)], [-8.2, 2 + bump(x)]]);
module flare(x) let(b = bump(x)) translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 0.01)
  polygon([[-8.2, 2 + b], [8.2, 2 + b], [16, 9.8 + b], [16, 13.3 + b], [-16, 13.3 + b], [-16, 9.8 + b]]);
module planks(x) let(b = bump(x)) translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 0.01)
  polygon([[-15.5, 13.1 + b], [15.5, 13.1 + b], [15.5, 13.38 + b], [-15.5, 13.38 + b]]);
module bridge() {
  color(VERM) for (i = [0:N - 1]) { hull() { spine(xi(i)); spine(xi(i + 1)); } hull() { flare(xi(i)); flare(xi(i + 1)); } }
  color(PLANK) for (i = [0:N - 1]) hull() { planks(xi(i)); planks(xi(i + 1)); }
  // planks run across the bridge
  color(GROOVE) for (x = [-Lc / 2 + 2:3.6:Lc / 2 - 2]) let(sl = (top(x + 0.5) - top(x - 0.5)))
    translate([x, 0, top(x) + 0.04]) rotate([0, -atan(sl), 0]) cube([0.45, 31, 0.12], center = true);
  // railings: posts capped with giboshi, rails following the arch, a heavier top rail
  posts = [-Lc / 2, -33.575, 0, 33.575, Lc / 2];
  for (s = [-1, 1]) {
    color(VERM) for (x = posts) mpost(x, s * 14, top(x), 17, x == posts[0] || x == posts[4] ? 3.6 : post);
    color(BRONZE) for (x = posts) giboshi(x, s * 14, top(x) + 17 - 0.2);
    color(VERM) for (i = [0:N - 1]) {
      rail_between([xi(i), s * rail_y, top(xi(i)) + 7], [xi(i + 1), s * rail_y, top(xi(i + 1)) + 7]);
      rail_between([xi(i), s * rail_y, top(xi(i)) + 14.5], [xi(i + 1), s * rail_y, top(xi(i + 1)) + 14.5], 2.3);
    }
  }
}

// ---------- 1: a torii over the walk ----------
module torii() {
  h = 50;                       // pillar height above the deck: a fisherman walks under the tie beam
  for (s = [-1, 1]) {
    color(VERM) translate([0, s * 15, z_top]) cylinder(d = 4.2, h = h);
    color(BLACK) translate([0, s * 15, z_top]) cylinder(d = 5.0, h = 3);
  }
  color(VERM) translate([-1.1, -23, z_top + h - 12]) cube([2.2, 46, 2.6]);          // nuki, the tie beam
  color(VERM) translate([-0.9, -1.6, z_top + h - 9.4]) cube([1.8, 3.2, 9.4]);       // gakuzuka, the strut
  color(VERM) translate([-1.6, -24, z_top + h]) cube([3.2, 48, 2.2]);               // shimaki
  // kasagi, the black top beam, its ends sweeping up
  color(BLACK) translate([0, 0, z_top + h + 2.2]) rotate([90, 0, 90]) linear_extrude(height = 3.8, center = true)
    polygon(concat([for (t = [-1:0.1:1.001]) [t * 30, 3.2 * pow(abs(t), 3)]],
                   [for (t = [1:-0.1:-1.001]) [t * 31.5, 3.2 + 3.4 * pow(abs(t), 3)]]));
}

// ---------- 2: a fishing landing over the water, with a stone lantern ----------
lw = 73.2; ld = 28;               // landing length along the walk, and how far it reaches over the water
module toro(x, y, z) translate([x, y, z]) {
  color(STONE) cylinder(d = 7.5, h = 1.6, $fn = 6);
  color(STONE) cylinder(d = 3.2, h = 9);
  color(STONE) translate([0, 0, 9]) cylinder(d = 7, h = 1.6, $fn = 6);
  difference() {
    color(STONE) translate([0, 0, 10.6]) cylinder(d = 5.6, h = 4.6, $fn = 6);
    color(STONE_D) for (r = [0, 60, 120]) rotate([0, 0, r]) translate([0, 0, 12.9]) cube([7, 2, 2.6], center = true);
  }
  color(STONE) translate([0, 0, 15.2]) cylinder(d1 = 10.5, d2 = 2.2, h = 3.6, $fn = 6);
  color(STONE) translate([0, 0, 19.2]) sphere(d = 2.4);
}
module landing() {
  color(WOOD) {
    translate([-lw / 2, 15.9, z_top - 3.5]) cube([lw, ld + 0.1, 3.5]);
    // knee braces from the clamp's inside face, at 45 degrees, and a beam under the far edge
    for (x = [-lw / 2 + 4, 0, lw / 2 - 4]) hull() {
      translate([x - 1.2, 8.2, -12]) cube([2.4, 2, 2]);
      translate([x - 1.2, 8.2 + 19, z_top - 3.5 - 2]) cube([2.4, 2, 2]);
    }
    translate([-lw / 2, 16 + ld - 3, z_top - 6]) cube([lw, 3, 2.6]);
  }
  color(GROOVE) for (y = [16 + 3.2:3.2:16 + ld - 1]) translate([-lw / 2, y, z_top]) cube([lw, 0.45, 0.08]);
  // railings round its two sides, the far edge left open for fishing
  color(WOOD) for (s = [-1, 1]) let(x = s * 35) {
    for (y = [16 + ld / 2, 16 + ld - 1.6]) mpost(x, y, z_top);
    for (z = [7, 15]) rail_between([x, 14, z_top + z], [x, 16 + ld - 1.6, z_top + z]);
  }
  toro(-lw / 2 + 9, 16 + ld - 8, z_top);
}

// ---------- the front run: corners, two straight segments each side, the centrepiece ----------
color(WOOD) {
  import(str(M, "bw_x_c.stl"));
  translate([xr, 0, 0]) rotate([0, 0, 90]) import(str(M, "bw_x_c.stl"));
  for (x = [arm + seg / 2, arm + 3 * seg / 2, xc + Lc / 2 + seg / 2, xc + Lc / 2 + 3 * seg / 2]) translate([x, 0, 0]) import(str(M, "guide/seg.stl"));
}
translate([xc, 0, 0]) {
  if (which == 0) bridge();
  if (which == 1) { color(WOOD) import(str(M, "mocks/f_torii.stl")); torii(); }
  if (which == 2) { color(WOOD) import(str(M, "mocks/f_land.stl")); landing(); }
  if (fisher_on) {
    if (which == 0) translate([6, 3, top(6)]) fisher();
    if (which == 1) translate([40, 4, z_top]) fisher();
    if (which == 2) translate([8, 16 + ld - 5, z_top]) fisher();
  }
}
color(GLASS) {
  translate([-4, -4, -300]) cube([T, 8, 300]);
  translate([-4, -4, -300]) cube([8, D, 300]);
  translate([xr - 4, -4, -300]) cube([8, D, 300]);
  translate([-4, D - 12, -300]) cube([T, 8, 300]);
}
color(WATER) translate([4, 4, -300]) cube([xr - 8, D - 16, 300 + water_z]);
