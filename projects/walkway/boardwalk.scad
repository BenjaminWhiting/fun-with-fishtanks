// Japanese garden boardwalk that clips onto the top edge of the tank glass, after the
// boardwalks of Japanese gardens: deck boards running along the walk with staggered
// joints, and a simple railing of square posts and two round rails.
//
// Scale 1:48 (O scale): the walk is about 5 ft wide and the railing about 3 ft high,
// so fishermen for it should stand about 1 1/2 in tall.
//
// Two kinds of part, so every piece prints without supports:
//  - the deck segment, upright as modelled (slot down), on a 45-degree flare;
//  - the railing panels, flat on their inner face, so the long rails need no bridging.
//    Each post ends in a square peg that presses into a socket in the deck. Both sides'
//    panels are the same part, turned round.
// Set segments end to end along the rim: each clamps on by itself, and the board ends at
// each joint look like any other joint. Every joint has a post on it: each railing panel
// ends in a half post, and the two halves meet to make one post, so the rails never end
// in mid-air.
// A chigiri (bow-tie key) drops into the two half pockets across each joint, locking
// the segments together with their decks flush.
// The corner piece clamps both panes at a tank corner (any of the four); its arms end
// with the same post spacing and boards as a straight segment, so segments carry on
// from it.
//
// Axes: X along the glass, Y through the glass, Z up. Z = 0 is the top edge of the glass.

/* [Fit: the riser's clamp, which fits the tank] */
slot = 8.4;          // glass slot; the gauge's best fit on the tank glass
wall = 4;            // clamp wall
teeth = 12;          // how far the clamp reaches down the glass

/* [Deck] */
seg_len = 152.4;     // 6 in per segment
deck_w = 32;         // walkway width across the glass (about 5 ft at 1:48)
neck = 2;            // clamp body above the glass before the flare
deck_t = 3.5;        // deck thickness
boards = 10;         // deck boards across the walk (about 6 in wide each at 1:48)
board_gap = 0.5;     // gap between boards...
gap_depth = 0.6;     // ...and how deep it is
seed = 7;            // change for a different pattern of joints and low boards

/* [Railing] */
railing = "both";    // [both, front, back, none]
post = 3.2;          // square post
post_h = 18;         // post height above the deck (about 3 ft at 1:48)
bays = 4;            // post spaces per segment; a post stands on each joint, split between the segments
rail_d = 1.6;        // rail thickness (flat on the walk side, round on the outside)
rail_z = [7, 15];    // rail heights above the deck
edge = 0.4;          // posts stand this far in from the deck edge
peg = 2.2;           // square peg under each post...
peg_len = 3.3;       // ...how far it goes into the deck...
peg_play = 0.15;     // ...and the socket's play each side

/* [Joints: chigiri (bow-tie) keys] */
key_len = 12;        // across the joint
key_wide = 7;        // width at its ends...
key_waist = 3.5;     // ...and at the joint
key_t = 2.8;         // thickness; it sits 0.2 below the deck in its 3.0 mm pocket
key_depth = 3.0;     // pocket depth
key_play = 0.15;     // pocket play each side

/* [Corner] */
corner_arm = 81.25;  // each arm reaches this far from the glass corner (3 13/16 in from the deck's outer corner)
corner_bays_out = 3; // post spaces from the outside corner post to the arm's joint post...
corner_bays_in = 2;  // ...and from the inside corner post
corner_room = 1.3;   // extra room at the glass's outer corner for a silicone seam or overlapping panes
corner_relief = 6;   // the inside corner of the clamp is cut back this far, clear of the silicone bead

/* [Tank run] */
tank_len = 914.4;    // the tank's outside length (36 in); the front run is two corners, whole segments and a filler

/* [Centre piece] */
t_reach = 51.2;      // the landing and the balcony reach this far past the walk: 16 boards, about 2 in
lant_post = 4.2;     // lantern post, square
lant_h = 24;         // the lantern head sits this high above the deck; the post goes 2.2 mm up into it
lant_peg = 3.0;      // the lantern post's square peg, in the post's inner corner...
lant_peg_len = 5;    // ...and how deep it goes
rails_lanterns = false;  // lantern posts and heads on the centre rails plate: off until
                         // their pegs are refitted (they came out loose)

