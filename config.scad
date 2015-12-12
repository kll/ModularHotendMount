// modules
module_body_size = [25, 50, 10];
module_mount_edge_offset = 5;
module_level_bolt_size = 4;
module_level_spring_diameter = 8;
module_level_bolt_spacing = module_body_size[1] - 2*module_mount_edge_offset;
module_clamp_bolt_size = 4;
module_clamp_bolt_head_height = 2.5;

// main body
body_wall_thickness = 5;
body_size = [3*module_body_size[0]+2*body_wall_thickness+1, module_body_size[1]+2*body_wall_thickness+1, 55];
carriage_mount_hole_spacing=22.5;	// i3 rework standard
carriage_screw_size = 4;
carriage_screw_head_height = 2.5;
hotend_fan_output = 49;
hotend_fan_screw_spacing = 40;
hotend_fan_screw_size = 4;
blower_screw_spacing = 40;
blower_screw_size = 4;

// misc
body_chamfer = 2;
layer_height = 0.3;
tolerance = 0.1;
pf = 0.1;  // preview fix for z-buffer tearing on cuts
