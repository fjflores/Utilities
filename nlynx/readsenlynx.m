function nlynx = readsenlynx( fileName, epoch, dec )
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
assert( strcmp( ext, '.nse' ), 'Not single electrode file.' );

if nargin < 2
    epoch = [ ];
    dec = 1;
    
elseif nargin < 3
    dec = 1;
    
end

% get header info.
hdr = Nlx2MatSpike( fileName, [ 0 0 0 0 0 ], 1, 3, 1 );
[...
    Fs,...
    ADChan,...
    time,...
    filter,...
    inpRange,...
    convFactor,...
    inpInverted,...
    dspDelay ] = parsenlxhdr( hdr );
nBuff = Nlx2MatCSC( fileName, [ 0 0 0 1 0 ], 0, 1, [ ] );
% Check if any record is incomplete, by checking buffer length.
buffCheck = any( diff( nBuff ) );

if ~buffCheck
    disp('All records are complete. Extracting data')
    buffLength = nBuff( 1 );
    sprintf( 'Buffer length: %g', buffLength );
    
    if isempty( epoch )
        parm4 = 1; % extract all data
        data = Nlx2MatCSC( fileName, [ 0 0 0 0 1 ], 0, parm4, [ ] );
        tempData = data( : ) * convFactor * 1e6; % convert AD units to microvolts
        dummyTs = Nlx2MatCSC( fileName, [ 1 0 0 0 0 ], 0, parm4, [ ] );
        firstTs = dummyTs( 1 );
        
    else
        parm4 = 4; % extract only given records
        data = Nlx2MatCSC( fileName, [ 0 0 0 0 1 ], 0, parm4, epoch );
        tempData = data( : ) * convFactor * 1e6; % convert AD units to microvolts
        dummyTs = Nlx2MatCSC( fileName, [ 1 0 0 0 0 ], 0, parm4, epoch );
        firstTs = dummyTs( 1 );
        
    end
    
    % decimate if desired
    if dec > 1
        disp( ' Decimating data...' )
        tempData = decimate( tempData, dec, 'fir' );
        Fs = Fs ./ dec;
        
    end
    
    % invert data if recorded with positive upwards.
    if strcmp( inpInverted, 'true' )
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
ts = linspace(...
    0,...
    ( length( data ) ./ Fs ) - ( 1 / Fs ),...
    length( data ) );

% Change dsp delay to seconds.
dspDelay = dspDelay ./ 1e6;

nlynx = struct(...
    'fileName', fileName,...
    'Fs', Fs, ...
    'PhysUnits', 'uV', ...
    'ADChan', ADChan, ...
    'data', data, ...
    'ts', ts, ...
    'filter', filter,...
    'inputRange', inpRange, ...
    'time', time,...
    'dspDelay', dspDelay,...
    'firstTs', firstTs,...
    'positive', 'downwards' );

disp('Done!')