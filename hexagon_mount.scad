use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
include <config.scad>
use <nuttrap.scad>
use <fancy_cube.scad>

body_size = [50, 25, 10];
body_chamfer = 2;
bolt_size = 3;
bolt_head_height = 3.5;
mount_edge_offset = 5;

main(false);

module main(print=true)
{
    rotate([print ? -90 : 0, 0, 0])
    {
        translate([0, 0, print ? body_size[2] : 0])
        {
            split_body_1();
        }
    }

    rotate([print ? 90 : 0, 0, 0])
    {
        translate([0, 0, print ? body_size[2] : 0])
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
        translate([0, -body_size[1]/2, 0])
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
        translate([0, body_size[1]/2, 0])
        {
            slice();
        }
    }
}

module slice()
{
    cube([body_size[0] + pf, body_size[1], body_size[2]+pf], true);
}

module body()
{
    difference()
    {
        ccube(body_size, body_chamfer, true);
        hotend_cutout();
        clamp_hardware_cutout();
        leveling_hardware_cutout();
    }
}

module hotend_cutout()
{
    hotend_inner_offset = body_size[2]/2 + pf;
    translate([0, 0, -hotend_inner_offset])
    {
        polyhole(hotend_inner_height + 2*pf, hotend_inner_diameter);
    }
    
    hotend_outer_height = body_size[2] - hotend_inner_height + pf;
    hotend_outer_offset = body_size[2]/2 - hotend_outer_height/2 + pf;
    translate([0, 0, -hotend_outer_height/2 + hotend_outer_offset])
    {
        polyhole(hotend_outer_height, hotend_outer_diameter);
    }
}

module clamp_hardware_cutout()
{
    cut_length = body_size[1] + pf;
    cut_offset = hotend_outer_diameter/2 + bolt_size;
    for(x=[0:1])
    {
        translate([0, body_size[1]/2 - mount_edge_offset, 0])
        {
            rotate([90, 0, 0])
            {
                rotate([0, 0, 90])
                {
                    rotate([x*180, 0, 0])
                    {
                        translate([0, cut_offset, 0])
                        {
                            nutTrap(bolt_size, body_size[2]/2, tolerance);
                        }
                    }
                }
            }
        }
        
        rotate([90, 0, 0])
        {
            rotate([0,0,x*180])
            {
                partial_cut_head_length = cut_length/2 - bolt_head_height;
                translate([cut_offset, 0, -layer_height])
                {
                    polyhole(partial_cut_head_length, bolt_size);
                }
           
                translate([cut_offset, 0, body_size[1]/2 - bolt_head_height + pf])
                {
                    polyhole(bolt_head_height, METRIC_NUT_AC_WIDTHS[bolt_size]);
                }
                
                partial_cut_nut_length = cut_length/2 - mount_edge_offset - METRIC_NUT_THICKNESS[bolt_size]/2 - pf - layer_height;
                translate([cut_offset, 0, -partial_cut_nut_length])
                {
                    polyhole(partial_cut_nut_length, bolt_size);
                }
                
                translate([cut_offset, 0, -(body_size[1]/2 + pf)])
                {
                    polyhole(mount_edge_offset, bolt_size);
                }
            }
        }
    }
}

module leveling_hardware_cutout()
{
    cut_length = body_size[2] + pf;
    cut_offset = body_size[0]/2 - mount_edge_offset;
    for(x=[0:1])
    {
        rotate([0, 0, x*180])
        {
            translate([cut_offset, 0, 0])
            {
                nutTrap(bolt_size, mount_edge_offset, tolerance);
            }
            
            translate([cut_offset, 0, -cut_length/2])
            {
                polyhole(cut_length, bolt_size);
            }
        }
    }
}