/* [Output] */
part = "corner_plate";  // [corner_plate, corner, corner_preview, plate, filler_plate, centre_plate, centre_rails_plate, centre, centre_preview, deck, railing, key, lantern_fit_test, preview]
preview_count = 3;   // segments in the preview

/* [Hidden] */
$fn = 24;
thick = slot + 2 * wall;
flare = (deck_w - thick) / 2;
z_deck = neck + flare;           // underside of the deck at its edges
z_top = z_deck + deck_t;         // deck surface
y_in = deck_w / 2 - edge - post; // inner face of the posts (walk side)
pitch = deck_w / boards;
// the whole posts of a straight segment of length L with n post spaces (the posts on its
// two joints are half posts, made by the panels' ends)
function seg_posts(L = seg_len, n = bays) = [for (k = [1:n - 1]) -L / 2 + k * L / n];
post_x = seg_posts();
seam = 0.1;                      // gap between the two half posts on a joint
half_w = post / 2 - seam / 2;    // each half post's width
half_peg = 1.2;                  // a half post's peg, along the walk
// the front run between the two corners: whole segments and one filler
run = tank_len - (slot - 2 * 0.2) - 2 * corner_arm;
n_whole = floor(run / seg_len);
filler_len = run - n_whole * seg_len;
filler_bays = max(1, round(filler_len / (seg_len / bays)));
sides = railing == "both" ? [-1, 1] : railing == "front" ? [-1] : railing == "back" ? [1] : [];

// cross-section through the glass (2D x = Y, 2D y = Z): clamp, neck, 45-degree flare, deck
module profile(tt = teeth) {
  polygon([
    [-thick / 2, -tt], [thick / 2, -tt], [thick / 2, neck],
    [deck_w / 2, z_deck], [deck_w / 2, z_top], [-deck_w / 2, z_top],
    [-deck_w / 2, z_deck], [-thick / 2, neck],
  ]);
}

// glass slot, with a lead-in chamfer at the mouth
module slot_profile(tt = teeth) {
  m = 1;
  polygon([
    [-slot / 2 - m, -tt - 0.01], [slot / 2 + m, -tt - 0.01],
    [slot / 2, -tt + m], [slot / 2, 0], [-slot / 2, 0], [-slot / 2, -tt + m],
  ]);
}

// Gaps between boards, one staggered butt joint per board, half joints at the segment
// ends, some boards one layer low, and a fascia line along both sides.
module deck_cuts(L = seg_len) {
  r_joint = rands(-L / 2 + 15, L / 2 - 15, boards, seed);
  r_low = rands(0, 1, boards, seed + 1);
  for (k = [1:boards - 1]) translate([-L, -deck_w / 2 + k * pitch - board_gap / 2, z_top - gap_depth]) cube([2 * L, board_gap, 1]);
  for (k = [0:boards - 1]) {
    y0 = -deck_w / 2 + k * pitch;
    translate([r_joint[k] - board_gap / 2, y0, z_top - gap_depth]) cube([board_gap, pitch, 1]);
    if (r_low[k] < 0.3) translate([-L, y0, z_top - 0.2]) cube([2 * L, pitch, 1]);
  }
  for (s = [-1, 1]) translate([s * L / 2 - board_gap / 4, -deck_w, z_top - gap_depth]) cube([board_gap / 2, 2 * deck_w, 1], center = false);
  for (s = [-1, 1]) translate([-L, s * deck_w / 2 - 0.3, z_deck + 1.2]) cube([2 * L, 0.6, 0.4]);
}

// a chigiri: a bow-tie, narrow where it crosses the joint, so the joint can't open
function key_pts() = [
  [-key_len / 2, -key_wide / 2], [0, -key_waist / 2], [key_len / 2, -key_wide / 2],
  [key_len / 2, key_wide / 2], [0, key_waist / 2], [-key_len / 2, key_wide / 2],
];
module key_part() linear_extrude(height = key_t) polygon(key_pts());

// the key's pocket across a joint at x = xj (each piece takes the half on its side)
module key_pocket(xj) translate([xj, 0, z_top - key_depth]) linear_extrude(height = key_depth + 1) offset(delta = key_play) polygon(key_pts());

// a key in place across the joint at x = xj
module key_installed(xj) translate([xj, 0, z_top - key_depth]) key_part();

