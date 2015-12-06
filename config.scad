// main body
body_size = [100, 60, 55];
body_wall_thickness = 5;
carriage_mount_hole_spacing=22.5;	// i3 rework standard
carriage_screw_size = 4;
carriage_screw_head_height = 4;
hotend_fan_output = 49;
hotend_fan_screw_spacing = 40;
hotend_fan_screw_size = 4;
blower_screw_spacing = 40;
blower_screw_size = 4;

// modules
module_body_size = [50, 25, 10];
module_bolt_size = 3;
module_bolt_head_height = 3.5;
module_mount_edge_offset = 5;
module_level_bolt_spacing = module_body_size[0] - 2*module_mount_edge_offset;

// misc
body_chamfer = 2;
layer_height = 0.3;
tolerance = 0.1;
pf = 0.1;  // preview fix for z-buffer tearing on cuts
