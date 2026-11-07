// The bathhouse end piece (v13), split into seven parts that print with no supports and plug together
// with no glue. Each storey's walls carry a tongue (the inner 1 mm of the 1.8 mm wall, 1.2 mm tall) that
// plugs into a groove in the part above or below; the chimney pegs into a socket. They stack:
//   base (clamp and stone floor)  <- ground floor walls  <- middle (roof band, core, wooden floor, pump
//   house, porch)  <- main roof (with the top tier's walls)  <- top roof;  chimney into the pump house;
//   the puck's guide into a groove in the floor.
// part: base, guide, ground, middle, roof, top, chimney (each in its print orientation), fit (the joint test),
// assembly (all in place), exploded.
include <bathhouse.scad>
scene = "none";
show_puck = false;
part = "assembly";
fit_c = 0.10;                 // play each side of a tongue in its groove
tg = [1.0, 1.2];              // the tongues: width, height
ch = 0.25;                    // the chamfer on a tongue's tip and a groove's mouth (no elephant's foot binding)
zJ = [zf, z0r - 1.2, zR - 1.2, zR2 - 1.2];   // the joints: the floor, the roof band's underside, the main roof's, the top roof's
gapG = [tx[0] - 0.6, tx[1] + 0.6];            // the back opening: no wall there at the floor, so no tongue

function sq(r) = [[r[0], r[2]], [r[1], r[2]], [r[1], r[3]], [r[0], r[3]]];
// a ring's four sides as rectangles [x0, x1, y0, y1]: between outer O and inner I
function bars(O, I) = [[O[0], O[1], O[2], I[2]], [O[0], O[1], I[3], O[3]], [O[0], I[0], O[2], O[3]], [I[1], O[1], O[2], O[3]]];
// (each part stops 0.003 mm short of the part above, so the next roof's underside doesn't come along as a
// sheet of no thickness)
module slab(z0, z1) translate([-80, -140, z0]) cube([260, 260, z1 - z0]);
// a bar rising h from z0 (dir 1) or falling (dir -1), its far end narrowed by c on its two long sides
module cbar(b, z0, h, c, dir) let(lx = (b[1] - b[0]) > (b[3] - b[2]), nb = lx ? [b[0], b[1], b[2] + c, b[3] - c] : [b[0] + c, b[1] - c, b[2], b[3]]) hull() {
  translate([b[0], b[2], dir > 0 ? z0 : z0 - h + c]) cube([b[1] - b[0], b[3] - b[2], h - c]);
  translate([nb[0], nb[2], dir > 0 ? z0 + h - 0.01 : z0 - h]) cube([nb[1] - nb[0], nb[3] - nb[2], 0.01]);
}
// the tongue of storey r at the joint z: up into the part above (dir 1) or down into the part below; the
// inner tg[0] of the wall with its tip chamfered, or (full) the whole wall, for the ground floor's top,
// which prints standing on it
module tongue(r, z, dir, gap = [], full = false) difference() {
  for (b = bars(inset(r, full ? 0 : TH - tg[0]), inset(r, TH))) cbar(b, dir > 0 ? z - 0.01 : z + 0.01, tg[1] + 0.01, full ? 0 : ch, dir);
  if (len(gap) > 0) translate([gap[0], r[3] - TH - 1, z - 5]) cube([gap[1] - gap[0], TH + 2, 10]);
}
// the groove for it: going up from z into the part above (dir 1) or down into the part below, its mouth
// widened by ch; deep: 0.3 deeper than the tongue (the part rests on the wall's outer edge), or as deep as
// it (the part rests on the wall's top)
module groove(r, z, dir, gap = [], c = fit_c, w = tg[0], deep = 0.3) difference() {
  union() {
    for (b = bars(inset(r, TH - w - c), inset(r, TH + c))) {
      translate([b[0], b[2], dir > 0 ? z - 0.01 : z - tg[1] - deep]) cube([b[1] - b[0], b[3] - b[2], tg[1] + deep + 0.01]);
      hull() {
        translate([b[0] - ch, b[2] - ch, z - 0.01]) cube([b[1] - b[0] + 2 * ch, b[3] - b[2] + 2 * ch, 0.02]);
        translate([b[0], b[2], dir > 0 ? z + ch : z - ch]) cube([b[1] - b[0], b[3] - b[2], 0.01]);
      }
    }
  }
  if (len(gap) > 0) translate([gap[0] + 0.3, r[3] - TH - 1.5, z - 5]) cube([gap[1] - gap[0] - 0.6, TH + 3, 10]);
}