// square socket for a railing peg (side s)
module socket(x, s) {
  w = peg + 2 * peg_play;
  y0 = y_in - peg_play;
  translate([x - w / 2, s > 0 ? y0 : -y0 - w, z_top - peg_len - 0.2]) cube([w, w, peg_len + 1]);
}

// the notch socket for a half post's peg, at the joint xj; d = +1 when the panel lies on
// the -x side of the joint, -1 when on the +x side (open past the deck's end)
module half_socket(xj, d) {
  w = peg + 2 * peg_play;
  translate([d > 0 ? xj - half_w - peg_play : xj - 1, y_in - peg_play, z_top - peg_len - 0.2])
    cube([half_w + peg_play + 1, w, peg_len + 1]);
}

// a straight deck of length L with n post spaces a side
module deck(L = seg_len, n = bays) {
  difference() {
    rotate([90, 0, 90]) linear_extrude(height = L, center = true) profile();
    rotate([90, 0, 90]) linear_extrude(height = L + 2, center = true) slot_profile();
    deck_cuts(L);
    for (s = sides) rotate([0, 0, s > 0 ? 0 : 180]) panel_sockets(seg_posts(L, n), -L / 2 + seam / 2, L / 2 - seam / 2, true, true);
    for (s = [-1, 1]) key_pocket(s * L / 2);
  }
}

// a straight segment's railings as installed
module segment_railings(L = seg_len, n = bays)
  for (s = sides) rotate([0, 0, s > 0 ? 0 : 180]) railing_panel(-L / 2 + seam / 2, L / 2 - seam / 2, seg_posts(L, n), true, true);

// a post with its gabled top and its peg; w is its width along the walk, and a half post
// (on a joint) has its ridge at the joint face, side r (+1 the high-x face, -1 the low)
module railing_post(x, w = post, r = 0) {
  translate([x - w / 2, y_in, z_top]) cube([w, post, post_h]);
  translate([x, y_in, z_top + post_h]) rotate([-90, 0, 0]) linear_extrude(height = post)
    polygon(r == 0 ? [[-w / 2, 0], [w / 2, 0], [0, -w / 2]] : [[-w / 2, 0], [w / 2, 0], [r * w / 2, -w]]);
  // a half post's peg stands 0.2 back from the joint face
  pw = r == 0 ? peg : half_peg;
  translate([x - pw / 2 - r * 0.05, y_in, z_top - peg_len]) cube([pw, peg, peg_len + 0.01]);
}

// Railing panel for the back side (+Y), as installed: rails from x0 to x1, a whole post
// at each of xs, and a half post at x0 and/or x1 where the panel ends on a joint. The two
// rails are flat on the walk side and round outside.
module railing_panel(x0 = -seg_len / 2 + seam / 2, x1 = seg_len / 2 - seam / 2, xs = post_x, h0 = true, h1 = true) {
  for (x = xs) railing_post(x);
  if (h0) railing_post(x0 + half_w / 2, half_w, -1);
  if (h1) railing_post(x1 - half_w / 2, half_w, 1);
  for (z = rail_z) hull() {
    translate([x0, y_in, z_top + z]) cube([x1 - x0, rail_d / 2, rail_d]);
    translate([x0, y_in + rail_d / 2, z_top + z + rail_d / 2]) rotate([0, 90, 0]) cylinder(d = rail_d, h = x1 - x0);
  }
}

// the sockets for a back-side panel's posts, in the same frame as the panel
module panel_sockets(xs, x0 = 0, x1 = 0, h0 = false, h1 = false) {
  for (x = xs) socket(x, 1);
  if (h0) half_socket(x0 - seam / 2, -1);
  if (h1) half_socket(x1 + seam / 2, 1);
}

// a railing panel lying on its walk-side face, its length along the bed's Y
module railing_flat(x0 = -seg_len / 2 + seam / 2, x1 = seg_len / 2 - seam / 2, xs = post_x, h0 = true, h1 = true)
  rotate([0, 0, 90]) rotate([90, 0, 0]) translate([0, -y_in, -z_top]) railing_panel(x0, x1, xs, h0, h1);

