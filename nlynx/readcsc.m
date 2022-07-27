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
    ext = '.ncs';
    fileName = strcat( fileName, ext );
    
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
if fInfo.bytes > minBytes
    flagFull = true;
    
else
    flagFull = false;
    
end

if isempty( epoch ) && flagFull
    paramVec = [ 1 1 1 1 1 ];
    parm4 = 1; % extract all data
    [ rawTs, chNum, Fs, valSamps, rawData, rawHdr ] = Nlx2MatCSC(...
        fileName, paramVec, 1, parm4, [ ] );
    
elseif ~isempty( epoch ) && flagFull
    paramVec = [ 1 1 1 1 1 ];
    parm4 = 4; % extract only given records
    [ rawTs, chNum, Fs, valSamps, rawData, rawHdr ] = Nlx2MatCSC(...
        fileName, paramVec, 1, parm4, epoch );
    
else
    rawHdr = getrawhdr( fileName );
    rawTs = [];
    chNum = [];
    Fs = [];
    valSamps = [];
    rawData = [];
    
end

% Parse header
hdr = parsehdrnlynx( rawHdr );

% Convert AD units to uV
convFactor = hdr.convFactor;
tempData = rawData( : ) * convFactor * 1e6;

% Check records to decide which ts inerpolation to use
% dSamp = diff( valSamp );
% if any( dSamp )
%     nRecs = numel( valSamp );
%     idxDiff = find( dSamp );
if flagFull
    tempTs = interpts( rawTs, valSamps( 1 ) );
    
end
%
% end

% decimate if desired
if flagFull
    if dec > 1
        disp( ' Decimating data...' )
        tempData = decimate( tempData, dec, 'fir' );
        tStamps = downsample( tempTs, dec );
        
    else
        tStamps = tempTs;
        
    end
    
else
    tStamps = [];
    
end

% Create relative timestamps just to have everything ready.
if flagFull
    relTs = tStamps - tStamps( 1 );
    
else
    relTs = [];
    
end


% get Fs, and throw a warning if not integer.
if flagFull
    Fs = Fs( 1 ) ./ dec;
    if rem( Fs, dec ) > 0
        warning( 'sampling frequency not integer' )
        
    end
    
end

% invert data if recorded with positive upwards.
if hdr.inverted
%     disp( ' Data converted to positive downwards.' )
    data = tempData * -1;
    
else
%     disp( ' Data recorded with positive downwards. No conversion.' )
    data = tempData;
    
end

% Create structure
csc = struct(...
    'fileName', strcat( fn, ext ),...
    'data', data, ...
    'rawTs', rawTs,...
    'tStamps', tStamps,...
    'relTs', relTs,...
    'valSamps', valSamps,...
    'Fs', Fs,...
    'hdr', hdr,...
    'dataUnits', 'uV', ...
    'tsUnits', 'us' );

% disp('Done!')
% disp( ' ' )
