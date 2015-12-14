use <MCAD/polyholes.scad>
include <config.scad>

thickness = 1.5;
flag_size = [1, 14, 10];
flag_y_offset_from_x_carriage = 12.5;
spines=10;
spine_offset=6;
spine_rotation=0;
size = blower_screw_spacing + blower_screw_size;

exterior();
interior();
flag();

module exterior()
{
	difference()
	{
		hull()
		{
			for(r=[1:4])
			{
				rotate([0, 0, r*90])
				{
					translate([blower_screw_spacing/2, blower_screw_spacing/2, 0])
					{
						cylinder(d=2*blower_screw_size, h=thickness, center=true);
					}
				}
			}
		}
		
		cylinder(d=size, h=thickness+pf, center=true);
		
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
				}
			}
		}
	}
}

module interior()
{
	holeradius=size/2;

	translate([0, 0, -thickness/2])
	{
		for(i=[0:spines-1])
		{
			rotate(a=[0,0,i*(360.0/spines)+spine_rotation]) 
			{
				translate([spine_offset,-spine_offset/3.141,0])
				{
					cube([thickness,holeradius+(spine_offset/3.141),thickness]);
				}
			}
		}
	}
}

module flag()
{
	flag_x_offset = body_size[1]/2 - flag_y_offset_from_x_carriage;
	translate([-flag_x_offset, 0, 0])
	{
		translate([0, 0, flag_size[2]/2])
		{
			cube(flag_size, true);
		}
		
		translate([-2.5 + flag_size[0]/2, 0, 0])
		{
			cube([5, flag_size[1], thickness], true);
		}
		
		translate([-0.75, 0, 0.75])
		{
			rotate([0, 45, 0])
			{
				cube([1, flag_size[1], 2], true);
			}
		}
	}
}
