function lfp = readlfpnlynx( fileName, epoch, dec )
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
[ ~, fN, ext ] = fileparts( fileName );
assert( strcmp( ext, '.ncs' ), 'Enter filename with .ncs extension.' );

assert( exist( fileName, 'file' ) == 2, [ 'File ' fN ext ' does not exist' ] )

if nargin < 2
    epoch = [ ];
    dec = 1;
    
elseif nargin < 3
    dec = 1;
    
end

% get header info.
hdr = Nlx2MatCSC( fileName, [ 0 0 0 0 0 ], 1, 3, 1 );
InfoHdr = parsehdrnlynx( hdr, ext );

% If first call to Nlx2Mat fails, check file viability.
try
    nBuff = Nlx2MatCSC( fileName, [ 0 0 0 1 0 ], 0, 1, [ ] );

catch
    error( 'It is likely that %s is empty.', fN )
    
end
msg = sprintf( 'Reading %s%s channel...', fN, ext );
disp( msg )

% Check if any record is incomplete, by checking buffer length.
unequalRecs = any( diff( nBuff ) );

if unequalRecs == false
    disp( 'All records are complete. Extracting data' )
    buffLength = nBuff( 1 );
    sprintf( 'Buffer length: %g', buffLength );
    
    if isempty( epoch )
        parm4 = 1; % extract all data
        data = Nlx2MatCSC( fileName, [ 0 0 0 0 1 ], 0, parm4, [ ] );
        conv = InfoHdr.convFactor;
        tempData = data( : ) * conv * 1e6; % convert AD units to microvolts
        dummyTs = Nlx2MatCSC( fileName, [ 1 0 0 0 0 ], 0, parm4, [ ] );
        
    else
        parm4 = 4; % extract only given records
        data = Nlx2MatCSC( fileName, [ 0 0 0 0 1 ], 0, parm4, epoch );
        tempData = data( : ) * convFactor * 1e6; % convert AD units to microvolts
        dummyTs = Nlx2MatCSC( fileName, [ 1 0 0 0 0 ], 0, parm4, epoch );
        
    end
    
    % decimate if desired
    if dec > 1
        disp( ' Decimating data...' )
        tempData = decimate( tempData, dec, 'fir' );
        
    end
    Fs = InfoHdr.Fs ./ dec;
    
    % invert data if recorded with positive upwards.
    if strcmp( InfoHdr.inpInverted, 'true' )
        disp( ' Data converted to positive downwards.' )
        data = tempData * -1;
        
    else
        disp( ' Data recorded with positive downwards. No conversion.' )
        data = tempData;
        
    end
    
else
    warning('MATLAB:readnlynx','There are non-complete records in the file')
    % in the near future, actually look for the wrong record, if is not
    % the last
    nSamp = nSamp( end );
    
end

% Create timestamps in seconds.
tStamp = interpts( dummyTs );

% Change dsp delay to seconds.
InfoHdr.dspDelay = InfoHdr.dspDelay ./ 1e6;

lfp = struct(...
    'FileName', fileName,...
    'InfoHdr', InfoHdr,...
    'PhysUnits', 'uV', ...
    'Data', data, ...
    'tStamp', tStamp );

disp('Done!')
disp( ' ' )
