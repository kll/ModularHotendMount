module ccube(size, chamfer, sides=true)
{
    hull()
    {
        cube([size[0] - chamfer, size[1] - chamfer, size[2]], true);

        if (sides)
        {
            cube([size[0] - chamfer, size[1], size[2] - chamfer], true);
            cube([size[0], size[1] - chamfer, size[2] - chamfer], true);
        } else {
            cube([size[0], size[1], size[2] - chamfer], true);
        }
    }
}

module fcube(size, radius, sides=true)
{
    diameter = 2*radius;
    adjusted = [size[0] - diameter, size[1] - diameter, size[2] - diameter];
    offset = [adjusted[0]/2, adjusted[1]/2, adjusted[2]/2];

    ccube(size, diameter, sides);
    top_bottom_fillets(radius, adjusted, offset);

    if (sides)
    {
        side_fillets(radius, adjusted, offset);
    }
    else
    {
        corner_fillets(radius, size, offset);
    }
}

module top_bottom_fillets(radius, size, offset)
{
    for (y=[-1,1])
    {
        for (z=[-1,1])
        {
            translate([0, y*offset[1], z*offset[2]])
            {
                rotate([0, 90, 0])
                {
                    rotate([0, 0, 90])
                    {
                        cylinder(r=radius, h=size[0], center=true);
                    }
                }
            }
        }
    }

    for (x=[-1,1])
    {
        for (z=[-1,1])
        {
            translate([x*offset[0], 0, z*offset[2]])
            {
                rotate([90, 0, 0])
                {
                    cylinder(r=radius, h=size[1], center=true);
                }
            }
        }
    }
}

module corner_fillets(radius, size, offset)
{
    intersection()
    {
        for (y=[-1,1])
        {
            for (z=[-1,1])
            {
                translate([0, y*offset[1], z*offset[2]])
                {
                    rotate([0, 90, 0])
                    {
                        cylinder(r=radius, h=size[0], center=true);
                    }
                }
            }
        }

        for (x=[-1,1])
        {
            for (z=[-1,1])
            {
                translate([x*offset[0], 0, z*offset[2]])
                {
                    rotate([90, 0, 0])
                    {
                        cylinder(r=radius, h=size[1], center=true);
                    }
                }
            }
        }
    }
}

module side_fillets(radius, size, offset)
{
    for (x=[-1,1])
    {
        for (y=[-1,1])
        {
            translate([x*offset[0], y*offset[1], 0])
            {
                cylinder(r=radius, h=size[2], center=true);
            }
        }
    }

    for (x=[-1,1])
    {
        for (y=[-1,1])
        {
            for (z=[-1,1])
            {
                translate([x*offset[0], y*offset[1], z*offset[2]])
                {
                    sphere(r=radius, center=true);
                }
            }
        }
    }
}
