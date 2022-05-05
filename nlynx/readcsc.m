function csc = readcsc( fileName, epoch, dec )
% READCSC reads neuralynx continuously sampled channels.
%
% Syntax:
% csc = readcsc( fileName )
% csc = readcsc( fileName, epoch )
% csc = readcsc( fileName, epoch, dec )
%
% Description:
% csc = readcsc(fileName) returns a strucuture with all the data
% contained in the neuralynx channel, wether a csc, nst or ntt.
%
% csc = readcsc(fileName,epoch) where epoch is a two element vector,
% returns the data from epoch(1) to epoch(2). the units of epoch are
% seconds.
%
% csc = readcsc(fileName,epoch,dec) where dec is an integer scalar,
% decimates the signal by the dec factor.
%
% Examples:
% csc = readcsc('CSC15.ncs') returns all the data from file CSC15,
% without downsampling.
%
% csc = readcsc('CSC15.ncs',[0 20]) returns the data for the first 20
% seconds of recording, without downsampling.
%
% csc = readcsc('CSC15.ncs',[],10) returns all the data, downsampled by
% a factor of 10.
%
% Dependencies:
% parsenlynxhdr.m
% interpts.m
% Nlx2MatCSC.m and mex files.

% Check user input.
[ ~, fn, ext ] = fileparts( fileName );
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
        error( 'readcsc:emptyFile', '.ncs file seems to be empty.' )
    
    end
    
else
    error( 'readcsc:noFile', 'File does not exist.' )
    
end

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

% Check records to decide which ts inerpolation to use
dSamp = diff( valSamp );
if any( dSamp )
    nRecs = numel( valSamp );
    idxDiff = find( dSamp );
    
    if numel( idxDiff ) == 1 && idxDiff == nRecs
        tempTs = interpts( rawTs, valSamp( 1 ) );
        
    else
        tempTs = interpts( rawTs, valSamp );
        
    end
    
end

% decimate if desired
if dec > 1
    disp( ' Decimating data...' )
    tempData = decimate( tempData, dec, 'fir' );
    tempTs = downsample( tempTs, dec );
    
end
ts = tempTs ./ 1e6;

% get Fs, and throw a warning if not integer.
Fs = Fs( 1 ) ./ dec;
if rem( Fs, dec ) > 0
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
%     warning('MATLAB:readcsc','There are non-complete records in the file')
%     % in the near future, actually look for the wrong record, if is not
%     % the last
%     nSamp = nSamp( end );
%
% end

% Create timestamps in seconds.
% tStamp = interpts( dummyTs );

% Convert dsp delay to seconds.
hdr.dspDelay = hdr.delay ./ 1e6;
hdr.dspDelayUnits = 's';

% Create structure
csc = struct(...
    'FileName', strcat( fn, ext ),...
    'Fs', Fs,...
    'Hdr', hdr,...
    'Data', data, ...
    'DataUnits', 'uV', ...
    'ts', ts,...
    'tsUnits', 's',...
    'ChNum', chNum( 1 ) );

disp('Done!')
disp( ' ' )
