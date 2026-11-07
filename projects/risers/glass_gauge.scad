// Glass thickness test gauge for the Hygger light riser.
//
// No calipers needed: push each slot straight down over the top edge of the tank
// glass. The narrowest slot that slides all the way on with light hand pressure,
// without rocking, is the one to use. Put its number into gauge_slot in
// hygger_riser.scad.
//
// Print it with the same filament and settings as the riser, standing as modelled
// (slots down). Its slots then come out the same as the riser's.

slots = [7.6, 7.8, 8.0, 8.2, 8.4, 8.6, 8.8, 9.0];
slot_depth = 12;
tooth = 4;          // same wall thickness as the riser's clamp
spine = 8;
thick = 10;         // length of glass edge each slot grips
mouth = 1;          // lead-in chamfer, same as the riser
label_size = 4.2;
label_depth = 0.6;

height = slot_depth + spine;

// left edge of slot i
function slot_x(i) = i == 0 ? tooth : slot_x(i - 1) + slots[i - 1] + tooth;
length = slot_x(len(slots));

// str(8.0) gives "8", so build the label by hand
function label(w) = let(t = round(w * 10)) str(floor(t / 10), ".", t % 10);

module slot_profile(w) {
  polygon([
    [-mouth, -0.01], [w + mouth, -0.01], [w, mouth],
    [w, slot_depth], [0, slot_depth], [0, mouth],
  ]);
}

difference() {
  cube([length, thick, height]);
  for (i = [0:len(slots) - 1]) {
    translate([slot_x(i), thick + 1, 0]) rotate([90, 0, 0])
      linear_extrude(height = thick + 2) slot_profile(slots[i]);
    translate([slot_x(i) + slots[i] / 2, thick / 2, height - label_depth])
      linear_extrude(height = label_depth + 1)
        text(label(slots[i]), size = label_size, font = "Liberation Sans:style=Bold",
             halign = "center", valign = "center");
  }
}
