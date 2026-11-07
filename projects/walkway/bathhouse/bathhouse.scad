// Concept v13: the bathhouse that IS the back-left corner piece. It fills the corner piece's
// whole square and the walks run straight into its doors: the back walk into the right
// door, and a future walk along the left end glass into the front door. Inspired by the
// bathhouse in Spirited Away (an original design, not a copy): a tall crimson stucco body
// with small dark windows, wooden lattice boxes with green roofs stuck all over it, a
// wooden upper floor jutting out on brackets, a lattice box jutting off its veranda, a
// big swooping roof with a golden gable to the front, lattice window boxes on its right
// slope, a white lattice base under a green roof band. Playful extras: a boiler house at the
// back with a fat chimney, a water tank, koinobori and fat pipes all over the outside (each
// on its own level, none into the water), and a porch at the front with a pump and a bench.
// v4: a thinner crimson core so the wooden floor juts out further on stepped brackets; no
// flag, smoke, cat or tub; the boiler moved to the back and the porch to the front.
// v5: no plants or towels; every pipe 3.5 to 5 mm and kept to its own level, never across
// the roof band; a 4 mm carp pole strapped to the boiler and the chimney.
// Then: the pump house closed up against the core with no gaps; the star window became a
// lattice box; the turret became three lattice boxes on the right slope; no spinner; nothing
// clips or floats loose (lantern check: scene lclip).
// v7: a top tier rising out of the main roof behind its golden gable, with a balcony and its own
// roof; the chimney and carp pole stretched to stay the tallest.
// v8: lit from inside: a puck light on a tray that slides in through the back wall, hollow floors
// joined by a light shaft up into the top tier, and the windows real openings with bump-out
// frames and grid bars, paper behind.
// v9: every window an open grid with no glass or paper; the lattice boxes, the roof's window boxes
// and the pump house hollow and open to the light too. No tray: the back opening is left open and
// the puck slides in on the floor to a curb. Two 5/16" holes up through the floor in the tank's
// corner for an air hose; every pipe runs visibly from one thing into another, with real bends.
// v10: the back opening 1" tall and about 3 1/8" wide, so fingers reach in for the hose and puck;
// the two back windows over it dropped. No carp pole.
// v11: fewer pipes, for a cleaner look: only the steam line and the pump's two pipes on the porch,
// and the water tank's outlet. Then a clipping audit of the whole model.
// v12: walls and roofs: the walls' tops sit well inside their roofs instead of a hair under the
// roofs' surfaces, and the lattice boxes' side walls rise to meet their sloping roofs (no gap).
// v13: printable (parts13.scad splits it): nothing hangs in the air when printed (45-degree undersides on the
// curled roof corners and the brackets, a full gable board under the front door's arch, pipes resting on the
// porch or the pump), the real L-shaped clamp slot with 1/2" teeth, key pockets at both walk joints, the puck's
// track sunk into the floor, the chimney pegged into a socket, the lanterns left off for now.
//
// Axes: the piece's own. The back glass runs along y = 0 with the tank at -y (toward the
// viewer); the left end glass runs along x = 0 with the tank at +x. Z = 0 is the glass top.
use <centre.scad>
use <landing.scad>
P = "scenery/";  // boardwalk pieces, for the scene renders only
scene = "corner";      // corner, joint, tank, plan, elev, mass, markers
details = true;
fisher_on = true;
mk_pts = [[-20, -90, 0], [90, 20, 0]];
cut = -30;             // the cutaway removes everything in front of this y
li = [0, 0, 0, 4, 6];  // the lantern the clipping check looks at: x, y, top, diameter, length
$fn = 24;

BODY = [0.74, 0.16, 0.20]; BODY_D = [0.50, 0.08, 0.12]; POST = [0.40, 0.10, 0.10];
TIMBER = [0.45, 0.31, 0.22]; TIMBER_D = [0.27, 0.18, 0.12]; RAIL = [0.80, 0.15, 0.14];
ROOF = [0.27, 0.64, 0.42]; ROOF_D = [0.16, 0.44, 0.28]; GOLD = [0.92, 0.76, 0.26];
LATTICE = [0.96, 0.95, 0.91]; DARK = [0.20, 0.12, 0.09]; LIT = [1.0, 0.82, 0.45];
PAPER = [0.97, 0.93, 0.82]; INDIGO = [0.16, 0.20, 0.45]; WHITE = [0.94, 0.93, 0.89];
BUTTER = [0.95, 0.84, 0.42]; BRICK = [0.62, 0.32, 0.25]; PLANK = [0.40, 0.36, 0.32];
RUST = [0.66, 0.36, 0.22]; STEAM = [0.97, 0.97, 0.97]; WOOD = [0.55, 0.38, 0.24];
STONE = [0.60, 0.60, 0.57]; LRED = [0.92, 0.24, 0.13]; TUB = [0.72, 0.55, 0.34];
HOTWATER = [0.55, 0.82, 0.92]; PINE = [0.30, 0.55, 0.26]; PINE_D = [0.20, 0.42, 0.20];
BARK = [0.42, 0.32, 0.24]; PIPE = [0.72, 0.46, 0.28]; TERRA = [0.80, 0.40, 0.25]; PIPE_D = [0.50, 0.30, 0.18]; IRON = [0.36, 0.35, 0.34];
GLASS = [0.75, 0.90, 0.90, 0.30]; WATER = [0.45, 0.68, 0.80, 0.25]; GHOST = [0.55, 0.38, 0.24, 0.35];

z_top = 13.3;            // the walks' surface
zf = z_top + 3.5;        // the bathhouse floor, one step up from the walks
arm = 81.25;             // both arms: the corner piece's usual reach along each pane
seg = 152.4; T = 914.4; D = 381; yb = D - 8; xr = T - 8; Lc = 134.3; xc = arm + 2 * seg + Lc / 2;
S = [-16, arm, -arm, 16];           // the corner piece's whole square
G = [-15, arm - 1, -arm + 1, 15];   // the ground floor, filling it
zG = zf + 40;                       // the ground floor's top
z0r = zG - 2.3; h0r = 6;            // the green roof band round it
zT = z0r + h0r;                     // the flat roof the upper parts stand on
Tb = [-7, 42, -66, 15];             // the crimson core, thin so the floor above juts out...
zW = zT + 40;                       // ...the wooden floor, on three stepped tiers of brackets...
W = [-19, 54, -78, 15];
hW = 17;
zR = zW + hW - 1.5;                 // ...and the main roof's eaves
Bo = [42, 78, -34, 12];             // the boiler house, at the back, against the core
Po = [44, 75.5, -76, -35];          // the porch, at the front
T2 = [9, 26, -54, -9];              // the top tier's walls, straddling the main roof's ridge
P2 = [T2[0] - 2.5, T2[1] + 2.5, T2[2] - 2.5, T2[3] + 2.5];   // its base: a balcony all round
zP = zR + 21.5;                     // the base's top, just above the main roof's ridge cap
hT2 = 18; zR2 = zP + hT2 - 1.5;     // the top floor, and its roof's eaves

function ctr(r) = [(r[0] + r[1]) / 2, (r[2] + r[3]) / 2];
function half(r) = [(r[1] - r[0]) / 2, (r[3] - r[2]) / 2];
function rnd(i) = (sin(i * 127.1 + 311.7) * 43758.5453) - floor(sin(i * 127.1 + 311.7) * 43758.5453);
module box(r, z0, h) translate([r[0], r[2], z0]) cube([r[1] - r[0], r[3] - r[2], h]);

// ---------- roofs ----------
function jr_pt(k, N, X, Y) = let(s = floor(k / N), f = (k % N) / N,
  c = [[-X, -Y], [X, -Y], [X, Y], [-X, Y]], a = c[s], b = c[(s + 1) % 4]) a + (b - a) * f;
function jr_corner(k, N, X, Y, dd) = let(s = floor(k / N), f = (k % N) / N, Ls = (s % 2 == 0) ? 2 * X : 2 * Y,
  d = min(f, 1 - f) * Ls) pow(max(0, 1 - d / dd), 2);