module p_base() difference() {
  intersection() { bathhouse($bh = ["base"]); slab(-20, zJ[0]); }
  groove(G, zJ[0], -1, gapG);
}
module p_ground() {
  intersection() { bathhouse($bh = ["ground"]); slab(zJ[0], zJ[1] - 0.003); }
  tongue(G, zJ[0], -1, gapG);
  tongue(G, zJ[1], 1, full = true);   // its whole wall: it prints standing on it
}
module p_middle() difference() {
  union() {
    intersection() { bathhouse($bh = ["ground", "tower", "boiler", "porch", "pipes"], $chim = 1); slab(zJ[1], zJ[2] - 0.003); }
    tongue(W, zJ[2], 1);
  }
  groove(G, zJ[1], 1, w = TH, deep = 0);   // it rests on the walls' tops, the seam hidden in the groove
}
module p_roof() difference() {
  union() {
    intersection() { bathhouse($bh = ["tower", "toptier"]); slab(zJ[2], zJ[3] - 0.003); }
    tongue(T2, zJ[3], 1);
  }
  groove(W, zJ[2], 1);
}
module p_guide() bathhouse($bh = ["guide"]);
module p_top() difference() {
  intersection() { bathhouse($bh = ["toptier"]); slab(zJ[3], 260); }
  groove(T2, zJ[3], 1);
}

// the joint test: four corners of wall (a 1 mm tongue on top, printed tip up as on the ground floor's foot,
// the wooden floor and the top tier; their bottom is the whole wall, printed on the plate as the ground
// floor's top) and four blocks with both grooves at 0.05, 0.10, 0.15 and 0.20 mm play, mouths down
fits = [0.05, 0.10, 0.15, 0.20];
module fit_test() {
  for (i = [0:3]) translate([i * 24, 0, 0]) {
    difference() {
      translate([-5, -5, 0]) cube([20, 20, 3]);
      groove([0, 40, 0, 40], 0, 1, c = fits[i]);                                    // the tongue's
      groove([3.6, 43.6, 3.6, 43.6], 0, 1, c = fits[i], w = TH, deep = 0);          // the whole wall's
      for (k = [0:i]) translate([12 - k * 2.5, 12, 2.6]) cylinder(d = 1.6, h = 1, $fn = 12);   // dots: 1 to 4
    }
    translate([0, 22, 0]) {
      linear_extrude(height = 6) difference() { square([14, 14]); translate([TH, TH]) square([20, 20]); }
      intersection() { tongue([0, 40, 0, 40], 6, 1); translate([0, 0, 3]) cube([14, 14, 6]); }
      for (k = [0:i]) translate([11 - k * 2.5, 0.01, 3]) rotate([90, 0, 0]) cylinder(d = 1.6, h = 0.4, $fn = 12);
    }
  }
}

if (part == "base") translate([0, 0, zJ[0]]) rotate([180, 0, 0]) p_base();           // upside down, on its floor
else if (part == "ground") translate([0, 0, zJ[1] + tg[1]]) rotate([180, 0, 0]) p_ground();   // upside down, on its top
else if (part == "middle") translate([0, 0, -zJ[1]]) p_middle();
else if (part == "roof") translate([0, 0, -zJ[2]]) p_roof();
else if (part == "top") translate([0, 0, -zJ[3]]) p_top();
else if (part == "guide") translate([0, 0, 1 - zf]) p_guide();                        // flat
else if (part == "chimney_bare") translate([0, 0, 120]) rotate([180, 0, 0]) chimney_part();   // the same, for the checks
else if (part == "chimney") {   // upside down on its cap (on its peg it would be a 4 3/8" column on a 5/16" foot), with
                                // its own brim: a thin ring held by four tabs, snapped off after printing
  translate([0, 0, 120]) rotate([180, 0, 0]) chimney_part();
  linear_extrude(height = 0.4) {
    difference() { circle(r = 15, $fn = 64); circle(r = 10.2 / 2 + 0.3, $fn = 64); }
    for (a = [45:90:315]) rotate(a) translate([4.6, -0.4]) square([1.2, 0.8]);
  }
}
else if (part == "fit") fit_test();
else if (part == "assembly" || part == "exploded") {
  e = part == "exploded" ? 1 : 0;
  p_base();
  translate([0, 0, 12 * e]) p_guide();
  translate([0, 0, 25 * e]) p_ground();
  translate([0, 0, 50 * e]) p_middle();
  translate([0, 0, 75 * e]) p_roof();
  translate([0, 0, 100 * e]) p_top();
  translate([0, 0, 62 * e]) chim_frame() chimney_part();
}
