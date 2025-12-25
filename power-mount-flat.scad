$fn = 128;
material_thickness = 2;
screw_hole_dia = 4;

module draw_power_mount() {
    power_height = 60-material_thickness;
    power_width = 17;
    power_screw_distance = 50;
    screw_mount_size = 60;
    power_depth = 15;
    jack_screw_dia = 8;

    cyl_height_offset = 3;
    difference() {
        union() {
            // outer screw mounts
            translate([screw_mount_size/-2, screw_mount_size/-2]) cube([screw_mount_size, screw_mount_size, material_thickness]);
            // opening
            //translate([(power_height+material_thickness)/-2, (power_width+material_thickness)/-2]) cube([power_height + material_thickness, power_width + material_thickness, power_depth+material_thickness+0.1]);
        }
        // jack screw
        # translate([0, 0, -0.01]) rotate([0, 0, 0]) cylinder(h=material_thickness+0.1, d=jack_screw_dia);
        // opening hole
        translate([(screw_mount_size+20)/-2, (screw_mount_size+20)/-2, -50-0.05]) cube([screw_mount_size+20, screw_mount_size+20, 50+0.1]);
        // screw holes
        for (rot =[0:90:360]) {
            rotate([0, 0, rot]) translate([power_screw_distance/2, power_screw_distance/2, -0.05]) cylinder(h=material_thickness+0.1, d=screw_hole_dia);
        }
    }
}

draw_power_mount();