function jr_z(t, h) = h * (0.35 * t + 0.65 * t * t);
module jroof(ax, ay, bx, by, h, lift = 3, push = 0.05, ft = 1.2, N = 16, L = 10, ui = 0) {
  M = 4 * N;
  dd = 0.55 * min(ax, ay);
  rings = [for (j = [0:L]) let(t = j / L, X = ax + (bx - ax) * t, Y = ay + (by - ay) * t)
    [for (k = [0:M - 1]) let(p = jr_pt(k, N, X, Y), c = jr_corner(k, N, ax, ay, dd), g = 1 + push * c * (1 - t))
      [p[0] * g, p[1] * g, jr_z(t, h) + lift * c * pow(1 - t, 2)]]];
  inner = [for (k = [0:M - 1]) let(p = jr_pt(k, N, ax - ui, ay - ui)) [p[0], p[1], -ft]];   // v11: the flat underside's edge
  // v13: under each curled corner, the underside runs down from the eave's lifted edge at 45 degrees to the
  // flat underside, so the roof prints standing on its underside with nothing hanging
  mid = [for (k = [0:M - 1]) let(e = rings[0][k], i = inner[k], dv = [i[0] - e[0], i[1] - e[1]], f = max(e[2], 0.3) / norm(dv))
    [e[0] + dv[0] * f, e[1] + dv[1] * f, -ft]];
  pm = printable && ui > 0;
  pts = concat([for (p = rings[0]) [p[0], p[1], p[2] - ft]], [for (r = rings) each r], [[0, 0, -ft], [0, 0, h]], ui > 0 ? inner : [], pm ? mid : []);
  Bc = (L + 2) * M; Tc = Bc + 1;
  function id(r, k) = r * M + (k % M);
  function bi(k) = Tc + 1 + (k % M);
  function mi(k) = Tc + 1 + M + (k % M);
  faces = concat(
    [for (r = [0:L], k = [0:M - 1]) each [[id(r, k), id(r + 1, k), id(r + 1, k + 1)], [id(r, k), id(r + 1, k + 1), id(r, k + 1)]]],
    pm ? concat([for (k = [0:M - 1]) each [[mi(k), id(0, k), id(0, k + 1)], [mi(k), id(0, k + 1), mi(k + 1)]]],
                [for (k = [0:M - 1]) each [[bi(k), mi(k), mi(k + 1)], [bi(k), mi(k + 1), bi(k + 1)]]],
                [for (k = [0:M - 1]) [Bc, bi(k), bi(k + 1)]])
    : ui > 0 ? concat([for (k = [0:M - 1]) each [[bi(k), id(0, k), id(0, k + 1)], [bi(k), id(0, k + 1), bi(k + 1)]]], [for (k = [0:M - 1]) [Bc, bi(k), bi(k + 1)]])
           : [for (k = [0:M - 1]) [Bc, id(0, k), id(0, k + 1)]],
    [for (k = [0:M - 1]) [Tc, id(L + 1, k + 1), id(L + 1, k)]]);
  polyhedron(pts, faces);
}
// hipped below with irimoya gables near the ridge (along x), ridge cap, gold ridge ends;
// ribbed: gold ribs on the gables, like the film's golden gable
module crown(ax, ay, xg, h, col = ROOF, gable = GOLD, lift = 4, ribs = true, ui = 0) {
  bh = max(0.5, ax - ay);
  t1 = 0.45;
  function cprof(t1) = concat([for (i = [0:10]) let(t = t1 + (1 - t1) * i / 10) [-(ay - (ay - 0.4) * t), jr_z(t, h)]],
                              [for (i = [10:-1:0]) let(t = t1 + (1 - t1) * i / 10) [(ay - (ay - 0.4) * t), jr_z(t, h)]]);
  prof = cprof(t1);
  // v13: the gable's green body reaches down until its ends meet the hip below, so nothing overhangs the hip
  t1p = printable ? min(t1, (ax - xg) / (ax - bh) - 0.01) : t1;
  color(col) {
    jroof(ax, ay, bh, 0.4, h, lift = lift, ui = ui);
    rotate([90, 0, 90]) linear_extrude(height = 2 * xg, center = true) offset(delta = 0.25) polygon(cprof(t1p));
  }
  if (details) for (s = [-1, 1]) {
    color(gable) translate([s * (xg + 0.1), 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 0.4, center = true) offset(delta = -0.9) polygon(prof);
    if (ribs) color([0.80, 0.62, 0.18]) intersection() {
      translate([s * (xg + 0.35), 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 0.3, center = true) offset(delta = -0.9) polygon(prof);
      for (y = [-ay:1.6:ay]) translate([s * (xg + 0.35) - 0.5, y - 0.25, 0]) cube([1, 0.5, h + 2]);
    }
  }
  color(ROOF_D) translate([-xg - 1.5, -1.3, h - 0.5]) cube([2 * xg + 3, 2.6, 2.2]);
  color(GOLD) for (s = [-1, 1]) {
    hull() { translate([s * (xg + 0.6) - 1.2, -1.2, h]) cube([2.4, 2.4, 1]); translate([s * (xg + 2.2) - 0.8, -0.9, h + 4]) cube([1.6, 1.8, 0.8]); }
    hull() { translate([s * (xg + 2.2) - 0.8, -0.9, h + 4]) cube([1.6, 1.8, 0.8]); translate([s * (xg + 0.4) - 0.6, -0.7, h + 6]) cube([1.2, 1.4, 0.8]); }
  }
}

// ---------- walls ----------
module win(u0, u1, y, z0, z1, lit = true, frame = DARK) {
  color(frame) translate([u0, y - 0.35, z0]) cube([u1 - u0, 0.35, z1 - z0]);
  color(lit ? LIT : PAPER) translate([u0 + 0.6, y - 0.55, z0 + 0.6]) cube([u1 - u0 - 1.2, 0.3, z1 - z0 - 1.2]);
  nv = max(1, round((u1 - u0) / 2.4)); nh = max(1, round((z1 - z0) / 2.6));
  color(frame) {
    if (nv > 1) for (k = [1:nv - 1]) translate([u0 + k * (u1 - u0) / nv - 0.2, y - 0.75, z0]) cube([0.4, 0.3, z1 - z0]);
    if (nh > 1) for (k = [1:nh - 1]) translate([u0, y - 0.75, z0 + k * (z1 - z0) / nh - 0.2]) cube([u1 - u0, 0.3, 0.4]);
  }
}
// white diamond lattice on a dark backing, in a face's plane (u along, z up, out toward -y)
module lattice(u0, u1, y, z0, z1, p = 2.2) {
  color(BODY_D) translate([u0, y - 0.3, z0]) cube([u1 - u0, 0.3, z1 - z0]);
  color(LATTICE) intersection() {
    translate([u0, y - 0.7, z0]) cube([u1 - u0, 0.5, z1 - z0]);
    for (s = [-1, 1], k = [-ceil((z1 - z0) / p) - 1:ceil((u1 - u0) / p) + 1])
      translate([u0 + k * p + (s < 0 ? (z1 - z0) : 0), y - 0.7, z0]) rotate([0, s * 45, 0]) translate([-0.25, 0, -1]) cube([0.5, 0.5, 2 * (z1 - z0) + 4]);
  }
  color(POST) { translate([u0, y - 0.8, z1 - 0.7]) cube([u1 - u0, 0.8, 0.7]); translate([u0, y - 0.8, z0]) cube([u1 - u0, 0.8, 0.7]); }
}
// one face of a storey, as the -y face of a storey centred on the origin
module face(L, d, h, n, low, gaps, seed, post_col, ribbon, posts, nowin = []) {
  sp = L / n;
  if (posts) color(post_col) for (i = [0:n]) translate([-L / 2 + i * sp - 1.1, -d - 0.7, 0]) cube([2.2, 2.2, h]);
  if (details) for (i = [0:n - 1]) let(u0 = -L / 2 + i * sp + 1.1, u1 = u0 + sp - 2.2, um = (u0 + u1) / 2)
    if (len([for (g = gaps) if (um > g[0] && um < g[1]) 1]) == 0) {
      if (low > 0) lattice(u0 - (posts ? 0 : 1.1), u1 + (posts ? 0 : 1.1), -d, 1.4, low);
      if ((ribbon || rnd(i * 13 + seed) > 0.35) && len([for (g = nowin) if (um > g[0] && um < g[1]) 1]) == 0) win(u0 + (ribbon ? 0 : 1.6), u1 - (ribbon ? 0 : 1.6), -d, low + (ribbon ? 1.4 : 4), h - (ribbon ? 2.6 : 6), rnd(i * 7 + seed) > 0.25);
    }
}
module storey(r, z0, h, wall, bay = 10, low = 0, gaps = [], seed = 0, post_col = POST, ribbon = false, posts = true, nowin = []) {
  c = ctr(r); hh = half(r);
  color(wall) box(r, z0, h);
  for (f = [0:3]) let(L = f % 2 == 0 ? 2 * hh[0] : 2 * hh[1], d = f % 2 == 0 ? hh[1] : hh[0], n = max(2, round(L / bay)))
    translate([c[0], c[1], z0]) rotate([0, 0, 90 * f]) face(L, d, h, n, low, [for (g = gaps) if (g[0] == f) [g[1], g[2]]], seed + f, post_col, ribbon, posts, [for (g = nowin) if (g[0] == f) [g[1], g[2]]]);
}
// small dark square windows scattered over a stucco face, a few lit
module stucco_windows(r, z0, h, seed, skip = []) {
  c = ctr(r); hh = half(r);
  if (details) for (f = [0:3]) let(L = f % 2 == 0 ? 2 * hh[0] : 2 * hh[1], d = f % 2 == 0 ? hh[1] : hh[0])
    translate([c[0], c[1], z0]) rotate([0, 0, 90 * f])
      for (row = [0:floor((h - 6) / 9)], col = [0:floor((L - 8) / 7)]) let(k = seed + f * 101 + row * 17 + col, u = -L / 2 + 5 + col * 7 + (row % 2) * 2.5, z = 5 + row * 9)
        if (rnd(k) > 0.45 && u < L / 2 - 4 && len([for (s = skip) if (s[0] == f && u > s[1] && u < s[2] && z > s[3] && z < s[4]) 1]) == 0)
          color(rnd(k + 5) > 0.78 ? LIT : DARK) translate([u - 1.1, -d - 0.3, z]) cube([2.2, 0.35, rnd(k + 9) > 0.5 ? 3.2 : 2.4]);
}
// ---------- doors, signs and lanterns ----------
module karahafu(hw = 15, H = 10, E = 3.4, tb = 2.2, y0 = -86.5, y1 = -76, board = true) {
  function zu(u) = H * pow(0.5 + 0.5 * cos(180 * u), 0.8) + E * pow(max(0, abs(u) - 0.72) / 0.28, 2);
  up = [for (i = [0:40]) let(u = -1 + i / 20) [u * hw, zu(u)]];
  lo = [for (i = [40:-1:0]) let(u = -1 + i / 20) [u * (hw - 0.6), zu(u) - tb]];
  color(ROOF) translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(height = y1 - y0) polygon(concat(up, lo));
  color(GOLD) translate([0, y0 + 0.4, 0]) rotate([90, 0, 0]) linear_extrude(height = 0.8) polygon(concat(up, lo));
  // v13: the gable board fills the whole arch, back to the wall, so the arch prints with nothing hanging
  ga = [for (i = [0:40]) let(u = -1 + i / 20) [u * (hw - 0.6), max(0.4, zu(u) - tb + 0.05)]];
  color(GOLD) translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(height = y1 - y0 - 1.8) polygon(concat(ga, [[hw - 0.6, 0], [-(hw - 0.6), 0]]));
  color(RAIL) translate([-8, y0 + 1.2, 0.3]) cube([16, 1.3, 1.8]);   // v13: a short tie beam across the gable's foot, under the arch
  // a name board on the gable
  if (board) {
    color(TIMBER) translate([-3.5, y0 + 1.6, 2.9]) cube([7, 0.6, 3.4]);   // above the roof band, under the gable's curve
    translate([0, y0 + 1.7, 4.6]) rotate([90, 0, 0]) yu(2.8, GOLD, 0.9, 0.12);   // 0.8 mm proud of its board
  }
}
module yu(size, col = [0.97, 0.97, 0.94], th = 0.15, grow = 0)
  if (details) color(col) linear_extrude(height = th) offset(delta = grow) text("ゆ", size = size, font = "Yu Gothic:style=Bold", halign = "center", valign = "center");
// a door with its noren, as if in the -y face at the origin
module door(w = 15, h = 34) {
  color(DARK) translate([-w / 2, -0.35, zf]) cube([w, 0.4, h]);
  color(POST) for (s = [-1, 1]) translate([s * (w / 2 + 0.9) - 1.1, -1.2, zf]) cube([2.2, 1.6, h + 1.5]);
  color(DARK) translate([-w / 2 - 1, -1.4, zf + h - 0.8]) cube([w + 2, 0.8, 0.8]);
  color(INDIGO) for (k = [0:2]) translate([-w / 2 + k * w / 3 + 0.15, -1.0, zf + h - 11]) cube([w / 3 - 0.3, 0.75, 10.2]);
}
$lmode = 0;                          // 2 leaves the lanterns out (the clipping check)
lanterns = false;                    // v13: the hanging lanterns are left off for now (holes under the brackets mark them)
module chochin(x, y, zt, d = 4.4, l = 6, striped = false, hook = 0) if ($lmode != 2 && lanterns) {
  echo(str("LANTERN|", x, "|", y, "|", zt, "|", d, "|", l));
  color(DARK) translate([x, y, zt - 1.6]) cylinder(d = 1, h = 2.2 + hook, $fn = 8);   // up into the ceiling
  color(DARK) translate([x, y, zt - 2.4]) cylinder(d = d * 0.62, h = 0.8);
  color(LRED) translate([x, y, zt - 2.4 - l / 2]) scale([1, 1, l / d]) sphere(d = d);
  color(LRED) translate([x, y, zt - 2.4 - l - 0.3]) cylinder(d = d * 0.5, h = l + 0.4);   // joins the body to its caps
  if (striped) color(LATTICE) for (f = [-0.22, 0.22]) translate([x, y, zt - 2.4 - l / 2 + f * l - 0.5]) cylinder(d = d * 0.97 * sqrt(1 - 4 * f * f), h = 1.0);
  color(DARK) translate([x, y, zt - 2.4 - l - 0.6]) cylinder(d = d * 0.62, h = 0.8);
}

// ---------- the base: clamp, floor, foundation ----------
module clamp() color(WOOD) difference() {
  union() {
    translate([-12.4, -8.2, -12]) cube([arm + 12.4, 16.4, 14]);
    hull() { translate([-12.4, -8.2, 2]) cube([arm + 12.4, 16.4, 0.01]); translate([-16, -16, 9.8]) cube([arm + 16, 32, 0.01]); }
    translate([-8.2, -arm, -12]) cube([16.4, arm + 12.4, 14]);
    hull() { translate([-8.2, -arm, 2]) cube([16.4, arm + 12.4, 0.01]); translate([-16, -arm, 9.8]) cube([32, arm + 16, 0.01]); }
  }
  // v13: the corner piece's L-shaped glass slot (boardwalk.scad's corner_slot, in this piece's axes): 8.4 mm
  // wide, 1/2" teeth with a 1 mm lead-in at the mouth, 1.3 mm of room past the glass's outer corner, and the
  // inside corner cut back 6 mm, clear of the silicone bead
  translate([-5.5, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = arm + 6.5) slot2d();
  translate([0, 5.5, 0]) rotate([90, 0, 0]) linear_extrude(height = arm + 6.5) slot2d();
  translate([0, 0, -13]) linear_extrude(height = 13) polygon([[4.19, -4.19], [10.2, -4.19], [4.19, -10.2]]);
}
module slot2d() polygon([[-5.2, -12.01], [5.2, -12.01], [4.2, -11], [4.2, 0], [-4.2, 0], [-4.2, -11]]);
module foundation() {
  color(STONE) box(S, 9.8, zf - 9.8);
  // beams and 45-degree knee braces under the part over the water
  color(TIMBER_D) for (k = [0:3]) let(c = 26 + k * 17) {
    translate([c - 2, S[2], 6.8]) cube([4, -S[2] - 16, 3.3]);
    hull() { translate([c - 2, -10.2, -12]) cube([4, 3, 3]); translate([c - 2, -27.2, 5]) cube([4, 3, 3]); }
    translate([16, -c - 2, 6.8]) cube([S[1] - 16, 4, 3.3]);
    hull() { translate([7.2, -c - 2, -12]) cube([3, 4, 3]); translate([24.2, -c - 2, 5]) cube([3, 4, 3]); }
  }
}

// ---------- the building ----------
gc = ctr(G); gh = half(G);
module ground() difference() {
  union() {
  // crimson walls with a white lattice skirt and a few lit lattice windows; the doors
  // sit on the two joints, centred on the walks
  lstorey(G, zf - 1.5, zG - zf + 1.5, BODY, 12, 14.5, [[0, -32.6 - 10, -32.6 + 10], [1, 32.6 - 10, 32.6 + 10]], 1, POST, false, false, [[0, -22.6, -13], [2, -31, -28], [2, -7, -5]], [zf - 3, zG + 0.5], tdrop = 0.8);
  translate([0, G[2], 0]) door();
  translate([G[1], 0, 0]) rotate([0, 0, 90]) door();
  // the green roof band all round, a karahafu rising out of it over the front door
  translate([gc[0], gc[1], z0r]) color(ROOF) jroof(gh[0] + 5, gh[1] + 5, gh[0] - 4, gh[1] - 4, h0r, 3, ui = 5);
  intersection() { translate([0, 0, z0r - 1.5]) karahafu(); translate([-40, -100, z0r - 1.2]) cube([80, 40, 30]); }   // v13: its feet flat on the band's underside
  for (s = [-1, 1]) color(RAIL) translate([s * 12.3 - 1.2, -arm - 0.2, zf]) cube([2.4, 2.4, z0r - 1.3 - zf]);   // v13: up to just under the band
  // a sign board standing on the roof band over the right door, facing the walk as it arrives:
  // upright and level on two posts, its bottom edge clear of the band, which curls up toward the
  // back corner
  translate([G[1] + 2.75, 0, z0r + 2.6]) rotate([0, 0, 90]) {
    color(TIMBER) translate([-11, -0.6, 0]) cube([22, 1.2, 7.5]);
    color(TIMBER_D) for (x = [-9.5, 9.5]) translate([x - 0.6, -0.6, -3.2]) cube([1.2, 1.2, 3.7]);   // v13: near its ends, so its ends don't overhang
    color(GOLD) for (x = [-9.6, 9.6]) translate([x, -0.5, 3.75]) rotate([90, 0, 0]) cylinder(d = 1.4, h = 0.3, $fn = 12);
    translate([0, -0.5, 3.75]) rotate([90, 0, 0]) yu(5.5, GOLD, 1.1, 0.15);   // 1 mm proud of the board
  }
  if (details) {
    for (s = [-1, 1]) chochin(s * 14.8, -arm - 2.2, z0r - 1.6, 4.6, 6.4, hook = s < 0 ? 2.3 : 0);
    for (s = [-1, 1]) chochin(arm + 2.2, s * 11.5, z0r - 0.8, 4.6, 6.4, hook = s > 0 ? 1 : 0);
    for (x = [22, 32, 42, 52]) chochin(x, -arm - 2.8, z0r - 0.6, 3.6, 5, true);
  }
  }
  color(INSIDE) box(inset(G, TH + 0.2), zf - 3, z0r - 1.2 - zf + 3);                 // v13: hollow up to the band's underside (the band prints standing on it)
  color(INSIDE) box(inset(Tb, TH), z0r - 2, zT - z0r + 2.5);                    // the light shaft, on up into the core
  color(INSIDE) translate([tx[0] - 0.3, G[3] - TH - 0.6, zf - 3]) cube([tx[1] - tx[0] + 0.6, TH + 3, slot_h + 3]);   // the back opening, left open: the puck slides in, the hose and cord come out
}
module tower() {
  zb = zW - 12;                       // the core's top: the brackets step out 4 mm per 4 mm from here
  // the thin crimson core, with small windows and wooden lattice boxes stuck on at odd heights
  module bays(part) {
    translate([6, Tb[2], zT + 3]) baywin(13, 5, 9, part);
    translate([28, Tb[2], zT + 12]) baywin(14, 5.5, 10, part);
    translate([Tb[0], -44, zT + 6]) rotate([0, 0, -90]) baywin(13, 5, 10, part);
    translate([Tb[0], -8, zT + 14]) rotate([0, 0, -90]) baywin(10, 4, 8, part);
  }
  difference() {
    union() { color(BODY) box(Tb, z0r + 1, zb - z0r - 1); bays("add"); }   // v13: down into the band, which slopes away at the back
    color(INSIDE) box(inset(Tb, TH), z0r, zb - z0r + 1);
    stucco_cuts(Tb, zT, zb - zT, 3, [[0, -26, -3.6, 0, 30], [0, 2, 19, 0, 30], [1, -18, -2, 0, 30], [1, -37.5, -17.8, 0, 30], [3, 10.6, 26.9, 0, 30], [3, -23.9, -11.1, 0, 30]]);
    bays("cut");
    color(INSIDE) pump_void();   // open into the pump house (v13: through a passage with a gabled ceiling)
  }
  bays("bars");
  paper_lining(Tb, zT, zb - zT);
  // three tiers of brackets, each 4 mm out and 4 mm up, with gold bracket ends
  // v13: each tier steps out with a 45-degree underside (a 1 mm ledge, then 3 mm at 45 degrees), so the
  // brackets print with nothing hanging; at the front they reach 3 mm further, under the veranda's edge
  Wb = [W[0], W[1], W[2] - 3, W[3]];
  difference() {
  for (k = [1:3]) let(r = [for (i = [0:3]) Tb[i] + (Wb[i] - Tb[i]) * k / 3], rp = [for (i = [0:3]) Tb[i] + (Wb[i] - Tb[i]) * (k - 1) / 3],
                      rb = [for (i = [0:3]) r[i] - 3 * sign(r[i] - rp[i])], z = zb + (k - 1) * 4) {
    color(k % 2 == 1 ? TIMBER_D : TIMBER) hull() { box(rb, z, 0.01); box(r, z + 3, 1.01); }
    if (details) color(GOLD) {
      for (x = [r[0] + 1.5:3.2:r[1] - 1]) translate([x - 0.5, r[2] - 0.3, z + 3.05]) cube([1, 0.5, 0.9]);
      for (y = [r[2] + 1.5:3.2:r[3] - 1]) for (sx = [r[0] - 0.2, r[1] - 0.3]) translate([sx, y - 0.5, z + 3.05]) cube([0.5, 1, 0.9]);
    }
  }
  color(INSIDE) box(inset(Tb, TH), zb - 1, zW - zb + 1.5);   // the light shaft up through the brackets
  // v13: the lanterns are left off for now; holes under the brackets mark where they hang, for later
  color(DARK) {
    for (x = [0, 12, 39.5]) translate([x, Tb[2] - 2.6, zb - 1]) cylinder(d = 2, h = 4.1, $fn = 12);
    for (y = [-70, -58, -46]) translate([W[1] - 2, y, zW - 4.5]) cylinder(d = 2, h = 4, $fn = 12);
  }
  }
  if (details) for (x = [0, 12, 39.5]) chochin(x, Tb[2] - 2.6, zb - 0.2, 3.8, 5.2, true);
  // the wooden floor: a ribbon of lattice windows, a veranda along the front, and a lattice box
  // jutting out on a bracket at the veranda's right end
  bx = [40, W[1]];
  module wbay(part) translate([(bx[0] + bx[1]) / 2, W[2], zW + 2]) baywin(bx[1] - bx[0], 5, 7.5, part);
  difference() {
    union() {
      lstorey(W, zW, hW - 0.6, TIMBER, 7, 0, [], 5, TIMBER_D, true, true, [], [zW - 0.01, zW + hW], tdrop = 1.4);   // its top stays under the main roof's sweep
      intersection() { wbay("add"); translate([-50, -120, zW - 0.5]) cube([200, 200, 50]); }   // v13: its bracket starts on the top tier
    }
    wbay("cut");
  }
  wbay("bars");
  color(TIMBER_D) translate([W[0], W[2] - 3.05, zW - 1.2]) cube([bx[0] - 0.2 - W[0], 3.05, 1.2]);   // v13: on the top bracket tier
  if (details) color(RAIL) {
    for (x = [W[0] + 0.6:5:bx[0] - 1]) translate([x - 0.6, W[2] - 3, zW]) cube([1.2, 1.2, 6]);
    translate([bx[0] - 1.4, W[2] - 3, zW]) cube([1.2, 1.2, 6]);
    translate([W[0], W[2] - 3.2, zW + 5]) cube([bx[0] - 0.2 - W[0], 1.6, 1.2]);
    translate([W[0], W[2] - 2.9, zW + 2.6]) cube([bx[0] - 0.2 - W[0], 1, 0.8]);
  }
  // the main roof, ridge running front to back so its golden gable faces the room
  difference() {
    union() {
      translate([ctr(W)[0], ctr(W)[1], zR]) rotate([0, 0, 90]) crown(half(W)[1] + 6, half(W)[0] + 6, 41, 19, ui = 6);
      dormers("add");
    }
    color(INSIDE) box(inset(T2, TH), zR - 1.5, zP - zR + 2);   // the light shaft up into the top tier
    dormers("cut");                                             // and the window boxes' insides, open to the floor below
  }
  dormers("bars");
}
// an iron strap from a to b (pipe clips, brackets)
module strap(a, b, w = 1.8) color(IRON) hull() { translate(a) sphere(d = w, $fn = 10); translate(b) sphere(d = w, $fn = 10); }
// the chimney's centre at height z (it leans: rotate([2, 5, 0]) from its base at (69, 2, zT + 10))
function chim(z) = let(h = (z - zT - 10) / (cos(2) * cos(5))) [69 + h * cos(2) * sin(5), 2 - h * sin(2), z];
// the top and underside of the boiler house's lean-to roof at x, and a flashing collar where a
// pipe comes up through it
function rtop(x) = zT + bh + 7.2 - 6 * (x - 48.5) / 32.5;
function rund(x) = rtop(x) - 1.2;
module boot(x, y, d) color(DARK) translate([x, y, rtop(x) - 1.3]) cylinder(d1 = d + 3.4, d2 = d + 1, h = 2.9, $fn = 20);

// the boiler house, at the back, against the core: a tall plank part under the jutting floor, a
// shed with a rusty lean-to roof against it, a wooden water tank and a fat leaning chimney.
// Its walls meet the roof all the way along, so there's no gap under it from any side
bh = 22;
// v13: the chimney is its own part, pegged into a socket through the collar on the pump house roof
module chim_frame() translate([69, 2, zT + 10]) rotate([2, 5, 0]) children();
module chimney_body() {
  color(BRICK) cylinder(d1 = 12, d2 = 8.6, h = 120, $fn = 32);
  color(WHITE) translate([0, 0, 95]) cylinder(d = 10, h = 4, $fn = 32);
  color(DARK) { for (z = [[42, 11.6], [69, 10.8]]) translate([0, 0, z[0]]) cylinder(d = z[1], h = 1.2, $fn = 32); translate([0, 0, 117.4]) cylinder(d = 10.2, h = 2.6, $fn = 32); }
}
hs_c = (zT + bh + 7.2 - 6 * (70 - 48.5) / 32.5 + 1.6 - zT - 10) / (cos(2) * cos(5));   // the collar's top, up the chimney's axis
spig = [8, 9];                                                                          // the chimney's peg: diameter, length
module chimney_part() {   // the chimney as printed: all of it above the collar, and its peg
  intersection() { chimney_body(); translate([-10, -10, hs_c]) cube([20, 20, 130]); }
  color(BRICK) translate([0, 0, hs_c - spig[1]]) cylinder(d = spig[0], h = spig[1] + 0.01, $fn = 32);
}
module chim_socket() chim_frame() translate([0, 0, hs_c - spig[1] - 0.4]) cylinder(d = spig[0] + 0.3, h = spig[1] + 1.4, $fn = 32);
// the pump house's hollow: a passage from the core to its window, with a 45-degree gabled ceiling
module pump_void() let(pv = [Tb[1] - TH - 0.5, 63.5, Bo[2] + TH, Bo[2] + TH + 11]) hull() {
  translate([pv[0], pv[2], zT + 0.5]) cube([pv[1] - pv[0], pv[3] - pv[2], 18.4]);
  translate([pv[0], (pv[2] + pv[3]) / 2 - 0.01, zT + 18.9]) cube([pv[1] - pv[0], 0.02, 5.5]);
}
xr0 = W[1] - 0.5;                      // where the lean-to roof starts, just inside the tall part
// how high the front wall shows at x: up to each bracket tier under the floor, then to the roof
function wtop(x) = x < Tb[1] + (W[1] - Tb[1]) / 3 ? zW - 12 : x < Tb[1] + 2 * (W[1] - Tb[1]) / 3 ? zW - 8 : x < W[1] ? zW - 4 : rund(x);
module boiler() {
  difference() {
    union() {
      color(PLANK) {
        translate([Bo[0], Bo[2], zT - 2]) cube([W[1] - Bo[0], Bo[3] - Bo[2], zW - zT + 2]);
        hull() {
          translate([Bo[0], Bo[2], zT - 2]) cube([Bo[1] - Bo[0], Bo[3] - Bo[2], bh + 2]);
          for (x = [xr0, Bo[1] - 0.01]) translate([x, Bo[2], zT - 2]) cube([0.01, Bo[3] - Bo[2], rund(x) + 0.4 - zT + 2]);
        }
      }
      if (details) {
        color([0.30, 0.27, 0.24]) {
          for (x = [Bo[0] + 1.8:1.8:Bo[1] - 0.5]) if (x < 55.8 || x > 63.2) translate([x - 0.15, Bo[2] - 0.3, zT]) cube([0.3, 0.35, wtop(x + 0.15) - zT - 0.8]);   // the planks, round the window
          for (y = [Bo[2] + 1.8:1.8:Bo[3] - 0.5]) translate([Bo[1] - 0.05, y - 0.15, zT]) cube([0.35, 0.3, rund(Bo[1]) - zT - 0.8]);
        }
        color(TIMBER_D) translate([Bo[1], -18, zT + 0.5]) rotate([0, 0, 90]) translate([-5, -0.4, 0]) cube([10, 0.45, 15]);
      }
      lwin("add", 57, 62, Bo[2], zT + 11, zT + 18);
    }
    // v9: hollow and open into the core through its right wall, so its window glows; the chimney
    // keeps a solid column under it to stand on
    color(INSIDE) pump_void();   // v13: a passage from the core to its window; the rest is solid
    lwin("cut", 57, 62, Bo[2], zT + 11, zT + 18);
  }
  lwin("bars", 57, 62, Bo[2], zT + 11, zT + 18);
  color(RUST) {   // v13: 2 mm eaves; the right one level, so its edge isn't the lowest point
    hull() { translate([xr0, Bo[2] - 2, rund(xr0)]) cube([0.01, Bo[3] - Bo[2] + 3, 1.2]); translate([Bo[1], Bo[2] - 2, rund(Bo[1])]) cube([0.01, Bo[3] - Bo[2] + 3, 1.2]); }
    translate([Bo[1] - 0.01, Bo[2] - 2, rund(Bo[1])]) cube([2.01, Bo[3] - Bo[2] + 3, 1.2]);
  }
  // the wooden water tank on legs, piped down into the boiler house
  wt = [71, -22]; zt0 = zT + bh + 2;
  color(TIMBER_D) for (sx = [-1, 1], sy = [-1, 1]) translate([wt[0] + sx * 3.2 - 1, wt[1] + sy * 3.2 - 1, zt0 - 2]) cube([2, 2, 6.5]);
  color(TUB) translate([wt[0], wt[1], zt0 + 4]) cylinder(d = 10, h = 9, $fn = 32);
  color(DARK) for (z = [1.4, 7]) translate([wt[0], wt[1], zt0 + 4 + z]) cylinder(d = 10.4, h = 0.6, $fn = 32);
  color(TIMBER) translate([wt[0], wt[1], zt0 + 13]) cylinder(d1 = 10.6, d2 = 2, h = 2.4, $fn = 32);
  pipe([[wt[0] - 4.4, wt[1], zt0 + 6], [wt[0] - 8.5, wt[1], zt0 + 6], [wt[0] - 8.5, wt[1], zt0 - 1.5]], 3.5, IRON, [0.6, -1]);
  boot(wt[0] - 8.5, wt[1], 3.5);
  if ($chim == 0) chim_frame() chimney_body();
  if ($chim != 2) chim_frame() color(DARK) translate([0, 0, hs_c - 3.6]) cylinder(d1 = 15, d2 = 12.8, h = 3.6, $fn = 32);   // v13: square to the chimney
}

// the porch, at the front: railing, a bench, a pump that sends hot water into the core, a door
// into the core, lanterns under the jutting floor
pc = [66, -41];                        // the pump on the porch
xin = [47.5, 53.5];                    // two pipes up the ground floor's front wall, on the plain wall between windows
module porch() {
  if (details) color(RAIL) {
    for (x = [Po[0]:5.9:Po[1]]) translate([x - 0.6, Po[2] + 0.2, zT]) cube([1.2, 1.2, 6]);
    for (y = [Po[2]:5:Po[3]]) translate([Po[1] - 0.6, y - 0.6, zT]) cube([1.2, 1.2, 6]);
    translate([Po[0], Po[2], zT + 5]) cube([Po[1] - Po[0], 1.6, 1.2]);
    translate([Po[1] - 0.8, Po[2], zT + 5]) cube([1.6, Po[3] - Po[2], 1.2]);
  }
  translate([Tb[1], -52, zT - zf]) rotate([0, 0, 90]) door(11, 26);
  if (details) {
    color(TIMBER) { translate([46, -73, zT + 3]) cube([13, 3.6, 0.9]); for (x = [47, 57]) translate([x, -72.6, zT]) cube([1, 2.8, 3]); }
    for (y = [-70, -58, -46]) chochin(W[1] - 2, y, zW - 4.2, 3.6, 5, true);   // under the lowest bracket tier
  }
  // the pump: an iron box with a cap
  color(IRON) translate([pc[0] - 5, pc[1] - 3, zT]) cube([10, 6, 7]);
  color(PIPE_D) translate([pc[0] - 5.5, pc[1] - 3.5, zT + 7]) cube([11, 7, 1.2]);
}

// pipes on the outside. v11 (the user: "less pipes and a cleaner look than risk bad quality"):
// only the ones that clearly join two things, all on the upper level, by the porch: the steam line
// from the pump house into the core, and the pump's two pipes, fed from the pump house and out into
// the core. The water tank's outlet down into the pump house roof is in boiler()
module pipes() {
  py = Bo[2] - 2.3;                    // against the boiler's front wall (v13: touching it, so it prints)
  // the main steam line: out of the boiler's front, up, across the back of the porch, into the core
  pipe([[53, Bo[2] + 1, zT + 2.5], [53, py, zT + 2.5], [53, py, zT + 19], [Tb[1] - 0.5, py, zT + 19]], 5, PIPE, [1, 0.5]);   // v13: low leg on the floor
  // the pump: fed from the boiler house, sending hot water across the porch into the core
  pipe([[pc[0], pc[1], zT + 7], [pc[0], pc[1], zT + 10.45], [pc[0], Bo[2] + 1, zT + 10.45]], 4.5, PIPE, [1.2, 1]);   // v13: lying on the pump's cap
  pipe([[pc[0] - 4, pc[1] + 0.8, zT + 2.25], [Tb[1] - 0.5, pc[1] + 0.8, zT + 2.25]], 4.5, IRON, [1, 0.5]);   // v13: on the floor, its flange clear of the door
}

// the main roof's surface height at x on its right slope (away from the hip ends), and three
// lattice boxes poking out of that slope toward the right, where the turret used to be (dormer(), in the v9 parts)
function mroof(x) = zR + jr_z((ctr(W)[0] + half(W)[0] + 6 - x) / (half(W)[0] + 6 - 0.4), 19);
// the top tier, rising out of the main roof and straddling its ridge behind the golden gable: a
// crimson base (buried in the roof, so no gap shows where they meet) with a red railing round its
// balcony, a wooden floor of lit ribbon windows set back from the railing, and its own steeper
// green roof with a golden gable to the front
module rail_run(a, b) let(L = norm(b - a), n = max(1, round(L / 4.5))) {
  for (i = [0:n]) translate(a + (b - a) * i / n - [0.6, 0.6, 0]) cube([1.2, 1.2, 4.2]);
  hull() { translate(a + [-0.6, -0.6, 3.3]) cube([1.2, 1.2, 0.9]); translate(b + [-0.6, -0.6, 3.3]) cube([1.2, 1.2, 0.9]); }
}
module toptier() {
  difference() {
    union() { color(BODY) box(P2, zR + 8, zP - zR - 8.8); color(TIMBER_D) box(P2, zP - 1, 1); }   // the base, and the balcony's floor edge
    color(INSIDE) box(inset(T2, TH), zR + 7, zP - zR - 6);
  }
  if (details) color(RAIL) let(c = [[P2[0] + 0.6, P2[2] + 0.6, zP], [P2[1] - 0.6, P2[2] + 0.6, zP], [P2[1] - 0.6, P2[3] - 0.6, zP], [P2[0] + 0.6, P2[3] - 0.6, zP]])
    for (i = [0:3]) rail_run(c[i], c[(i + 1) % 4]);
  lstorey(T2, zP, hT2 - 0.6, TIMBER, 6, 0, [], 9, TIMBER_D, true, true, [], [zP - 1, zR2 - 1.2]);   // its top stays under its roof's sweep
  translate([ctr(T2)[0], ctr(T2)[1], zR2]) rotate([0, 0, 90]) crown(half(T2)[1] + 5, half(T2)[0] + 5, half(T2)[1] - 3, 16, ui = 5);
}

// ---------- life ----------
module carp(len, col) {
  color(col) hull() {
    scale([0.4, 1, 1]) sphere(d = len * 0.21, $fn = 20);
    translate([len * 0.34, 0, -len * 0.03]) sphere(d = len * 0.24, $fn = 20);
    translate([len * 0.86, 0, -len * 0.08]) sphere(d = len * 0.07, $fn = 12);
  }
  color(col) translate([len * 0.86, 0, -len * 0.08]) rotate([90, 0, 0]) linear_extrude(height = 1.2, center = true)
    polygon([[0, 0], [len * 0.2, len * 0.11], [len * 0.15, 0], [len * 0.2, -len * 0.09]]);
  color(LATTICE) { rotate([0, 90, 0]) cylinder(d = len * 0.22, h = 0.6, $fn = 24); for (s = [-1, 1]) translate([len * 0.08, s * len * 0.095, len * 0.02]) sphere(d = len * 0.07, $fn = 12); }
  color(DARK) for (s = [-1, 1]) translate([len * 0.08, s * len * 0.115, len * 0.02]) sphere(d = len * 0.035, $fn = 10);
  color(GOLD) translate([len * 0.34, 0, len * 0.09]) rotate([90, 0, 0]) cylinder(d = len * 0.06, h = len * 0.245, center = true, $fn = 10);
}
module koinobori(x, y, z0) {
  ht = 192 - z0;
  color([0.85, 0.85, 0.82]) translate([x, y, z0]) cylinder(d = 4, h = ht, $fn = 20);
  color(GOLD) translate([x, y, z0 + ht + 1]) sphere(d = 4, $fn = 16);
  for (c = [[ht - 10, 24, [0.15, 0.15, 0.18], 6], [ht - 20, 20, [0.88, 0.22, 0.17], 10], [ht - 29, 16, [0.22, 0.42, 0.85], 14]])
    translate([x + 1.8, y, z0 + c[0]]) rotate([0, c[3], 0]) carp(c[1], c[2]);
}

// ---------- v8: lit from inside ----------
// A Bambu MH001 puck light (59 mm across, 8 mm thick, on a USB cord) lies face-up on a tray in
// the middle of the ground floor; the tray slides in through the back wall on the room side.
// The floors are hollow shells, joined by a light shaft up through the roof band, the crimson
// core, the brackets, the wooden floor and the main roof into the top tier, so one puck lights
// every level. The windows are real openings with frames that bump out from the wall and grid
// bars across them; paper or vellum glued behind them glows.
TH = 1.8;                              // the shells' walls
glow = true;                           // renders: the insides lit warm, as if the puck were on
printable = true;                      // v13: 45-degree undersides under the curled roof corners
$chim = 0;                             // v13: 0 the chimney in place; 1 the building without it (a socket for its peg)
$bh = [];                              // v13: which pieces bathhouse() builds (empty: all)
function has(n) = len($bh) == 0 || len([for (b = $bh) if (b == n) 1]) > 0;
INSIDE = glow ? [1.0, 0.78, 0.44] : [0.24, 0.17, 0.14];   // the colour of the inside surfaces, in renders
paper = false;                         // v9: no paper or glass behind the windows
show_puck = true;                      // show the puck and an air hose (not printed)
puck = [59, 8];                        // the MH001: diameter, thickness
pk = [30, -41];                        // the puck's centre: under the core, clear of the hose holes
tx = [-2.7, 76.7];                     // the back opening's sides (the cut adds 0.3 each side): clear of the back's left window
slot_h = 25.4;                         // the back opening's height: 1", room for two fingers
hole_d = 8;                            // the hose holes: 5/16", for 3/16" airline (about 1/4" outside)
holes = [[8, -8], [17, -8]];           // tight in the tank's corner, just inside both glass panes
function inset(r, t) = [r[0] + t, r[1] - t, r[2] + t, r[3] - t];

// a window as a real opening in a wall TH thick, in the -y face at y: "cut" is the opening,
// "add" the frame bumping out round it, "bars" the grid across it (and the paper behind it)
module lwin(part, u0, u1, y, z0, z1) let(w = u1 - u0, hgt = z1 - z0) {
  if (part == "cut") color(INSIDE) translate([u0, y - 0.5, z0]) cube([w, TH + 1, hgt]);
  if (part == "add") color(TIMBER_D) difference() {
    translate([u0 - 0.9, y - 1.1, z0 - 0.9]) cube([w + 1.8, 1.15, hgt + 1.8]);
    translate([u0, y - 2, z0]) cube([w, 3, hgt]);
  }
  if (part == "bars") {
    nv = max(1, round(w / 3)); nh = max(1, round(hgt / 3.2));
    color(TIMBER_D) {
      if (nv > 1) for (k = [1:nv - 1]) translate([u0 + k * w / nv - 0.4, y - 0.8, z0 - 0.2]) cube([0.8, 1.0, hgt + 0.4]);
      if (nh > 1) for (k = [1:nh - 1]) translate([u0 - 0.2, y - 0.8, z0 + k * hgt / nh - 0.4]) cube([w + 0.4, 1.0, 0.8]);
    }
    if (paper) color(LIT) translate([u0 - 0.5, y + TH, z0 - 0.5]) cube([w + 1, 0.15, hgt + 1]);
  }
}
// one face of a hollow storey, as the -y face of a storey centred on the origin (as face())
module lface(part, L, d, h, n, low, gaps, seed, post_col, ribbon, posts, nowin = [], tdrop = 0) {
  sp = L / n;
  if (part == "add" && posts) color(post_col) for (i = [0:n]) translate([-L / 2 + i * sp - 1.1, -d - 0.7, 0]) cube([2.2, 2.2, h - tdrop]);
  for (i = [0:n - 1]) let(u0 = -L / 2 + i * sp + 1.1, u1 = u0 + sp - 2.2, um = (u0 + u1) / 2)
    if (len([for (g = gaps) if (um > g[0] && um < g[1]) 1]) == 0) {
      if (part == "add" && low > 0 && details) lattice(u0 - (posts ? 0 : 1.1), u1 + (posts ? 0 : 1.1), -d, 1.4, low);
      if ((ribbon || rnd(i * 13 + seed) > 0.35) && len([for (g = nowin) if (um > g[0] && um < g[1]) 1]) == 0)
        lwin(part, u0 + (ribbon ? 0.3 : 1.6), u1 - (ribbon ? 0.3 : 1.6), -d, low + (ribbon ? 1.6 : 4), h - (ribbon ? 3.2 : 6));
    }
}
// a hollow storey with lit windows: walls TH thick, hollow from inner[0] to inner[1]; children()
// are extra cuts
module lstorey(r, z0, h, wall, bay = 10, low = 0, gaps = [], seed = 0, post_col = POST, ribbon = false, posts = true, nowin = [], inner = [0, 0], tdrop = 0) {
  c = ctr(r); hh = half(r);
  module faces(part) for (f = [0:3]) let(L = f % 2 == 0 ? 2 * hh[0] : 2 * hh[1], d = f % 2 == 0 ? hh[1] : hh[0], n = max(2, round(L / bay)))
    translate([c[0], c[1], z0]) rotate([0, 0, 90 * f])
      lface(part, L, d, h, n, low, [for (g = gaps) if (g[0] == f) [g[1], g[2]]], seed + f, post_col, ribbon, posts, [for (g = nowin) if (g[0] == f) [g[1], g[2]]], tdrop);
  difference() {
    union() { color(wall) box(r, z0, h - tdrop); faces("add"); }
    color(INSIDE) box(inset(r, TH), inner[0], inner[1] - inner[0]);
    faces("cut");
    children();
  }
  faces("bars");
}
// the core's small windows as pinholes of light: the same places as stucco_windows()
module stucco_cuts(r, z0, h, seed, skip = []) {
  c = ctr(r); hh = half(r);
  for (f = [0:3]) let(L = f % 2 == 0 ? 2 * hh[0] : 2 * hh[1], d = f % 2 == 0 ? hh[1] : hh[0])
    translate([c[0], c[1], z0]) rotate([0, 0, 90 * f])
      for (row = [0:floor((h - 6) / 9)], col = [0:floor((L - 8) / 7)]) let(k = seed + f * 101 + row * 17 + col, u = -L / 2 + 5 + col * 7 + (row % 2) * 2.5, z = 5 + row * 9)
        if (rnd(k) > 0.45 && u < L / 2 - 4 && len([for (s = skip) if (s[0] == f && u > s[1] && u < s[2] && z > s[3] && z < s[4]) 1]) == 0)
          color(INSIDE) translate([u - 1.1, -d - 0.5, z]) cube([2.2, TH + 1, rnd(k + 9) > 0.5 ? 3.2 : 2.4]);
}
// paper lining a hollow box's inside walls (renders only)
module paper_lining(r, z0, h) if (paper) color(LIT) difference() {
  box(inset(r, TH), z0, h);
  box(inset(r, TH + 0.15), z0 - 1, h + 2);
}

// ---------- v9: open windows, an open back, hose holes, connected pipes ----------
// a pipe through a list of points. v9: real rounded bends with a collar either side, flanges
// along the runs, and a flange plate wherever it comes out of something: fe gives how far each
// end point sits behind the surface it comes out of (-1: no plate, e.g. under a roof boot)
function p_u(v) = v / norm(v);
module p_ring(p, v, dia, h) translate(p) rotate([0, acos(v[2] / norm(v)), atan2(v[1], v[0])]) translate([0, 0, -h / 2]) cylinder(d = dia, h = h, $fn = 20);
// v13: a collar prints only round an upright run, or where its bottom is sunk in the floor
function ring_ok(p, v, dia) = abs(v[2]) > 0.7 || p[2] - dia / 2 < zT + 0.01;
module pipe(pts, d = 4, col = PIPE, fe = [-1, -1]) {
  n = len(pts);
  L = [for (i = [0:n - 2]) norm(pts[i + 1] - pts[i])];
  U = [for (i = [0:n - 2]) p_u(pts[i + 1] - pts[i])];
  // each bend's angle, and how far back along each leg it starts
  A = [for (i = [0:n - 1]) (i == 0 || i == n - 1) ? 0 : acos(max(-1, min(1, U[i - 1] * U[i])))];
  Tn = [for (i = [0:n - 1]) A[i] < 1 ? 0 : min(0.9 * d * tan(A[i] / 2), (i == 1 ? 0.95 : 0.48) * L[i - 1], (i == n - 2 ? 0.95 : 0.48) * L[i])];
  color(col) {
    for (i = [0:n - 2]) hull() { translate(pts[i] + U[i] * Tn[i]) sphere(d = d, $fn = 20); translate(pts[i + 1] - U[i] * Tn[i + 1]) sphere(d = d, $fn = 20); }
    if (n > 2) for (i = [1:n - 2]) if (A[i] >= 1)
      let(R = Tn[i] / tan(A[i] / 2), nn = p_u(U[i] - (U[i] * U[i - 1]) * U[i - 1]), O = pts[i] - U[i - 1] * Tn[i] + nn * R, X = -nn, Y = U[i - 1], Z = cross(X, Y)) {
        if (R > d / 2 + 0.05) multmatrix([[X[0], Y[0], Z[0], O[0]], [X[1], Y[1], Z[1], O[1]], [X[2], Y[2], Z[2], O[2]], [0, 0, 0, 1]])
          rotate_extrude(angle = A[i], $fn = 36) translate([R, 0]) circle(d = d, $fn = 20);
        else translate(pts[i]) sphere(d = d, $fn = 20);
      }
  }
  if (details) color([for (c = col) c * 0.72]) {
    if (n > 2) for (i = [1:n - 2]) if (A[i] >= 1) {      // a collar either side of each bend
      if (ring_ok(pts[i] - U[i - 1] * Tn[i], U[i - 1], d + 1.2)) p_ring(pts[i] - U[i - 1] * Tn[i], U[i - 1], d + 1.2, 1.1);
      if (ring_ok(pts[i] + U[i] * Tn[i], U[i], d + 1.2)) p_ring(pts[i] + U[i] * Tn[i], U[i], d + 1.2, 1.1);
    }
    for (i = [0:n - 2]) let(a = pts[i] + U[i] * (Tn[i] + 2), b = pts[i + 1] - U[i] * (Tn[i + 1] + 2), Lr = norm(b - a), m = floor(Lr / 12))
      if (Lr > 1 && m > 0) for (j = [1:m]) if (ring_ok(a + (b - a) * j / (m + 1), U[i], d + 1.4)) p_ring(a + (b - a) * j / (m + 1), U[i], d + 1.4, 1.2);
    if (fe[0] >= 0) p_ring(pts[0] + U[0] * (fe[0] + 0.4), U[0], d + 3, 1.2);              // flange plates where it comes out of something
    if (fe[1] >= 0) p_ring(pts[n - 1] - U[n - 2] * (fe[1] + 0.4), U[n - 2], d + 3, 1.2);
  }
}

// a wooden lattice box stuck on a wall, as if on the -y face at the origin: w wide, d deep, h tall.
// v9: hollow and open into the room behind it, with real window openings and grid bars on its front
// and sides, no glass. part: "add" the box, its roof and its bracket; "cut" its inside and windows
// (cut out of the wall behind it too); "bars" the grids
module baywin(w, d, h, part = "add") {
  t = 1;                                                     // its walls
  wf = w - 2.8; hf = h - 3; ls = d - 2.2;                     // the front window; the side windows' width
  nv = max(1, round(wf / 3)); nh = max(1, round(hf / 3.2));
  if (part == "add") {
    color(TIMBER) hull() {   // v12: its walls rise to meet its sloping roof, so there's no gap under it from the side
      translate([-w / 2, -d, 0]) cube([w, d, h]);
      translate([-w / 2, -0.01, 0]) cube([w, 0.01, h + 3.6 + 0.3]);
      translate([-w / 2, -d, 0]) cube([w, 0.01, h + 3.6 - 3.9 * d / (d + 2) + 0.3]);
    }
    color(TIMBER_D) {
      hull() { translate([-w / 2, -d, -0.01]) cube([w, d, 0.01]); translate([-w / 2, -0.01, -d * 1.2]) cube([w, 0.01, 0.01]); }
      translate([-w / 2, -d - 0.4, -1.2]) cube([w, d + 0.4, 1.2]);
    }
    color(ROOF) hull() { translate([-w / 2 - 1.6, -0.01, h + 3.6]) cube([w + 3.2, 0.01, 0.8]); translate([-w / 2 - 1.6, -d - 2, h - 0.3]) cube([w + 3.2, 0.01, 0.9]); }
    color(ROOF) hull() { translate([-w / 2 - 1.6, -d - 2, h - 0.3]) cube([w + 3.2, 0.01, 0.9]); translate([-w / 2, -d - 0.01, h - 2.3]) cube([w, 0.01, 3]); }   // v13: a 45-degree soffit under the front eave
    color(ROOF_D) translate([-w / 2 - 1.6, -d - 2.1, h - 0.3]) cube([w + 3.2, 0.5, 0.6]);   // v13: from the roof's underside up
  }
  if (part == "cut") color(INSIDE) {
    translate([-w / 2 + t, -d + t, 1.6]) cube([w - 2 * t, d - t + TH + 0.6, h - 1.6 - t]);   // its inside, on through the wall behind
    translate([-w / 2 + 1.4, -d - 1, 1.6]) cube([wf, t + 1.5, hf]);                          // the front window
    for (s = [-1, 1]) translate([s > 0 ? w / 2 - t - 0.5 : -w / 2 - 1, -d + 1.2, 1.6]) cube([t + 1.5, ls, hf]);   // the side windows
  }
  if (part == "bars") color(TIMBER_D) {
    if (nv > 1) for (k = [1:nv - 1]) translate([-w / 2 + 1.4 + k * wf / nv - 0.4, -d + 0.1, 1.4]) cube([0.8, t - 0.2, hf + 0.4]);
    if (nh > 1) for (k = [1:nh - 1]) {
      translate([-w / 2 + 1.2, -d + 0.1, 1.6 + k * hf / nh - 0.4]) cube([wf + 0.4, t - 0.2, 0.8]);
      for (s = [-1, 1]) translate([s > 0 ? w / 2 - t + 0.1 : -w / 2 + 0.1, -d + 1.0, 1.6 + k * hf / nh - 0.4]) cube([t - 0.2, ls + 0.4, 0.8]);
    }
  }
}

// a lattice window box poking out of the main roof's right slope: its front sits on the slope, its
// back is buried. v9: hollow, open down through the roof into the wooden floor below, its window an
// open grid. part as baywin()
module dormer(yc, xf = 49, w = 11, h = 5.5, part = "add") {
  z0 = mroof(xf); xb = xf - 20;                       // the front sits on the slope; the back is buried
  zu0 = mroof(xb) - 1.4; zu1 = z0 + h - 0.3;          // its roof's underside at the back and at the front edge
  function u(x) = zu0 + (zu1 - zu0) * (x - xb) / (xf + 2 - xb);
  ww = w - 2.8; wz = [z0 + 0.6, z0 + h - 0.9];        // its window
  if (part == "add") {
    // the box: its walls rise to meet its roof all along, so nothing shows under the roof
    color(TIMBER) hull() {
      translate([xb, yc - w / 2, z0 - 1.5]) cube([xf - xb, w, 0.01]);
      for (x = [xb, xf - 0.01]) translate([x, yc - w / 2, z0 - 1.5]) cube([0.01, w, u(x) + 0.3 - z0 + 1.5]);
    }
    color(TIMBER_D) translate([xf - 0.05, yc - ww / 2 - 0.8, wz[0] - 0.8]) difference() {   // the window's frame
      cube([0.85, ww + 1.6, wz[1] - wz[0] + 1.6]);
      translate([-1, 0.8, 0.8]) cube([3, ww, wz[1] - wz[0]]);
    }
    color(ROOF) hull() {
      translate([xb, yc - w / 2 - 1.4, zu0]) cube([0.01, w + 2.8, 1]);
      translate([xf + 2, yc - w / 2 - 1.4, zu1]) cube([0.01, w + 2.8, 0.9]);
    }
    color(ROOF_D) translate([xf + 1.6, yc - w / 2 - 1.4, zu1]) cube([0.5, w + 2.8, 0.6]);   // v13: from the roof's underside up
  }
  if (part == "cut") color(INSIDE) {
    hull() for (x = [xb + 2, xf - 1]) translate([x, yc - w / 2 + 1, zR - 2]) cube([0.01, w - 2, u(x) - 1 - zR + 2]);   // its inside, open to the floor below
    translate([xf - 1.5, yc - ww / 2, wz[0]]) cube([2.5, ww, wz[1] - wz[0]]);                                        // its window
  }
  if (part == "bars") color(TIMBER_D) for (k = [1:2]) translate([xf - 0.9, yc - ww / 2 + k * ww / 3 - 0.4, wz[0] - 0.2]) cube([0.8, 0.8, wz[1] - wz[0] + 0.4]);
}
module dormers(part = "add") for (yc = [ctr(W)[1] - 23.5, ctr(W)[1], ctr(W)[1] + 23.5]) dormer(yc, part = part);

// the puck light slides straight in on the floor through the back opening, which is left open; a
// low curb steers it in and stops it under the core
module puck_seat() color(TIMBER_D) translate([0, 0, zf - 0.01]) linear_extrude(height = 1.6) difference() {
  union() { translate(pk) circle(r = puck[0] / 2 + 2.1, $fn = 72); translate([pk[0] - puck[0] / 2 - 2.1, pk[1]]) square([puck[0] + 4.2, G[3] - TH - pk[1]]); }
  union() { translate(pk) circle(r = puck[0] / 2 + 0.9, $fn = 72); translate([pk[0] - puck[0] / 2 - 0.9, pk[1]]) square([puck[0] + 1.8, G[3] - pk[1] + 1]); }
}
// the hose holes, straight up through the clamp and the floor, tight in the tank's corner just inside
// both glass panes; flared where they enter the clamp from below, chamfered at the floor
module hose_holes() color(DARK) for (h = holes) translate([h[0], h[1], 0]) {
  translate([0, 0, -13]) cylinder(d = hole_d, h = zf + 13.5, $fn = 32);
  translate([0, 0, zf - 0.8]) cylinder(d1 = hole_d, d2 = hole_d + 1.6, h = 0.81, $fn = 32);
}
// an air hose in the corner hole (renders only): up out of the water tight in the glass corner,
// through the floor, and out the back opening
module hoses() color([0.88, 0.92, 0.88]) let(x = holes[0][0] - 0.5, y = holes[0][1] + 0.5,
    p = [[x, y, -70], [x, y, zf + 3], [x, y + 3, zf + 8.5], [x, y + 9, zf + 10.5], [x, 6, zf + 9.5], [x, G[3] - TH - 2, zf + 5.5], [x, G[3] + 6, zf + 3.5], [x, G[3] + 16, zf - 2]])
  for (i = [0:len(p) - 2]) hull() { translate(p[i]) sphere(d = 6.3, $fn = 16); translate(p[i + 1]) sphere(d = 6.3, $fn = 16); }
module puck_light() {
  color([0.92, 0.92, 0.9]) translate([pk[0], pk[1], zf + 0.05]) cylinder(d = puck[0], h = puck[1] - 0.65, $fn = 72);
  color([1.0, 0.93, 0.6]) translate([pk[0], pk[1], zf + puck[1] - 0.6]) cylinder(d = puck[0] - 6, h = 0.6, $fn = 72);
  color(DARK) hull() { translate([pk[0], pk[1] + puck[0] / 2 - 2, zf + 4]) sphere(d = 3, $fn = 12); translate([pk[0], G[3] + 6, zf + 1.6]) sphere(d = 3, $fn = 12); }   // its cord, out the back opening
}

// v13: the puck slides in on the floor between the arms of a U-shaped guide, its own part, which plugs
// 1 mm into a groove in the floor (a sunken track would print as a 2 3/8" ceiling, the base upside down)
module guide2d() difference() {
  union() { translate(pk) circle(r = puck[0] / 2 + 2.9, $fn = 96); translate([pk[0] - puck[0] / 2 - 2.9, pk[1]]) square([puck[0] + 5.8, G[3] - TH - pk[1]]); }
  union() { translate(pk) circle(r = puck[0] / 2 + 0.9, $fn = 96); translate([pk[0] - puck[0] / 2 - 0.9, pk[1]]) square([puck[0] + 1.8, G[3] - pk[1] + 1]); }
}
module puck_guide() color(TIMBER_D) translate([0, 0, zf - 1]) {
  translate([0, 0, 0.25]) linear_extrude(height = 2.35) guide2d();
  linear_extrude(height = 0.26) offset(delta = -0.25) guide2d();   // its foot stepped in (the first layer squashes out)
}
module puck_groove() color(DARK) {
  translate([0, 0, zf - 1.2]) linear_extrude(height = 2.2) offset(delta = 0.15) guide2d();
  translate([0, 0, zf - 0.25]) linear_extrude(height = 1.25) offset(delta = 0.4) guide2d();   // its mouth stepped wider (the first layer squashes out)
}
// v13: the walks' bow-tie keys: a half pocket at each joint, at the walk's level (3 mm deep, 0.15 mm play),
// open up through the floor so the key drops in before the ground floor goes on
key_pts = [[-6, -3.5], [0, -1.75], [6, -3.5], [6, 3.5], [0, 1.75], [-6, 3.5]];
module key_pockets() color(DARK) for (j = [[arm, 0, 0], [0, -arm, 90]]) translate([j[0], j[1], z_top - 3])
  rotate([0, 0, j[2]]) linear_extrude(height = zf - z_top + 4) offset(delta = 0.15) polygon(key_pts);

module bathhouse() {
  if (has("base")) difference() { union() { clamp(); foundation(); } hose_holes(); key_pockets(); puck_groove(); }
  if (has("guide")) puck_guide();
  if (has("ground")) ground();
  if (has("tower")) tower();
  if (has("toptier")) toptier();
  if (has("boiler")) difference() { boiler(); if ($chim == 1) chim_socket(); }
  if (has("porch")) porch();
  if (has("pipes")) difference() {   // v11: the pipes' ends stop at the inside faces of the core and the pump house
    pipes();
    box(inset(Tb, TH), zT - 1, zW - zT);
    pump_void();
  }
  if (show_puck) { puck_light(); hoses(); }
}

// ---------- scenes ----------
module tank(len, dep) color(GLASS) {
  translate([-4, -4, -300]) cube([len, 8, 300]);
  translate([-4, -dep, -300]) cube([8, dep + 4, 300]);
}
if (scene == "markers") color([1, 0, 1]) for (p = mk_pts) translate(p) sphere(d = 3);
else if (scene == "mass") bathhouse();
else if (scene == "none") { }
else if (scene == "section") difference() { bathhouse(); color([0.36, 0.34, 0.33]) translate([-60, -200, -60]) cube([260, 200 + cut, 320]); }
// the clipping check: where one lantern's body (not its hook) runs into anything else
else if (scene == "lclip") intersection() {
  translate([li[0], li[1], 0]) {
    translate([0, 0, li[2] - 2.4 - li[4] / 2]) scale([1, 1, li[4] / li[3]]) sphere(d = li[3] * 0.97, $fn = 24);
    translate([0, 0, li[2] - 2.4 - li[4] - 0.55]) cylinder(d = li[3] * 0.6, h = li[4] + 0.6, $fn = 16);
  }
  bathhouse($lmode = 2);
}
else if (scene == "elev") { bathhouse(); color(WOOD) translate([arm + seg / 2, 0, 0]) import(str(P, "seg.stl")); if (fisher_on) translate([98, 2, z_top]) fisher(false); }
else if (scene == "corner" || scene == "joint" || scene == "plan") {
  bathhouse();
  color(WOOD) translate([arm + seg / 2, 0, 0]) import(str(P, "seg.stl"));
  if (scene == "joint" || scene == "plan") color(GHOST) translate([0, -arm - seg / 2, 0]) rotate([0, 0, 90]) import(str(P, "seg.stl"));
  if (fisher_on && scene != "plan") translate([98, 2, z_top]) fisher(false);
  if (scene != "plan") {
    tank(arm + seg + 70, 280);
    color(WATER) translate([4, -276, -300]) cube([arm + seg + 62, 272, 275]);
  }
}
else if (scene == "tank") {
  // the whole tank, the walk along the back glass: bathhouse, two straights, the locked
  // centre piece (landing toward the water, balcony toward the room), two straights, a corner
  translate([0, yb, 0]) bathhouse();
  color(WOOD) for (x = [arm + seg / 2, arm + 3 * seg / 2, xc + Lc / 2 + seg / 2, xc + Lc / 2 + 3 * seg / 2]) translate([x, yb, 0]) import(str(P, "seg.stl"));
  color(WOOD) translate([xr, yb, 0]) rotate([0, 0, 180]) import(str(P, "bw_x_c.stl"));
  translate([xc, yb, 0]) rotate([0, 0, 180]) {
    color(WOOD) import(str(P, "f_bare.stl"));
    platform(50.8);
    mirror([0, 1, 0]) platform(50.8, true);   // the locked centre piece: landing, balcony, four lanterns
    if (fisher_on) translate([-44, 59.8, z_top]) fisher();
  }
  if (fisher_on) translate([98, yb + 2, z_top]) fisher(false);
  color(GLASS) {
    translate([-4, -4, -300]) cube([T, 8, 300]);
    translate([-4, yb - 4, -300]) cube([T, 8, 300]);
    translate([-4, -4, -300]) cube([8, D, 300]);
    translate([xr - 4, -4, -300]) cube([8, D, 300]);
  }
  color(WATER) translate([4, 4, -300]) cube([xr - 8, yb - 8, 275]);
}
