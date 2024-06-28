%% Read depth file
clear all
close all
clc

transDir = "E:\Dropbox (MIT)";
dataDir = "E:\Temp\TestKinect";
baseName = "KinectDepth";
condition = "_good";
f2check = fullfile( transDir, strcat( baseName, condition ) );
% f2save = fullfile( dataDir, strcat( baseName, ".bin" ) );

%% Check if file is zipped and unzip 
contents = dir( strcat( f2check, "*" ) );
[ ~, ~, ext ] = fileparts( contents( 1 ).name );
if strcmp( ext, ".zip" )
    unzip( strcat( f2check, ext ), dataDir )

end

%% Read bin file using memory mapping
m = memmapfile( fullfile( dataDir, strcat( baseName, ".bin" ) ), ...
      'Format', 'uint16',...
      'Writable', false );

%% Plot depth file
% depth stream figure
H = 424;
W = 512;
outOfRange = 4000;
depth = zeros( H, W, 'uint16' );
figure
colormap( flipud( magma ) )
h1 = imagesc( depth, [ 0 outOfRange ] );
title( 'Depth data' )
colormap( magma )
colorbar
caxis( [ 0 4000 ] )


% data16( data16 > outOfRange ) = outOfRange;
nSamplesPerFrame = W * H;
nData = length( m.Data );
nFrames = nData / nSamplesPerFrame;
blockIdx = [...
    1 : nSamplesPerFrame : nData;...
    nSamplesPerFrame : nSamplesPerFrame : nData ]';
for wIdx = 1 : nFrames
    % thisData = data16( blockIdx( wIdx, 1 ) : blockIdx( wIdx, 2 ) );
    thisData = m.Data( blockIdx( wIdx, 1 ) : blockIdx( wIdx, 2 ) );
    thisData( thisData > outOfRange ) = outOfRange;
    thisFrame = reshape( thisData, W, H );
    set( h1, 'CData', thisFrame' );
    pause( 1 / 30 )

end


%% Plot point cloud movie 
clear all
close all
clc

fid = fopen('KinectDepth.bin', 'r');
data16 = fread(fid, Inf, 'uint16');
fclose(fid);

% point cloud figure
H = 424;
W = 512;
pc = pointCloud( zeros( H * W, 3 ) );
pcFig.h = figure;
pcFig.ax = pcshow( pc );
pcFig.View = [ 27.7920 -6.7842 ];

outOfRange = 4000;
data16( data16 > outOfRange ) = outOfRange;
nSamplesPerFrame = W * H;
nData = length( data16 );
nFrames = nData / nSamplesPerFrame;
blockIdx = [...
    1 : nSamplesPerFrame : nData;...
    nSamplesPerFrame : nSamplesPerFrame : nData ]';
for wIdx = 1 : nFrames
    thisData = data16( blockIdx( wIdx, 1 ) : blockIdx( wIdx, 2 ) );
    thisFrame = reshape( thisData, W, H );
    xyzMat = getxyzmat( thisFrame, W, H );
    pc = pointCloud( xyzMat );
    pcshow( pc, 'Parent', pcFig.ax, 'VerticalAxis', 'Y' );
    pause( 1 /30 )

end


% generate white point cloud
col = repmat( [ 1 1 1 ], size( xyz, 1 ), 1 );
pc1 = pointCloud( xyz, 'Color', col );
figure, pcshow( pc1 )

% dataDepth = reshape( data, W, H, [] );

%% Convert to meters
% from https://openkinect.org/wiki/Imaging_Information#Depth_Camera
distance = 0.1236 * tan( ( xyz ./ 2842.5 ) + 1.1863 );
distance = distance - 0.037;

% generate white point cloud
col = repmat( [ 1 1 1 ], size( distance, 1 ), 1 );
pc1 = pointCloud( distance, 'Color', col );
pcshow( pc1 )

% not sure what this does.
% minDistance = -10;
% scaleFactor = 0.0021;
% x = ( i - w / 2) * ( z + minDistance ) * scaleFactor
% y = ( j - h / 2) * ( z + minDistance ) * scaleFactor
% z = z;

%% Helper functions
function xyzMat = getxyzmat( frame, W, H )
count = 1;
for wIdx = 1 : W

    for hIdx = 1 : H
        thisVal = frame( wIdx, hIdx );

        if thisVal > 0
            xyzMat( count, 1 : 3 ) = [ wIdx, hIdx, thisVal ];

        end
        count = count + 1;

    end

end

end