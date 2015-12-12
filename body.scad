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
	vent_x = (body_size[0] - 2*body_wall_thickness - carriage_mount_x)/2 - 2;
	for(x=[-1:2:1])
	{
		x_offset = (body_size[0]/2)-(vent_x/2)-body_wall_thickness;
		translate([x*x_offset, 0, 0])
		{
			cube([vent_x, body_wall_thickness+pf, body_size[2]-2*body_wall_thickness], center=true);
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
		y = module_level_bolt_spacing - 3*module_bolt_size;
		cube([x, y, top_z], true);
	}
	
	module_mount_holes();
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

module module_mount_holes()
{
	for (x=[-1:1])
	{
		for (y=[-1:2:1])
		{
			x_offset = module_body_size[1]/2 * x;
			y_offset = module_level_bolt_spacing/2 * y;
			z_offset = 50/2 - 10/2;
			translate([x_offset, y_offset, z_offset])
			{
				polyhole(10, module_bolt_size);
			}	
		}
	}
}

module front_cuts()
{
	translate([0, -front_back_y_offset, 0])
	{
		front_fan_mount();
		front_vents();
	}
}

module front_vents()
{
	
	vent_x = module_body_size[0] - 2;
	x_offset = (body_size[0]/2)-(vent_x/2)-body_wall_thickness;
	translate([x_offset, 0, 0])
	{
		cube([vent_x, body_wall_thickness+pf, body_size[2]-2*body_wall_thickness], center=true);
	}
}

module front_fan_mount()
{
	translate([-module_body_size[0]/2, 0, 0])
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
}

module side_cuts()
{
	for(x=[-1:2:1])
	{
		translate([x*side_x_offset, 0, 0])
		{
			side_vents();
			blower_mount();
		}
	}
}

module side_vents()
{
	vent_size = blower_screw_spacing + 2*blower_screw_size;
	rotate([22.5, 0, 0])
	{
		rotate([0, 90, 0])
		{
			cylinder(d=vent_size, h=body_wall_thickness+pf, center=true, $fn=8);
		}
	}
}

module blower_mount()
{
	rotate([0, 90, 0])
	{
		for(r=[1:4])
		{
			rotate([0, 0, r*90])
			{
				translate([blower_screw_spacing/2, blower_screw_spacing/2, 0])
				{
					translate([0, 0, -(body_wall_thickness+pf)/2])
					{
						polyhole(body_wall_thickness+pf, blower_screw_size);
					}
					
					rotate([0, 0, 225])
					{
						nutTrap(blower_screw_size, blower_screw_spacing/2, tolerance);
					}
				}
			}
		}
	}
}