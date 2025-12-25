$fn=128;

filter_width = 498+2+5;
filter_height = 498+2+5;
filter_depth = 20+2;
material_thickness = 6;

fan_dia = 120 - 7; // 7mm less so we don't expose edges too much
screw_hole_distance = 105;
screw_hole_dia = 4.5;
corner_screw_hole_dia = 6;
triangle_screw_hole_dia = screw_hole_dia;

middle_area_space = fan_dia + 20; // random number

overall_depth = filter_depth * 2 + material_thickness * 2 + middle_area_space;

primary_fans_count = 3;
secondary_fans_count = 2;

corner_teeth_count = 4;

debug_fan_dia = fan_dia;
debug_fan_height = 26.6;

middle_piece_border_size = 25; // measures 27mm
middle_piece_teeth_size = 20;
middle_piece_teeth_count = 4;  // must be an even number

corner_tri_size = 50;
screw_hole_side_offsets = [10+material_thickness, corner_tri_size-10-material_thickness];
screw_hole_inward_offset = filter_depth + material_thickness + 3;

echo(overall_depth);

triangle_only = false;
draw_triangle_with_feet_holes = true;
draw_triangle_with_alt_holes = true;

// TODO: something for power port

module draw_teeth(even=true) {
    for (i = [0:corner_teeth_count-0.01]) {
        if ((even == true && i % 2 == 0) || (even == false && i % 2 == 1)) {
            translate([i * overall_depth / corner_teeth_count, 0]) cube([overall_depth / corner_teeth_count, material_thickness, material_thickness]);
        }
    }
}

module draw_outer_side(length, teeth_even=true) {
    difference () {
        union() {
            // TODO: length may need to slightly be increased to accommodate parts fitting together neatly
            cube([overall_depth, length, material_thickness]);
            translate([0, -material_thickness]) draw_teeth(even=teeth_even);
            translate([0, length]) draw_teeth(even=teeth_even);
        }

        for (side_alt = [0:1]) {
        // middle piece teeth
        for (i = [0:middle_piece_teeth_count-1]) {
            side_offset_by = side_alt ? overall_depth - filter_depth - material_thickness : filter_depth;
            horiz_offset_by = length/8 + ((length/4) * i);

            translate([side_offset_by, horiz_offset_by - (middle_piece_teeth_size/2), -0.5]) cube([material_thickness, middle_piece_teeth_size, material_thickness + 1]);
        }

        for (horiz_alt = [0:1]) {
        for (hole_side_offset = screw_hole_side_offsets) {
            hole_overall_inward_offset = horiz_alt ? screw_hole_inward_offset + (screw_hole_dia/2) : overall_depth - screw_hole_inward_offset - (screw_hole_dia/2);
            hole_overall_side_offset = side_alt ? hole_side_offset - (screw_hole_dia/2) : length - hole_side_offset + (screw_hole_dia/2) ;
            translate([hole_overall_inward_offset, hole_overall_side_offset, -5]) cylinder(h=material_thickness+10, d=corner_screw_hole_dia);
            }
        }
        }
    }
}

module draw_power_mount() {
    power_height = 40;
    power_width = 40;
    power_screw_distance = 50;
    translate([power_height/-2, power_width/-2, -0.05]) cube([power_height, power_width,material_thickness+0.1]);
    for (rot =[0:90:360]) {
        rotate([0, 0, rot]) translate([power_screw_distance/2, power_screw_distance/2, -0.05]) cylinder(h=material_thickness+0.1, d=screw_hole_dia);
    }
}

module draw_fan_mount() {
    translate([0, 0, -0.05]) cylinder(h=material_thickness+0.1, d=fan_dia);
    for (rot =[0:90:360]) {
        rotate([0, 0, rot]) translate([screw_hole_distance/2, screw_hole_distance/2, -0.05]) cylinder(h=material_thickness+0.1, d=screw_hole_dia);
    }
    #translate([-debug_fan_dia/2, -debug_fan_dia/2, -debug_fan_height]) cube([debug_fan_dia, debug_fan_dia, debug_fan_height]);
}

module draw_fan_side(fan_count, length, teeth_even=true) {
    // fan_gap = (filter_width % fan_dia) / floor(filter_width / fan_dia);
    fan_gap = (length - (fan_count * fan_dia)) / fan_count;

    difference() {
        draw_outer_side(length=length, teeth_even=teeth_even);
        translate([0, fan_gap/2, 0]) for (offset_by = [fan_dia/2:fan_dia + fan_gap:length]) {
            translate([overall_depth/2, offset_by, 0]) draw_fan_mount();
        }
    }
}

