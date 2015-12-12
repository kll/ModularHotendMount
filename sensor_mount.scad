use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
include <config.scad>
use <nuttrap.scad>
use <fancy_cube.scad>

sensor_diameter = 18.75;
sensor_nut_height = 6.5;

main();

module main()
{
    difference()
    {
        ccube(module_body_size, body_chamfer, true);
        sensor_cutout();
        leveling_hardware_cutout();
    }
}

module sensor_cutout()
{
    cut_size = module_body_size[2] + pf;
    translate([0, 0, -cut_size/2])
    {
        polyhole(cut_size, sensor_diameter);
    }
    
    nut_offset = module_body_size[2]/2 + sensor_nut_height/2 - sensor_nut_height + pf;
    translate([0, 0, nut_offset])
    {
        rotate([0, 0, 90])
        {
            cylinder(h=sensor_nut_height, d=METRIC_NUT_AC_WIDTHS[16], $fn=6, center=true);
        }
    }
}

module leveling_hardware_cutout()
{
    cut_length = module_body_size[2] + pf;
    cut_offset = module_body_size[1]/2 - module_mount_edge_offset;
    rotate([0, 0, 90])
    {
        for(y=[0:1])
        {
            rotate([0, 0, y*180])
            {
                translate([cut_offset, 0, 0])
                {
                    nutTrap(module_bolt_size, module_mount_edge_offset, tolerance);
                }
                
                translate([cut_offset, 0, -cut_length/2])
                {
                    polyhole(cut_length/2, module_bolt_size);
                }
                
                translate([cut_offset, 0, METRIC_NUT_THICKNESS[module_bolt_size]/2 + pf/2 + layer_height])
                {
                    polyhole(cut_length/2, module_bolt_size);
                }
                
                translate([cut_offset, 0, module_body_size[2]/4])
                {
                    polyhole(module_body_size[2]/4 + pf, module_level_spring_diameter);
                }
            }
        }
    }
}
