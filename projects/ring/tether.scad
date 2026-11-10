// Ring tether: a print-in-place chain with a J-hook at each end, and a clip that sits on the tank's 8 mm glass edge.
// One hook drops into a chain eye under the ring (floater_ring.scad, d_ring), the other into the clip's eye; either
// hook also fits any link, to shorten the chain. Each link is a square-wire loop tipped 45 degrees about the chain,
// alternating left and right, so every surface is a 45-degree slope or a short bridge: no supports. Neighbours keep
// at least 0.5 mm apart, so the chain comes off the plate free.
// part = chain | chain1 (one hook) | clip | plate (the large thin ring with the chain across it and the clip beside it: one plate)
use <floater_ring.scad>

L = 8;           // link length, outside
W = 5.6;         // link width, outside
t = 1.4;         // link wire (square)
P = 4.5;         // pitch, link to link (neighbours in the same plane stay 1 mm apart)
CUT = 0.4;       // flat on the plate under each link
links = 27;      // links between the two hooks: about 6" in all (odd, so both hooks tip the same way)
links1 = 28;     // the one-hook chain: links, then a hook at one end (even, so the hook tips up); also about 6"
th = 1.6;        // hook wire
Rm = 2.4;        // hook curl, centre-line radius: throat 2 * Rm - th = 3.2 mm, over a 1.8 x 2.4 mm eye bar
Ls = 5.5;        // straight shank beyond the hook's eye
// snap hook: the tip and a gate are thin tapered spring fingers; the mouth between them is narrower than an eye's
// 1.8 mm bar, so it takes a little push to snap the bar in (and out). Fingers this thin and long bend about 2%,
// which PETG takes without cracking.
Lt = 3.5;        // tip finger, back and up at 45 degrees from the curl (a flat tip would print as a hanging stub)
TIP_END = 0.9;   // tip finger tapers from the hook wire (1.6) to this
MOUTH = 1.35;    // the gap the bar snaps through
GATE_X = 5.0;    // where the gate finger springs from the shank
GATE_ROOT = 1.2; GATE_END = 0.8;   // gate finger taper
ZC = (W / 2 + t / 2) * sin(45) - CUT;   // height of the chain's axis

module frame(l, w, k) difference() { square([l, w], center = true); square([l - 2 * k, w - 2 * k], center = true); }

module hook2d() {   // the hook's eye (interlocks like a link), a shank along the low side, and a J curling upward
    frame(L, W, th);
    translate([L / 2 - th, -W / 2]) square([Ls + th, th]);
    translate([L / 2 + Ls, -W / 2 + th / 2 + Rm]) intersection() {
        difference() { circle(r = Rm + th / 2, $fn = 64); circle(r = Rm - th / 2, $fn = 64); }
        translate([0, -Rm - th]) square([Rm + th, 2 * Rm + 2 * th]);
    }
    let(cx = L / 2 + Ls, cy = -W / 2 + th / 2 + 2 * Rm) {
        // tip: a tapered spring finger growing out of the curl's top
        hull() { translate([cx, cy]) circle(d = th, $fn = 32); translate([cx - Lt * cos(45), cy + Lt * sin(45)]) circle(d = TIP_END, $fn = 32); }
        // gate: a tapered spring finger from the shank, its end MOUTH short of the tip's underside, 2 mm along the tip
        let(sm = 2.0, hw = th / 2 - (th / 2 - TIP_END / 2) * sm / Lt, pm = [cx - sm * cos(45), cy + sm * sin(45)],
            e = pm - (hw + MOUTH + GATE_END / 2) * [cos(45), sin(45)])
            hull() { translate([GATE_X, -W / 2 + 0.4]) circle(d = GATE_ROOT, $fn = 32); translate(e) circle(d = GATE_END, $fn = 32); }
    }
}

module chain(hooks = 2) intersection() {   // along x, centred on the origin; hooks = 2 (both ends) or 1 (one end, a plain link at the other)
    first = hooks == 2 ? 1 : 0;
    last = hooks == 2 ? links : links1 - 1;
    n = last + 2;    // [hook], links, hook
    translate([-(n - 1) * P / 2, 0, 0]) union() {
        for (i = [first:last]) translate([i * P, 0, ZC]) rotate([i % 2 ? -45 : 45, 0, 0])
            linear_extrude(height = t, center = true) frame(L, W, t);
        // the hooks sit in even slots, tipped +45, so their J curls up
        if (hooks == 2) translate([0, 0, ZC]) rotate([45, 0, 0]) linear_extrude(height = th, center = true) mirror([1, 0]) hook2d();
        translate([(n - 1) * P, 0, ZC]) rotate([45, 0, 0]) linear_extrude(height = th, center = true) hook2d();
    }
    translate([-100, -50, 0]) cube([200, 100, 50]);   // the flats on the plate
}

// glass clip: a saddle over the 8 mm glass (the risers' 8.4 mm slot), printed lying flat so the slot is exact.
// In the tank: the short leg outside the glass, the long leg inside, and an eye at its foot for a hook.
G = 8.4;         // slot
CW = 6;          // clip width, along the glass
CT = 3;          // wall
DEPTH = 10;      // how far the glass goes in
IN = 16;         // inside leg, below the glass top
eye_open = 4.6; eye_bar = 1.8; eye_t = 2.4;   // the eye: a flat ring the J-hook drops into (thin, to fit its throat)
module clip() {
    difference() {
        linear_extrude(height = CW) difference() {
            translate([-G / 2 - CT, -IN]) square([G + 2 * CT, IN + CT]);
            translate([-G / 2 - CT - 1, -IN - 1]) square([CT + 1, IN - DEPTH + 1]);      // the outside leg is shorter
            translate([-G / 2, -DEPTH - 1]) square([G, DEPTH + 1]);                        // the slot
        }
        for (s = [-1, 1]) translate([s * G / 2, -DEPTH, -1]) rotate(45) cube([1.2, 1.2, CW + 2], center = true);   // lead-in at the mouth
    }
    translate([G / 2 + CT / 2, -IN - eye_open / 2 - eye_bar + 0.5, 0]) linear_extrude(height = eye_t) difference() {
        circle(d = eye_open + 2 * eye_bar, $fn = 48); circle(d = eye_open, $fn = 48);
    }
}

part = "plate";
if (part == "chain") chain();
if (part == "chain1") chain(1);   // one hook
if (part == "clip") clip();
if (part == "plate") { d_ring(176, 8); rotate(90) chain(); translate([30, 10, 0]) clip(); }