module draw_power_side(length, teeth_even=true) {
    difference() {
        draw_outer_side(length=length, teeth_even=teeth_even);
        translate([overall_depth/2, length/4, 0]) draw_power_mount();
    }
}

module draw_middle_fit_old() {
    difference() {
        cube([material_thickness, filter_width, filter_height]);
        translate([-0.05, middle_piece_border_size, middle_piece_border_size]) cube([material_thickness+0.1, filter_width - middle_piece_border_size*2, filter_height - middle_piece_border_size*2]);
    }
}

module draw_middle_fit_hole(flip=false) {
    width = flip ? filter_width : filter_height;
    height = flip ? filter_height : filter_width;

    for (i = [0:middle_piece_teeth_count-1]) {
        offset_by = width/8 + ((width/4) * i);
        rotate([90, 0, 90]) linear_extrude(material_thickness) polygon(points=[
                [0, 0],
                [0, offset_by - (middle_piece_teeth_size/2)],
                [-material_thickness, offset_by - (middle_piece_teeth_size/2)],
                [-material_thickness, offset_by + (middle_piece_teeth_size/2)],
                [0, offset_by + (middle_piece_teeth_size/2)],
            ]);
    }

    for (i = [0:(middle_piece_teeth_count/2)-1]) {
    for (a = [0:1]) {
        vert_offset_by = (material_thickness + width) * a;
        horiz_offset_by = height/8 + ((height/4) * i);
        translate([material_thickness, 0]) rotate([0, 270, 0]) linear_extrude(material_thickness) polygon(points=[
                [vert_offset_by, 0],
                [vert_offset_by, horiz_offset_by - (
        middle_piece_teeth_size/2)],
                [vert_offset_by-material_thickness, horiz_offset_by - (middle_piece_teeth_size/2)],
                [vert_offset_by-material_thickness, horiz_offset_by + (middle_piece_teeth_size/2)],
                [vert_offset_by, horiz_offset_by + (
        middle_piece_teeth_size/2)]
            ]);
    }
    }
}

module draw_middle_fit_corner(flip=false) {
    down_by = 7;
    down_by_2 = 14;

    width = flip ? filter_width : filter_height;
    height = flip ? filter_height : filter_width;

    draw_middle_fit_hole(flip);

    rotate([90, 0, 90]) linear_extrude(material_thickness) polygon(points=[
            [0, 0],
            [0, width],

            // top half
            [height/2, width],
            // top half fitting thing
            [height/2, width - (middle_piece_border_size*0.35)],
            [height/2 - down_by, width - (middle_piece_border_size*0.35)],
            [height/2 - down_by, width - (middle_piece_border_size*0.2)],
            [height/2 - down_by_2, width - (middle_piece_border_size*0.2)],
            [height/2 - down_by_2, width - (middle_piece_border_size*0.8)],
            [height/2 - down_by, width - (middle_piece_border_size*0.8)],
            [height/2 - down_by, width - (middle_piece_border_size*0.65)],
            [height/2, width - (middle_piece_border_size*0.65)],
            [height/2, width - middle_piece_border_size],
            [middle_piece_border_size, width - middle_piece_border_size],

            [middle_piece_border_size, middle_piece_border_size],
            [height/2, middle_piece_border_size],

            [height/2, middle_piece_border_size*0.65],
            [height/2 + down_by, middle_piece_border_size*0.65],
            [height/2 + down_by, middle_piece_border_size*0.8],
            [height/2 + down_by_2, middle_piece_border_size*0.8],
            [height/2 + down_by_2, middle_piece_border_size*0.2],
            [height/2 + down_by, middle_piece_border_size*0.2],
            [height/2 + down_by, middle_piece_border_size*0.35],
            [height/2, middle_piece_border_size*0.35],

            [height/2, 0],
        ]
    );
}

// !draw_middle_fit_corner();

module draw_middle_fit_both() {
    color("brown") draw_middle_fit_corner();
    color("orange") translate([0, filter_width, filter_height]) rotate([180, 0, 0]) draw_middle_fit_corner();
}

module draw_triangle_old(size=10, depth=material_thickness) {
    linear_extrude(depth) polygon(points=[[0, 0], [size, 0], [0, size]], paths=[[0, 1, 2]]);
}

