function nlynx = readtetnlynx( fileName, epoch )
% READNLYNX reads neuralynx continuously sampled channels.
%
% Syntax:
% nlynx = readnlynx( fileName )
% nlynx = readnlynx( fileName, epoch )
% nlynx = readnlynx( fileName, epoch, dec )
%
% Description:
% nlynx = readnlynx(fileName) returns a strucuture with all the data
% contained in the neuralynx file with spike data.
%
% nlynx = readnlynx(fileName,epoch) where epoch is a two element vector,
% returns the data from epoch(1) to epoch(2). the units of epoch are
% seconds.
%
% nlynx = readnlynx(fileName,epoch,dec) where dec is an integer scalar,
% decimates the signal by the dec factor.
%
% Examples:
% nlynx = readnlynx('SE15.nse') returns all the data from file CSC15,
% without downsampling.
%
% nlynx = readnlynx('SE15.nse',[0 20]) returns the data for the first 20
% seconds of recording, without downsampling.
%
% Dependencies:
% parsenlynxhdr.m
% interpts.m
% Nlx2MatCSC.m and mex files.

% Check user input.
[ ~, ~, ext ] = fileparts( fileName );
assert( strcmp( ext, '.nse' ), 'Not a single electrode nlynx file.' );

if nargin < 2
    epoch = [ ];
    dec = 1;
    
elseif nargin < 3
    dec = 1;
    
end

% get header info.
hdr = Nlx2MatSpike( fileName, [ 0 0 0 0 0 ], 1, 3, 1 );

hdrInfo = parsehdrnlynx( hdr );

if isempty( epoch )
    parm4 = 1; % extract all data
    data = Nlx2MatSpike( fileName, [ 0 0 0 0 1 ], 0, parm4, [ ] );
    convFactor = hdrInfo.convFactor;
    tempData = data( : ) * convFactor * 1e6; % convert AD units to microvolts
    ts = Nlx2MatSpike( fileName, [ 1 0 0 0 0 ], 0, parm4, [ ] );
    
else
    parm4 = 4; % extract only given records
    data = Nlx2MatSpike( fileName, [ 0 0 0 0 1 ], 0, parm4, epoch );
    convFactor = hdrInfo.convFactor;
    tempData = data( : ) * convFactor * 1e6; % convert AD units to microvolts
    ts = Nlx2MatSpike( fileName, [ 1 0 0 0 0 ], 0, parm4, epoch );
    
end

% Change dsp delay to seconds.
hdrInfo.dspDelay = hdrInfo.dspDelay ./ 1e6;

nlynx = struct(...
    'fileName', fileName,...
    'infoHdr', hdrInfo,...
    'PhysUnits', 'uV', ...
    'data', data, ...
    'ts', ts )

disp('Done!')