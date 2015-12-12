use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
include <config.scad>
use <nuttrap.scad>
use <fancy_cube.scad>

hotend_outer_diameter = 16;
hotend_inner_diameter = 12;
hotend_inner_height = 4.25;

main(false);

module main(print=true)
{
    translate([print ? module_body_size[0]/2 : 0, 0, print ? module_body_size[0]/2 : 0])
    {
        rotate([0, print ? 90 : 0, 0])
        {
            split_body_1();
        }
    }

    translate([print ? -module_body_size[0]/2 : 0, 0, print ? module_body_size[0]/2 : 0])
    {
        rotate([0, print ? -90 : 0, 0])
        {
        
            split_body_2();
        }
    }
}

module split_body_1()
{
    difference()
    {
        body();
        translate([-module_body_size[0]/2, 0, 0])
        {
            slice();
        }
    }
}

module split_body_2()
{
    difference()
    {
        body();
        translate([module_body_size[0]/2, 0, 0])
        {
            slice();
        }
    }
}

module slice()
{
    cube([module_body_size[0], module_body_size[1] + pf, module_body_size[2] + pf], true);
}

module body()
{
    difference()
    {
        ccube(module_body_size, body_chamfer, true);
        hotend_cutout();
        clamp_hardware_cutout();
        leveling_hardware_cutout();
    }
}

module hotend_cutout()
{
    hotend_inner_offset = module_body_size[2]/2 + pf;
    translate([0, 0, -hotend_inner_offset])
    {
        polyhole(hotend_inner_height + 2*pf, hotend_inner_diameter);
    }
    
    hotend_outer_height = module_body_size[2] - hotend_inner_height + pf;
    hotend_outer_offset = module_body_size[2]/2 - hotend_outer_height/2 + pf;
    translate([0, 0, -hotend_outer_height/2 + hotend_outer_offset])
    {
        polyhole(hotend_outer_height, hotend_outer_diameter);
    }
}

module clamp_hardware_cutout()
{
    cut_length = module_body_size[1] + pf;
    y_offset = hotend_outer_diameter/2 + module_clamp_bolt_size;
    nut_x_offset = module_body_size[0]/2 - module_mount_edge_offset;
    for(y=[0:1])
    {
        translate([nut_x_offset, 0, 0])
        {
            rotate([0, -90, 0])
            {
                rotate([y*180, 0, 0])
                {
                    translate([0, y_offset, 0])
                    {
                        nutTrap(module_clamp_bolt_size, module_body_size[2]/2, tolerance);
                    }
                }
            }
        }
        
        rotate([0, -90, 0])
        {
            rotate([0, 0, y*180])
            {
                // bolt head
                translate([0, y_offset, module_body_size[0]/2 - module_clamp_bolt_head_height])
                {
                    polyhole(module_clamp_bolt_head_height + pf, METRIC_NUT_AC_WIDTHS[module_clamp_bolt_size]);
                }
                
                // partial span from one layer height away from the bolt head cutout to one layer height away from the nut cutout
                partial_cut_length = module_body_size[0] - module_clamp_bolt_head_height - module_mount_edge_offset - METRIC_NUT_THICKNESS[module_clamp_bolt_size]/2 - tolerance/2 - 2*layer_height;
                partial_cut_offset = nut_x_offset + METRIC_NUT_THICKNESS[module_clamp_bolt_size]/2 - partial_cut_length;
                translate([0, y_offset, partial_cut_offset])
                {
                    polyhole(partial_cut_length, module_clamp_bolt_size);
                }
                
                // nut side exit hole
                nut_side_exit_length = module_mount_edge_offset - METRIC_NUT_THICKNESS[module_clamp_bolt_size]/2 - tolerance/2 + pf;
                translate([0, y_offset, -(module_body_size[0]/2) - pf/2])
                {
                    polyhole(nut_side_exit_length, module_clamp_bolt_size);
                }
            }
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
                    nutTrap(module_level_bolt_size, module_mount_edge_offset, tolerance);
                }
                
                translate([cut_offset, 0, -cut_length/2])
                {
                    polyhole(cut_length, module_level_bolt_size);
                }
                
                translate([cut_offset, 0, module_body_size[2]/4])
                {
                    polyhole(module_body_size[2]/4 + pf, module_level_spring_diameter);
                }
            }
        }
    }
}