module draw_triangle(size=10, thickness=2, depth=filter_depth+material_thickness+10, screw_hole_thickness=4, feet_screw_dia=5.5, screw_hole_side_alt=true) {
    difference() {
        translate([-thickness, -thickness]) hull() {
            cube([(thickness), size + (thickness), thickness/2]);
            cube([size + (thickness), (thickness), thickness/2]);
            if (screw_hole_thickness != 0) {
                rotate([0, 0, screw_hole_side_alt ? 90 : 0]) translate([0, thickness-screw_hole_thickness, -depth]) cube([size + (thickness), screw_hole_thickness, depth+1]);
            }
            translate([0, 0, -depth]) cube([size + thickness, thickness, depth+1]);
            translate([0, 0, -depth]) cube([(thickness), size + (thickness), thickness/2]);
        }
        translate([-0.1, -0.1, -depth-1]) cube([size+0.1, size+0.1, depth+1]);

        if (screw_hole_thickness != 0) {
            # translate([screw_hole_side_alt ? -screw_hole_thickness : 0, 0, 0]) rotate([0, 0, screw_hole_side_alt ? 90 : 0]) translate([(screw_hole_dia/2)+(size/2), 0.25, (screw_hole_dia/-2)-(depth/2)+7]) rotate([90, 0, 0]) cylinder(h=screw_hole_thickness+0.5, d1=triangle_screw_hole_dia*0.9, d2=triangle_screw_hole_dia);
        }

        for(screw_hole_side_offset_base = screw_hole_side_offsets) {
            screw_hole_side_offset = screw_hole_side_offset_base + material_thickness;
            translate([0.5, (screw_hole_dia/-2) + screw_hole_side_offset, (screw_hole_dia/-2) - screw_hole_inward_offset]) rotate([0, 270, 0]) cylinder(h=thickness+screw_hole_thickness+1, d=triangle_screw_hole_dia);
            translate([(screw_hole_dia/-2) + screw_hole_side_offset, 0.5, (screw_hole_dia/-2) - screw_hole_inward_offset]) rotate([90, 0, 0]) cylinder(h=thickness+screw_hole_thickness+1, d=triangle_screw_hole_dia);
         }
        translate([size/2 - 5, -0.5, depth/-2]) rotate([0, 90, 90]) linear_extrude(height=0.6) text(text=str(material_thickness, "mm"), size=5, halign="center", valign="center");
    }
}

module draw_corner_tris() {
    translate([0, -material_thickness, -material_thickness]) rotate([0, 270, 0]) draw_triangle(size=corner_tri_size);
    translate([0, filter_width+material_thickness, -material_thickness]) rotate([90, 0, 270]) draw_triangle(size=corner_tri_size);
    translate([0, filter_width+material_thickness, filter_height+material_thickness]) rotate([90, 90, 270]) draw_triangle(size=corner_tri_size);
    translate([0, -material_thickness, filter_height+material_thickness]) rotate([270, 0, 0]) rotate([0, 270, 0]) draw_triangle(size=corner_tri_size);
}

module draw_preview () {
    translate([filter_depth, 0, 0]) draw_middle_fit_both();
    translate([overall_depth - filter_depth - material_thickness, 0, 0]) draw_middle_fit_both();

    translate([0, 0, filter_height]) draw_fan_side(fan_count=primary_fans_count, length=filter_width);
    rotate([90, 0, 0]) color("yellow") draw_fan_side(fan_count=secondary_fans_count, length=filter_height, teeth_even=false);
    translate([0, 0, -material_thickness]) draw_outer_side(length=filter_width);
    translate([0, filter_width + material_thickness, 0]) color("yellow") rotate([90, 0, 0]) draw_power_side(length=filter_height, teeth_even=false);

    color("green") draw_corner_tris();
    color("green") translate([overall_depth, filter_width, 0]) rotate([0, 0, 180])  draw_corner_tris();
}

module draw_projections() {
    // fan side
    projection(cut = true) draw_fan_side(fan_count=primary_fans_count, length=filter_width);
    // bottom
    translate([0, filter_width*1.1, 0]) projection(cut = true) draw_outer_side(length=filter_width);
    // sides
    translate([overall_depth*1.1, 0, 0]) projection(cut = true) draw_fan_side(fan_count=secondary_fans_count, length=filter_height, teeth_even=false);
    translate([overall_depth*1.1, filter_height*1.1, 0]) projection(cut = true) draw_power_side(length=filter_height, teeth_even=false);
    // middle brackets, A
    for (a = [0:3]) {
        translate([overall_depth*2.2, a*filter_width*0.6, 0]) projection() rotate([0, 90, 0]) draw_middle_fit_corner();
    }
}

if (triangle_only) {
    rotate([90, 0, 0]) draw_triangle(size=corner_tri_size, thickness=2, screw_hole_thickness=(draw_triangle_with_feet_holes ? 4 : 0), screw_hole_side_alt=draw_triangle_with_alt_holes);
}
else if ($preview == true) {
    draw_preview();
}
else {
    draw_projections();
}