// ---- corner piece ----
// The deck's outer edges are at -e on both axes and the tank's inside is +X, +Y. Post
// centres stand pc in from the deck edge. Each arm ends on a joint, with half a post on
// it, and its posts are evenly spaced from the corner post to that joint.
e = deck_w / 2;
pc = e - edge - post / 2;
outer_xs = [for (k = [0:corner_bays_out - 1]) -pc + k * (corner_arm + pc) / corner_bays_out];
inner_xs = [for (k = [0:corner_bays_in - 1]) pc + k * (corner_arm - pc) / corner_bays_in];

// Where each of the corner's four railing panels goes, as a back-side panel turned into
// place: 0 outer X arm, 1 inner X arm, 2 outer Y arm, 3 inner Y arm. The corner posts
// belong to the X arm's panels; the Y arm's rails start against them.
module corner_panel(i) {
  if (i == 0) mirror([0, 1, 0]) children();
  else if (i == 1) children();
  else if (i == 2) rotate([0, 0, 90]) children();
  else rotate([0, 0, 90]) mirror([0, 1, 0]) children();
}
// [rail start, rail end, whole posts, half post at start, half post at end] for each
// panel, along its own arm
a_end = corner_arm - seam / 2;
corner_panels = [
  [-pc - post / 2, a_end, outer_xs, false, true],
  [pc - post / 2, a_end, inner_xs, false, true],
  [-pc + post / 2, a_end, [for (x = outer_xs) if (x > -pc) x], false, true],
  [pc + post / 2, a_end, [for (x = inner_xs) if (x > pc) x], false, true],
];

// everything on the far side of the near flare (2D x >= -half width at each height)
module profile_from() {
  polygon([
    [-thick / 2, -teeth], [4 * seg_len, -teeth], [4 * seg_len, z_top], [-deck_w / 2, z_top],
    [-deck_w / 2, z_deck], [-thick / 2, neck],
  ]);
}

