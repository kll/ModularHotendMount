use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
include <config.scad>
use <nuttrap.scad>
use <fancy_cube.scad>

front_back_y_offset = ((body_size[1] + (body_size[1] - 2*body_wall_thickness))/2)/2;
side_x_offset = ((body_size[0] + (body_size[0] - 2*body_wall_thickness))/2)/2;

main(false);

module main(print=true)
{
	difference()
	{
		ccube(body_size, body_chamfer, true);
		
		inner_cut_size = [body_size[0]-2*body_wall_thickness, body_size[1]-2*body_wall_thickness, body_size[2]-2*body_wall_thickness + pf];
		cube(inner_cut_size, true);
		
		back_cuts();
		top_cuts(inner_cut_size);
		bottom_cuts(inner_cut_size);
		side_cuts();
		front_cuts();
	}
}

module back_cuts()
{
	translate([0, front_back_y_offset, 0])
	{
		carriage_mount_holes();
		back_vents();
	}
}

module carriage_mount_holes()
{
	rotate([90, 0, 0])
	{
		for(r=[1:4])
		{
			rotate([0,0,r*90]) translate([carriage_mount_hole_spacing/2, carriage_mount_hole_spacing/2,0])
			{
				translate([0, 0, -(body_wall_thickness+pf)/2])
				{
					polyhole(body_wall_thickness+pf, carriage_screw_size);
				}
	
				translate([0, 0, (body_wall_thickness+pf)/2 - carriage_screw_head_height])
				{
					polyhole(carriage_screw_head_height, METRIC_NUT_AC_WIDTHS[carriage_screw_size]);
				}
			}
		}
	}
}

module back_vents()
{
	carriage_mount_x = 40;
	vent_x = (body_size[0] - 2*body_wall_thickness - carriage_mount_x)/2;
	rotate([90, 0, 0])
	{
		for(x=[-1:2:1])
		{
			x_offset = (body_size[0]/2)-(vent_x/2)-body_wall_thickness;
			y_offset = body_size[2]/2 - vent_x/2 - body_wall_thickness;
			hull()
			{
				translate([x*x_offset, y_offset, 0])
				{
					cylinder(d=vent_x, h=body_wall_thickness+pf, center=true);
				}
				
				translate([x*x_offset, -y_offset, 0])
				{
					cylinder(d=vent_x, h=body_wall_thickness+pf, center=true);
				}
			}
		}
	}
}

module top_cuts(inner_cut_size)
{
	top_z = 2*body_wall_thickness + pf;
	top_z_offset = ((body_size[2]+inner_cut_size[2])/2)/2;
	translate([0, 0, top_z_offset])
	{
		x = body_size[0]-2*body_wall_thickness;
		y = module_level_bolt_spacing - module_level_spring_diameter - 2;
		cube([x, y, top_z], true);
	}
	
	module_mount_holes();
	module_wire_holes();
}

module module_mount_holes()
{
	for (x=[-1:2:1])
	{
		for (y=[-1:2:1])
		{
			x_offset = module_body_size[0]/2 * x;
			y_offset = module_level_bolt_spacing/2 * y;
			z_offset = body_size[2]/2 - module_body_size[2]/2 - pf/2;
			translate([x_offset, y_offset, z_offset])
			{
				polyhole(body_wall_thickness + pf, module_level_bolt_size);
			}
			
			translate([x_offset, y_offset, z_offset])
			{
				polyhole(body_wall_thickness*0.75, module_level_spring_diameter);
			}
		}
	}
}

module module_wire_holes()
{
	z_offset = body_size[2]/2 + body_wall_thickness/2 - module_body_size[2]/2;
	translate([0, 0, z_offset])
	{
		cube([module_body_size[0]/2, body_size[1] - 2*body_wall_thickness, body_wall_thickness + pf], true);
	}
}

module front_cuts()
{
	translate([0, -front_back_y_offset, 0])
	{
		fan_mount();
	}
}

module fan_mount()
{
	rotate([90, 0, 0])
	{
		cylinder(d1=45, d2=hotend_fan_output, h=body_wall_thickness+pf, center=true);
		
		for(r=[1:4])
		{
			rotate([0,0,r*90])
			{
				translate([hotend_fan_screw_spacing/2, hotend_fan_screw_spacing/2,0])
				{
					translate([0, 0, -(body_wall_thickness+pf)/2])
					{
						polyhole(body_wall_thickness+pf, hotend_fan_screw_size);
					}
					
					rotate([0, 0, 225])
					{
						nutTrap(hotend_fan_screw_size, hotend_fan_screw_spacing/2, tolerance);
					}
				}
			}
		}
	}
}

module side_cuts()
{
	for(x=[-1:2:1])
	{
		translate([x*side_x_offset, 0, 0])
		{
            rotate([0, 0, x*90])
            {
                fan_mount();
            }
		}
	}
}

module bottom_cuts(inner_cut_size)
{
	cut_size = [inner_cut_size[0], inner_cut_size[1], body_wall_thickness+2*body_chamfer+pf];
	z_offset = ((body_size[2]+inner_cut_size[2])/2)/2;
	translate([0, 0, -z_offset])
	{
		ccube(cut_size, body_chamfer, true);
	}
}