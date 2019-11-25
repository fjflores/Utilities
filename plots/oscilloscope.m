%% PLots a random signal oscilloscope like
clear all
close all
clc

% t = randn( 1, 1000 );
t = 0 : 0.01 : 10;
y = sin( 2 * pi * 3 * t );
nPtsStart = 200;
% h = plot( t( 1 : nPtsStart ), y( 1 : nPtsStart ) );
h = plot( y( 1 : nPtsStart ) );
ylim( [ -3 3 ] );
n = 2; % points to advance

while n + 199 <= numel( y )
   newy = y( n + ( 1 : 199 ) );
%    newt = t( n + ( 1 : 199 ) );
   set(...
       h,...
       'ydata', newy )
%        'xdata', newt )
   drawnow;
   n = n + 1;
%    pause( 0.1 )
end

%% PLots spectrogram as oscillsocpoe
clear all
close all
clc


vidObj = VideoWriter( 'chirp.mp4' );
vidObj.FrameRate = 60;  % Default 30
vidObj.Quality = 100; 
% vidObj.FileFormat = 'mp4';
% vidObj.VideoCompressionMethod = 
% myVideo.Quality = 75;    % Default 75

t = 0 : 0.001 : 10;
x = chirp( t, 100, 1, 200, 'quadratic' );
s = spectrogram( x, 128, 120, 128, 1e3 );
S = abs( s );
hS = imagesc( S( :, 1 : 200 ) );
colormap magma
axis xy
ylim( [ 0 65 ] )
caxis( [ 0 35 ] )
n = 2;
[ r, c ] = size( S );
fCnt = 1;
while n + 199 <= c
   newS = S( :, n + ( 1 : 199 ) );
   set( hS, 'cdata', newS );
   drawnow;
   n = n + 1;
   
   F( fCnt ) = getframe( gcf );
   fCnt = fCnt + 1;
%    pause( 0.01 )
   
end

% hFig = figure;
% movie( hFig, F, 1, 60 )

% open( vidObj );
% writeVideo( vidObj, F );
% close( vidObj );