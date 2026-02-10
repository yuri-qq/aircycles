$fn=128;

height=30;
height_top_part=8;
dia_top=30;
dia_bottom=20;
screw_hole_dia=4.5;
washer_hole_dia=9.5;

module draw_foot_body(height, height_top_part, d1, d2) {
    radius=2;
    height_bottom_part=height-height_top_part;

    cylinder(height_top_part, dia_top/2, dia_top/2);
    translate([0,0,height_top_part]) {
        minkowski() {
            cylinder(height_bottom_part-radius, dia_top/2-radius, dia_bottom/2-radius);
            sphere(radius);
        }
    }
}

module draw_foot(height, height_top_part, d1, d2, screw_hole_dia=screw_hole_dia, washer_hole_dia=washer_hole_dia) {  
    difference() {
        draw_foot_body(height=height, height_top_part=height_top_part, d1=d1, d2=d2);
        translate([0,0,-0.1]) cylinder(height+0.1, screw_hole_dia/2, screw_hole_dia/2);
        translate([0,0,6]) cylinder(height-6+0.1, washer_hole_dia/2, washer_hole_dia/2);
    }
}

draw_foot(height=height, height_top_part=height_top_part, d1=dia_top, d2=dia_bottom, screw_hole_dia=screw_hole_dia, washer_hole_dia=washer_hole_dia);
