% images sizes
depth_width = 512; 
depth_height = 424; 
outOfRange = 4000;

color_width = 1920; 
color_height = 1080;

% Color image is to big, let's scale it down
COL_SCALE = 0.5;

% Create matrices for the images
depth = zeros( depth_height, depth_width, 'uint16' );
color = zeros(...
    color_height * COL_SCALE, color_width * COL_SCALE, 3, 'uint8' );

% Images used to draw the markers
depthAdditions = zeros( depth_height, depth_width, 3, 'uint8' );
colorAdditions = zeros(...
    color_height * COL_SCALE, color_width * COL_SCALE, 3, 'uint8' );

