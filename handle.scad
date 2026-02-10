$fn=128;

screw_hole_dia = 4.5;
washer_hole_dia = 10.5;

draw_side_handle = true; // set to false for center handle

module draw_handle(length, height, thickness, angle, screw_hole_dia, washer_hole_dia) {
    clearance = height-thickness;
    radius = thickness/4;

    height_offset = sin(angle)*radius;
    height_with_offset = height-(radius-height_offset);
    length_with_offset = length+2*(radius-(sin(90-angle)*radius));

    lower_offset = sin(angle)*((clearance+2*radius)/sin(90-angle));
    upper_offset = sin(angle)*((height)/sin(90-angle));

    hypotenuse = thickness/sin(90-angle);
    radius_hypotenuse = radius/sin(90-angle);
    length_offset = radius_hypotenuse-(sin(90-angle)*radius_hypotenuse);

    difference() {
        rotate([0,-90,0]) {
            translate([-height_offset,sin(90-angle)*radius,radius]) {
                difference() {
                    minkowski() {
                        linear_extrude(thickness-2*radius) polygon(points=[
                                [0, 0],
                                [0, hypotenuse-2*radius_hypotenuse],

                                [clearance+radius+height_offset, hypotenuse+lower_offset-2*radius_hypotenuse],
                                [clearance+radius+height_offset, length_with_offset-hypotenuse-lower_offset+2*length_offset],

                                [0, length_with_offset-hypotenuse+2*length_offset],
                                [0, length_with_offset-2*radius_hypotenuse+2*length_offset],

                                [height_with_offset, length_with_offset-upper_offset-2*radius_hypotenuse+2*length_offset],
                                [height_with_offset, upper_offset],

                                [0, 0],
                            ]
                        );
                        sphere(radius);
                    }
                    translate([-radius-0.1,-radius,-radius-0.1]) {
                        cube([radius+height_offset+0.1,length_with_offset,thickness+0.2]);
                    }
                }
            }
        }
        translate([-thickness/2,hypotenuse/2,-0.1]) {
            cylinder(height_with_offset+radius+0.1, screw_hole_dia/2, screw_hole_dia/2);
            translate([0,0,4.1]) cylinder(height_with_offset+radius, washer_hole_dia/2, washer_hole_dia/2);
        }
        translate([-thickness/2,length-hypotenuse/2,-0.1]) {
            cylinder(height_with_offset+radius, screw_hole_dia/2, screw_hole_dia/2);
            translate([0,0,4.1]) cylinder(height_with_offset+radius, washer_hole_dia/2, washer_hole_dia/2);
        }
    }
}

if(draw_side_handle) {
    filter_depth = 20 + 2;
    material_thickness = 6;
    fan_dia = 120 - 7;
    middle_area_space = fan_dia + 20;
    overall_depth = filter_depth*2 + material_thickness*2 + middle_area_space;
    
    depth = filter_depth + material_thickness + 10;
    corner_handle_mount_offset = screw_hole_dia/2 + depth/2 - 7;

    handle_length = overall_depth - 2*corner_handle_mount_offset + 18.8225;
    handle_height = 67;
    handle_thickness = 18;
    handle_angle = 17;

    rotate([0,90,0]) draw_handle(length=handle_length, height=handle_height, thickness=handle_thickness, angle=handle_angle, screw_hole_dia=screw_hole_dia, washer_hole_dia=washer_hole_dia);
}
else {
    handle_length = 200;
    handle_height = 72;
    handle_thickness = 18;
    handle_angle = 17;
    
    rotate([0,90,0]) draw_handle(length=handle_length, height=handle_height, thickness=handle_thickness, angle=handle_angle, screw_hole_dia=screw_hole_dia, washer_hole_dia=washer_hole_dia);
}
