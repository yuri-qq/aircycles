$fn=128;


fan_dia = 120 - 7; // 7mm less so we don't expose edges too much
screw_hole_distance = 105;
screw_hole_dia = 4.5;
material_thickness = 1.5;

fan_count = 3;

side_length = 498+2+5;

extra_border = 5;
in_between_gap = 0.5;

shroud_height = material_thickness;

module draw_circle_outlines(dia, height, thickness) {
    difference() {
        cylinder(h=height, d=dia+thickness);
        translate([0, 0, -0.05]) cylinder(h=height+0.1, d=dia);
    }
}

module draw_fan_holes() {
    difference() {
    union() {
        for (alt = [0:90:359]) {
            union() {
                // screw hole attachment things
                hull() {
                    rotate([0, 0, alt]) translate([screw_hole_distance/2, screw_hole_distance/2]) cylinder(h=material_thickness, d=screw_hole_dia+3);
                    cylinder(h=material_thickness, d=40);
                }
            }
        }
    }
    union() {
        translate([0, 0, -0.05]) cylinder(h=shroud_height, d1=fan_dia);
        for (rot =[0:90:360]) {
            rotate([0, 0, rot]) translate([screw_hole_distance/2, screw_hole_distance/2, -0.05]) cylinder(h=material_thickness+10, d=screw_hole_dia);
        }
    }
    }
}

fan_gap = (side_length - (fan_count * fan_dia)) / fan_count;

intersection() {
    // shroud
    union() {
        cylinder(h=shroud_height, d=fan_dia+extra_border);
        cylinder(h=shroud_height+4, d=fan_dia);
        // bottom part
        draw_fan_holes();
    }
}