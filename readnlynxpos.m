function pos = readnlynxpos( fileName, epoch )

% readnlynxpos takes a .nvt file in puts it into a structure.
%
% Input:
%   filename: position file to read. Default is VT1.nvt.
%   epoch:  start and end of epoch to extract, in seconds. Default: [ ].
% 
% Output:
%   pos: structure with fields:
%       ts: vector of timestamps.
%       x: vector of extracted x position in pixels.
%       y: vector of extracted y position in pixels.
%       angle: vector of extracted head angle (degrees).
%       targets: 


% check user input
if nargin == 0
    fileName = 'VT1.nvt';
    epoch = [ ];
    param4 = 1;
    
elseif nargin == 1
    epoch = [ ];
    param4 = 1;
    
elseif nargin == 2
    epoch = epoch * 1e6; % convert seconds to microseconds.
    param4 = 4;  
    
else
    me = error( 'Wrong number of arguments' ); 
    
end

% test file size.
thisFile = dir( fileName );
assert( thisFile.bytes > 16384, 'Position file is empty' )

% read position file
[ t, X, Y, angle, targets, points, header ] = Nlx2MatVT(...
    fileName, [ 1 1 1 1 1 1 ], 1, param4, epoch );

% relativize timestamps to zero
t = t - t( 1 );

% create output structure
pos.ts = t / 1e6; % convert microseconds to seconds.
pos.x = X;
pos.y = Y;
pos.angle = angle;
pos.targets = targets;
pos.points = points;
pos.header = header;






