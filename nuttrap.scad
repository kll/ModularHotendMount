include <MCAD/nuts_and_bolts.scad>

module nutTrap(size, offset, tolerance = +0.0001)
{
    radius = METRIC_NUT_AC_WIDTHS[size]/2+tolerance;
	height = METRIC_NUT_THICKNESS[size]+tolerance;
    apothem = radius*sin(60);

    translate([0, 0, -height/2])
    {
        hull()
        {
            translate([offset, -apothem, 0])
            {
        		cube([0.1, 2*apothem, height]);
        	}

            cylinder(r=radius, h=height, $fn = 6);
        }
    }
}

module nutTrapTest(size, offset, tolerance = +0.0001)
{
    height = 2*(METRIC_NUT_THICKNESS[size]+tolerance);
    width = 2*offset;

    difference()
    {
        cube([width, width, height], true);
        translate([0, 0, 0])
        {
            nutTrap(size, offset, tolerance);
        }
    }
}

nutTrapTest(3, 6);
