function csc = readlfpnlynx( fileName, epoch, dec )
% READNLYNX reads neuralynx continuously sampled channels.
%
% Syntax:
% nlynx = readnlynx( fileName )
% nlynx = readnlynx( fileName, epoch )
% nlynx = readnlynx( fileName, epoch, dec )
%
% Description:
% nlynx = readnlynx(fileName) returns a strucuture with all the data
% contained in the neuralynx channel, wether a csc, nst or ntt.
%
% nlynx = readnlynx(fileName,epoch) where epoch is a two element vector,
% returns the data from epoch(1) to epoch(2). the units of epoch are
% seconds.
%
% nlynx = readnlynx(fileName,epoch,dec) where dec is an integer scalar,
% decimates the signal by the dec factor.
%
% Examples:
% nlynx = readnlynx('CSC15.ncs') returns all the data from file CSC15,
% without downsampling.
%
% nlynx = readnlynx('CSC15.ncs',[0 20]) returns the data for the first 20
% seconds of recording, without downsampling.
%
% nlynx = readnlynx('CSC15.ncs',[],10) returns all the data, downsampled by
% a factor of 10.
%
% Dependencies:
% parsenlynxhdr.m
% interpts.m
% Nlx2MatCSC.m and mex files.

% Check user input.
[ ~, ~, ext ] = fileparts( fileName );
if isempty( ext )
    fileName = strcat( fileName, '.ncs' );
    
end

if nargin < 2
    epoch = [ ];
    
end

if nargin < 3
    dec = 1;
    
end

% Check file not empty. If < 16384 bytes, discard.
fInfo = dir( fileName );
minBytes = 16384; % from actual empty files
if ~isempty( fInfo ) 
    if fInfo.bytes <= minBytes
        error( 'readncs:emptyFile', '.ncs file seems to be empty.' )
    
    end
    
else
    error( 'readncs:noFile', 'File does not exist.' )
    
end

% Check records to decide which ts inerpolation to use


if isempty( epoch )
    parm4 = 1; % extract all data
    [ rawTs, chNum, Fs, valSamp, rawData, rawHdr ] = Nlx2MatCSC(...
        fileName, [ 1 1 1 1 1 ], 1, parm4, [ ] );
    
else
    parm4 = 4; % extract only given records
    [ rawTs, chNum, Fs, valSamp, rawData, rawHdr ] = Nlx2MatCSC(...
        fileName, [ 1 1 1 1 1 ], 1, parm4, epoch );
%     data = Nlx2MatCSC( fileName, [ 0 0 0 0 1 ], 0, parm4, epoch );
%     tempData = data( : ) * convFactor * 1e6; % convert AD units to microvolts
%     dummyTs = Nlx2MatCSC( fileName, [ 1 0 0 0 0 ], 0, parm4, epoch );
    
end

% Parse header
hdr = parsehdrnlynx( rawHdr );

% Convert AD units to uV
convFactor = hdr.convFactor;
tempData = rawData( : ) * convFactor * 1e6;
tempTs = interpts( rawTs, valSamp );

% decimate if desired
if dec > 1
    disp( ' Decimating data...' )
    tempData = decimate( tempData, dec, 'fir' );
    tempTs = downsample( tempTs, dec );
    
end
ts = tempTs;

% get Fs, and throw a warning if not integer.
Fs = hdr.Fs ./ dec;
if rem( hdr.Fs, dec ) > 0
    warning( 'sampling frequency not integer' )
    
end
 
% invert data if recorded with positive upwards.
if hdr.inverted
    disp( ' Data converted to positive downwards.' )
    data = tempData * -1;
    
else
    disp( ' Data recorded with positive downwards. No conversion.' )
    data = tempData;
    
end

% else
%     warning('MATLAB:readnlynx','There are non-complete records in the file')
%     % in the near future, actually look for the wrong record, if is not
%     % the last
%     nSamp = nSamp( end );
%
% end

% Create timestamps in seconds.
% tStamp = interpts( dummyTs );

% Convert dsp delay to seconds.
hdr.dspDelay = hdr.delay ./ 1e6;

% 
csc = struct(...
    'FileName', fileName,...
    'Fs', Fs,...
    'Hdr', hdr,...
    'PhysUnits', 'uV', ...
    'Data', data, ...
    'ts', ts );

disp('Done!')
disp( ' ' )