// An arm along +X: the straight segment's cross-section, with the flare also turning
// the corner at its outer end, so the two arms meet in a square deck corner on flares
// that stay at 45 degrees.
module corner_arm_body() {
  intersection() {
    translate([-e, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = corner_arm + e) profile();
    rotate([90, 0, 0]) linear_extrude(height = deck_w + 2, center = true) profile_from();
  }
}

// L-shaped glass slot, with room at the glass's outer corner, and the clamp's inside
// corner cut back clear of the silicone bead
module corner_slot() {
  for (r = [0, 90]) rotate([0, 0, r])
    translate([-slot / 2 - corner_room, 0, 0]) rotate([90, 0, 90])
      linear_extrude(height = corner_arm + slot / 2 + corner_room + 1) slot_profile();
  translate([0, 0, -teeth - 1]) linear_extrude(height = teeth + 1)
    polygon([[slot / 2 - 0.01, slot / 2 - 0.01], [slot / 2 + corner_relief, slot / 2 - 0.01], [slot / 2 - 0.01, slot / 2 + corner_relief]]);
}

// Boards along the X arm, mitred on the diagonal, with staggered joints. The Y arm uses
// the same cuts reflected across the diagonal, with its own joints (sd).
module arm_board_cuts(sd) {
  rj = rands(e + 4, corner_arm - 12, boards, sd);
  rl = rands(0, 1, boards, sd + 1);
  for (k = [1:boards - 1]) let(y0 = -e + k * pitch)
    translate([y0, y0 - board_gap / 2, z_top - gap_depth]) cube([corner_arm - y0 + 1, board_gap, 1]);
  for (k = [0:boards - 1]) let(y0 = -e + k * pitch) {
    translate([rj[k] - board_gap / 2, y0, z_top - gap_depth]) cube([board_gap, pitch, 1]);
    if (rl[k] < 0.3) translate([e, y0, z_top - 0.2]) cube([corner_arm, pitch, 1]);
  }
  translate([corner_arm - board_gap / 4, -deck_w, z_top - gap_depth]) cube([board_gap, 2 * deck_w, 1]);
  translate([-e, -e - 0.3, z_deck + 1.2]) cube([corner_arm + e + 1, 0.6, 0.4]);   // fascia lines
  translate([e, e - 0.3, z_deck + 1.2]) cube([corner_arm, 0.6, 0.4]);
}

module corner_deck() {
  difference() {
    union() { corner_arm_body(); rotate([0, 0, 90]) mirror([0, 1, 0]) corner_arm_body(); }
    corner_slot();
    arm_board_cuts(seed);
    mirror([1, -1, 0]) arm_board_cuts(seed + 10);
    translate([-e, -e, z_top - gap_depth]) rotate([0, 0, 45]) translate([0, -board_gap / 2, 0]) cube([deck_w * sqrt(2), board_gap, 1]);
    for (i = [0:3]) let(p = corner_panels[i]) corner_panel(i) panel_sockets(p[2], p[0], p[1], p[3], p[4]);
    for (r = [0, 90]) rotate([0, 0, r]) key_pocket(corner_arm);
  }
}

module corner_railings() for (i = [0:3]) let(p = corner_panels[i]) corner_panel(i) railing_panel(p[0], p[1], p[2], p[3], p[4]);

// Corner panels 0 and 3 are the mirror image of the back-side shape, so they print
// reversed along their length (and shifted back to the same span on the bed); turned
// round, they become the installed shape.
module corner_panel_print(i) let(p = corner_panels[i])
  if (i == 0 || i == 3) translate([0, p[0] + p[1], 0]) railing_flat(-p[1], -p[0], [for (x = p[2]) -x], p[4], p[3]);
  else railing_flat(p[0], p[1], p[2], p[3], p[4]);

// ---- centre piece: a T across the glass in the middle of the front run ----
// In place of the filler: the walk, a landing reaching out over the water (its far edge
// left open for fishing) and a balcony reaching out over the room (railed on all three
// sides), with a lantern on each of the four outer corner posts. The two sides balance,
// so its weight sits over the glass.
// The T prints as one piece, upside down on its walk surface: the flares, the braces and
// the slot then all rise from the plate at 45 degrees or steeper. Its railings print flat
// like the others, the lantern posts flat, and the lantern heads upright.
t_len = filler_len;                              // along the walk
t_far = deck_w / 2 + t_reach;                    // the platforms' far edges, each side of the glass
t_beam = 3;                                      // depth of the beams under the platforms
t_beam_w = 5;                                    // the end and far beams carry the posts' sockets
t_joist_x = 22;
t_joist_w = 4;                                   // joist width (was 2.4)
t_brace_w = 4;                                   // knee braces: width, and the size of their square
t_brace_d = 3;                                   // ends (was 2.4 and 2); printed upside down they climb
                                                 // at 45 degrees on their own, and the thin ones broke off
t_teeth = 25.4;                                  // the T's clamp reaches 1" down the glass (the 1/2" of the
                                                 // other pieces let it rock); the braces still meet it 1/2" down
t_rail_gap = 0.15;                              // rail ends stop this short of a lantern post
// a lantern post's centre at the +x, +y corner, flush with the side and far rail posts
t_lant = [t_len / 2 - seam / 2 - lant_post / 2, t_far - edge - lant_post / 2];
// the side rails (along Y): from the joint post on the walk's rail line to the lantern
// post, with one post between; each platform's front rail (along X) between its lanterns
t_side_posts = [y_in + post / 2, (y_in + post / 2 + t_lant[1]) / 2];
t_side_end = t_lant[1] - lant_post / 2 - t_rail_gap;
t_front_end = t_lant[0] - lant_post / 2 - t_rail_gap;
t_front_posts = [for (k = [1:4]) -t_lant[0] + k * 2 * t_lant[0] / 5];

// A side panel is a back-side panel turned to run along Y, its walk face toward the
// platform's middle; its joint post stands on the walk's rail line, against the next
// segment's half post. The (+x, +y) one is turned into place; the others are mirrored, so
// the panels at (+x, -y) and (-x, +y) are the mirror image of the other two.
module t_side_place(sx, sy) mirror([sx < 0 ? 1 : 0, 0, 0]) mirror([0, sy < 0 ? 1 : 0, 0])
  translate([t_len / 2 - seam / 2 - (y_in + post), 0, 0]) rotate([0, 0, -90]) children();
// a front rail along the far edge of the landing (sy = 1) or the balcony (sy = -1); the
// panel is symmetric, so the same part fits either, turned round
module t_front_place(sy) mirror([0, sy < 0 ? 1 : 0, 0]) translate([0, t_far - edge - (y_in + post), 0]) children();
module t_side_panel() railing_panel(-t_side_end, -y_in, [for (y = t_side_posts) -y], false, false);
module t_front_panel() railing_panel(-t_front_end, t_front_end, t_front_posts, false, false);

// a lantern post, centred on its axis, Z = 0 at the deck: its peg is in the -x, -y corner,
// flush with two faces, so the post prints flat on either of them
module lant_post_part() {
  translate([-lant_post / 2, -lant_post / 2, 0]) cube([lant_post, lant_post, lant_h + 2.2]);
  translate([-lant_post / 2, -lant_post / 2, -lant_peg_len]) cube([lant_peg, lant_peg, lant_peg_len + 0.01]);
}
// at the (sx, sy) corner, its peg toward the platform's inside
module t_lant_place(sx, sy) translate([sx * t_lant[0], sy * t_lant[1], z_top])
  mirror([sx < 0 ? 1 : 0, 0, 0]) mirror([0, sy < 0 ? 1 : 0, 0]) children();
module lant_socket() translate([-lant_post / 2 - peg_play, -lant_post / 2 - peg_play, -lant_peg_len - 0.2])
  cube([lant_peg + 2 * peg_play, lant_peg + 2 * peg_play, lant_peg_len + 1]);

// A six-sided lantern head, as printed (upright) and as it sits on its post: a base with
// the socket the post top fits into, the fire box with a window in each face, a soffit
// at 45 degrees under the eaves, the roof with curled tips, and a jewel (hoju) on top.
module lant_head() difference() {
  union() {
    cylinder(d = 9, h = 2.4, $fn = 6);
    translate([0, 0, 2.3]) difference() {
      cylinder(d = 7.8, h = 7.4, $fn = 6);
      for (a = [30:60:330]) rotate([0, 0, a]) translate([7.8 * cos(30) / 2 - 0.6, -1.3, 1.1]) cube([2, 2.6, 5.2]);
    }
    translate([0, 0, 9.5]) cylinder(d1 = 7.6, d2 = 14.2, h = 3.3, $fn = 6);
    translate([0, 0, 12.8]) cylinder(d = 14.2, h = 0.6, $fn = 6);
    translate([0, 0, 13.4]) cylinder(d1 = 14.2, d2 = 2.4, h = 5.4, $fn = 6);
    for (a = [0:60:300]) rotate([0, 0, a]) translate([6.0, 0, 13.9]) sphere(d = 1.6, $fn = 12);
    translate([0, 0, 18.8]) cylinder(d = 1.8, h = 1.0, $fn = 12);
    translate([0, 0, 19.8]) cylinder(d1 = 1.8, d2 = 3.0, h = 0.6, $fn = 16);
    translate([0, 0, 20.4]) cylinder(d1 = 3.0, d2 = 0, h = 2.4, $fn = 16);
  }
  translate([-lant_post / 2 - peg_play, -lant_post / 2 - peg_play, -1]) cube([lant_post + 2 * peg_play, lant_post + 2 * peg_play, 2.2 + 1]);
}

// Lantern fit test: the 0.15 mm play left the lanterns loose. Post stubs whose pegs grow
// from 3.1 to 3.4 mm (the T's sockets are 3.3), and caps whose post sockets shrink from
// 4.4 to 4.1 mm (the posts are 4.2). Longer stubs and taller caps are tighter.
fit_pegs = [3.1, 3.2, 3.3, 3.4];
fit_caps = [4.4, 4.3, 4.2, 4.1];
// a short lantern post with a peg of width pw, flush in the post's corner like the real one
module fit_stub(pw, len) {
  translate([-lant_post / 2, -lant_post / 2, 0]) cube([lant_post, lant_post, len]);
  translate([-lant_post / 2, -lant_post / 2, -lant_peg_len]) cube([pw, pw, lant_peg_len + 0.01]);
}
// the lantern head's base, h tall, with a centred post socket of width s, 2.2 deep as on the head
module fit_cap(s, h) difference() {
  cylinder(d = 9, h = h, $fn = 6);
  translate([-s / 2, -s / 2, -1]) cube([s, s, 2.2 + 1]);
}

// a platform on the +y side: the slab, the beams and joists under it, and 45-degree knee
// braces from the bottom of the clamp
module t_platform() {
  translate([-t_len / 2, deck_w / 2 - 0.01, z_deck]) cube([t_len, t_reach + 0.01, deck_t]);
  translate([-t_len / 2, t_far - t_beam_w, z_deck - t_beam]) cube([t_len, t_beam_w, t_beam]);
  for (s = [-1, 1]) translate([s > 0 ? t_len / 2 - t_beam_w : -t_len / 2, 12, z_deck - t_beam]) cube([t_beam_w, t_far - 12, t_beam]);
  for (s = [-1, 1]) translate([s * t_joist_x - t_joist_w / 2, 12, z_deck - t_beam]) cube([t_joist_w, t_far - 12 - t_beam_w + 1, t_beam]);
  // each brace starts 1 mm inside the clamp wall and ends 0.5 mm inside its beam, so it
  // joins them solidly instead of meeting them face to face
  b45 = z_deck - t_beam + 0.5 - (-teeth + t_brace_d);
  for (x = [-t_len / 2 + t_beam_w / 2, -t_joist_x, t_joist_x, t_len / 2 - t_beam_w / 2]) hull() {
    translate([x - t_brace_w / 2, thick / 2 - 1, -teeth]) cube([t_brace_w, t_brace_d, t_brace_d]);
    translate([x - t_brace_w / 2, thick / 2 - 1 + b45, -teeth + b45]) cube([t_brace_w, t_brace_d, t_brace_d]);
  }
}

// boards along the walk across the whole T, each with a staggered butt joint, and the
// half joints where the walk meets the next segments
module t_board_cuts() {
  nb = round(2 * t_far / pitch);
  rj = rands(-t_len / 2 + 12, t_len / 2 - 12, nb, seed + 20);
  for (k = [1:nb - 1]) translate([-t_len, -t_far + k * pitch - board_gap / 2, z_top - gap_depth]) cube([2 * t_len, board_gap, 1]);
  for (k = [0:nb - 1]) translate([rj[k] - board_gap / 2, -t_far + k * pitch, z_top - gap_depth]) cube([board_gap, pitch, 1]);
  for (s = [-1, 1]) translate([s * t_len / 2 - board_gap / 4, -deck_w / 2, z_top - gap_depth]) cube([board_gap / 2, deck_w, 1]);
}

module centre_t() difference() {
  union() {
    rotate([90, 0, 90]) linear_extrude(height = t_len, center = true) profile(t_teeth);
    for (s = [0, 1]) mirror([0, s, 0]) t_platform();
  }
  rotate([90, 0, 90]) linear_extrude(height = t_len + 2, center = true) slot_profile(t_teeth);
  t_board_cuts();
  for (s = [-1, 1]) key_pocket(s * t_len / 2);
  for (sx = [-1, 1], sy = [-1, 1]) {
    t_side_place(sx, sy) for (y = t_side_posts) socket(-y, 1);
    t_lant_place(sx, sy) lant_socket();
  }
  for (sy = [-1, 1]) t_front_place(sy) for (x = t_front_posts) socket(x, 1);
}

module centre_railings() {
  for (sx = [-1, 1], sy = [-1, 1]) t_side_place(sx, sy) t_side_panel();
  for (sy = [-1, 1]) t_front_place(sy) t_front_panel();
}
module centre_lanterns() for (sx = [-1, 1], sy = [-1, 1]) {
  t_lant_place(sx, sy) lant_post_part();
  translate([sx * t_lant[0], sy * t_lant[1], z_top + lant_h]) lant_head();
}

if (part == "corner") translate([0, 0, teeth]) corner_deck();
else if (part == "key") key_part();
else if (part == "corner_preview") {
  // the corner piece with a straight segment carrying on along each pane
  corner_deck();
  corner_railings();
  for (r = [0, 90]) rotate([0, 0, r]) {
    translate([corner_arm + seg_len / 2, 0, 0]) { deck(); segment_railings(); }
    key_installed(corner_arm);
  }
}
else if (part == "corner_plate") {
  // the corner deck upright on its clamp, two railing panels flat beside each arm
  w = post_h + post / 2 + peg_len;
  translate([0, 0, teeth]) corner_deck();
  for (i = [0:3]) let(p = corner_panels[i], off = corner_arm + 12 + (i % 2) * (w + 6) + peg_len)
    if (i < 2) translate([off, 0, 0]) corner_panel_print(i);
    else translate([p[0] + p[1], off, 0]) rotate([0, 0, 90]) corner_panel_print(i);
  // a key for each arm's joint, in the open corner of the L
  for (j = [0:1]) translate([e + 22, e + 14 + j * 14, 0]) key_part();
}
else if (part == "filler_plate") {
  // the filler that closes the front run, with its railings and a key
  echo(str("filler: ", filler_len, " mm, ", filler_bays, " post spaces, after ", n_whole, " whole segments"));
  translate([0, 0, teeth]) rotate([0, 0, 90]) deck(filler_len, filler_bays);
  for (i = [0:len(sides) - 1]) translate([deck_w / 2 + 8 + i * (post_h + peg_len + post) + i * 6 + peg_len, 0, 0])
    railing_flat(-filler_len / 2 + seam / 2, filler_len / 2 - seam / 2, seg_posts(filler_len, filler_bays));
  translate([-deck_w / 2 - 14, 0, 0]) rotate([0, 0, 90]) key_part();
}
else if (part == "centre") centre_t();
else if (part == "centre_preview") {
  // the T between the two segments either side, with its railings, lanterns and keys
  centre_t(); centre_railings(); centre_lanterns();
  for (s = [-1, 1]) {
    translate([s * (t_len + seg_len) / 2, 0, 0]) { deck(); segment_railings(); }
    key_installed(s * t_len / 2);
  }
}
else if (part == "centre_plate") {
  // the T upside down on its walk surface
  echo(str("centre piece: ", t_len, " x ", 2 * t_far, " mm, lanterns to ", z_top + lant_h + 22.8, " mm above the glass"));
  translate([0, 0, z_top]) rotate([180, 0, 0]) centre_t();
}
else if (part == "centre_rails_plate") {
  // the two front rails (landing and balcony); the side rails, two of each hand, with a
  // lantern head between each pair; the four lantern posts flat (lanterns only with rails_lanterns)
  for (c = [-1, 0]) translate([c * 29, 0, 0]) railing_flat(-t_front_end, t_front_end, t_front_posts, false, false);
  for (c = [1, 2]) translate([c * 29, 0, 0]) {
    railing_flat(-t_side_end, -y_in, [for (y = t_side_posts) -y], false, false);
    railing_flat(y_in, t_side_end, t_side_posts, false, false);
    if (rails_lanterns) translate([8, 0, 0]) lant_head();
  }
  if (rails_lanterns) {
    for (k = [0:3]) translate([88 + k * 9, -16, lant_post / 2]) rotate([0, 0, 90]) rotate([0, -90, 0]) lant_post_part();
    for (j = [0, 1]) translate([101.5, 6 + j * 20, 0]) lant_head();
  }
}
else if (part == "deck") translate([0, 0, teeth]) rotate([0, 0, 90]) deck();
else if (part == "railing") railing_flat();
else if (part == "lantern_fit_test") {
  // the stubs lie flat like the real posts, 8 to 14 mm long; the caps stand upright, 4 to 7 mm tall
  for (k = [0:3]) translate([k * 9, 0, lant_post / 2]) rotate([0, 0, 90]) rotate([0, -90, 0]) fit_stub(fit_pegs[k], 8 + 2 * k);
  for (k = [0:3]) translate([k * 12, 24, 0]) fit_cap(fit_caps[k], 4 + k);
}
else if (part == "preview")
  for (i = [0:preview_count - 1]) translate([(i - (preview_count - 1) / 2) * seg_len, 0, 0]) {
    deck();
    for (s = sides) rotate([0, 0, s > 0 ? 0 : 180]) railing_panel();
  }
else {
  // one 6 in section: the deck upright on its clamp, its railing panels flat, and the
  // key for the joint it adds
  translate([0, 0, teeth]) rotate([0, 0, 90]) deck();
  for (i = [0:len(sides) - 1]) translate([deck_w / 2 + 8 + i * (post_h + peg_len + post) + i * 6 + peg_len, 0, 0]) railing_flat();
  translate([-deck_w / 2 - 14, 0, 0]) rotate([0, 0, 90]) key_part();
}
