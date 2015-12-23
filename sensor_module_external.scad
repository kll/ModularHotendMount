use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
include <config.scad>

thickness = 1.5;
flag_size = [1, 14, 10];
flag_y_offset_from_x_carriage = 12.5;
spines=10;
spine_offset=6;
spine_rotation=0;
size = blower_screw_spacing + blower_screw_size;

sensor_diameter = 18.75;
sensor_nut_height = 6;
sensor_ledge_width = 32;
sensor_ledge_thickness = 6;
sensor_ledge_length = 40;

exterior();
interior();
sensor_ledge();

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

module sensor_ledge()
{
	translate([0, 0, sensor_ledge_width/2 - thickness/2])
	{
		difference()
		{
			cube([sensor_ledge_length, sensor_ledge_thickness, sensor_ledge_width], true);
			rotate([90, 0, 0])
			{
				sensor_cutout();
			}
			
			// cut edges down to the thickness of a optical endstop flag
			for(x=[-1:2:1])
			{
				for(y=[-1:2:1])
				{
					translate([x*(sensor_ledge_length/2 - 6/2 + pf), y*(3 - 1.25 + pf), thickness])
					{
						cube([6, 2.5, sensor_ledge_width], true);
					}
				}
			}
		}
	}
}

module sensor_cutout()
{
    cut_size = sensor_ledge_thickness + pf;
    translate([0, 0, -cut_size/2])
    {
        polyhole(cut_size, sensor_diameter);
    }
    
    nut_offset = sensor_ledge_thickness/2 + pf;
    translate([0, 0, nut_offset])
    {
        rotate([0, 0, 90])
        cylinder(h=sensor_nut_height, d=METRIC_NUT_AC_WIDTHS[16]+3*tolerance, $fn=6, center=true);
    }
}
