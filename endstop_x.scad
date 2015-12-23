use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
include <config.scad>

rod_spacing = 45;
rod_diameter = 8;
rod_center_to_endstop_offset = 12;
thickness = 3;
bolt_diameter = 3;
endstop_bolt_spacing = 19;
endstop_wiring_offset = 17;
endstop_wiring_size = [12, 8, 8];
endstop_width = 11;

width = endstop_width + thickness;
depth = rod_center_to_endstop_offset + rod_diameter + 4;
length = rod_spacing + rod_diameter + 2*thickness;

rotate([0, 90, 0])
{
    endstop();
}

module endstop()
{
    difference()
    {
        translate([-width/2, -length/2, -rod_center_to_endstop_offset])
        {
            cube([width, length, depth]);
        }
        
        center_cut_length = 2*endstop_wiring_offset - endstop_wiring_size[1];
        center_cut_depth = depth-thickness+pf;
        center_cut_offset = rod_center_to_endstop_offset - center_cut_depth/2 - thickness;
        translate([0, 0, -center_cut_offset])
        {
            cube([width+pf, center_cut_length, center_cut_depth], true);
        }
        
        for(y=[-1:2:1])
        {
            rod_offset = rod_spacing/2;
            translate([-width/2 - pf/2, y*rod_offset, 0])
            {
                rotate([0, 90, 0])
                {
                    polyhole(width+pf, rod_diameter+tolerance);
                    
                    hull()
                    {
                        polyhole(width+pf, rod_diameter-tolerance);
                    
                        translate([-depth/2, 0, 0])
                        {
                            polyhole(width+pf, rod_diameter-tolerance);
                        }
                    }
                }
            }
            
            endstop_bolt_length = thickness+pf;
            translate([0, y*endstop_bolt_spacing/2, -rod_center_to_endstop_offset - pf/2])
            {
                polyhole(endstop_bolt_length, bolt_diameter);
                
                translate([0, 0, thickness-METRIC_NUT_THICKNESS[bolt_diameter] + pf])
                {
                    cylinder(d=METRIC_NUT_AC_WIDTHS[bolt_diameter]+tolerance, h=METRIC_NUT_THICKNESS[bolt_diameter], $fn=6);
                }
            }
            
            translate([-endstop_wiring_size[0]/2, y*endstop_wiring_offset - endstop_wiring_size[1]/2, -rod_center_to_endstop_offset-pf/2])
            {
                cube(endstop_wiring_size);
            }
            
            rotate([0, 0, y == 1 ? 180 : 0])
            translate([-endstop_wiring_size[0]/2, -endstop_wiring_offset - endstop_wiring_size[1]/2, -rod_center_to_endstop_offset-pf/2 + endstop_wiring_size[2]])
            {
                rotate([-64, 0, 0])
                {
                    cube([endstop_wiring_size[0], endstop_wiring_size[1], 2*endstop_wiring_size[2]]);
                }
            }
        }
        
        mounting_hardware_z_offset = -rod_center_to_endstop_offset + depth - 5;
        translate([0, length/2+pf/2, mounting_hardware_z_offset])
        {
            rotate([90, 0, 0])
            {
                polyhole(length+pf, bolt_diameter);
            }
        }
        
        translate([0, center_cut_length/2 + METRIC_NUT_THICKNESS[bolt_diameter], mounting_hardware_z_offset])
        {
            rotate([90, 0, 0])
            {
                cylinder(d=METRIC_NUT_AC_WIDTHS[bolt_diameter]+tolerance, h=center_cut_length + 2*METRIC_NUT_THICKNESS[bolt_diameter], $fn=6);
            }
        }
    }
}