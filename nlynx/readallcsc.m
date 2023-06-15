function allData = readallcsc( dirPath, fList )
% READCSC reads a group of csc channels in a folder.
%
% Usage:
% allCsc = readallcsc( dirPath )
% allCsc = readallcsc( dirPath, fNames )
%
% Input:
% dirPath: Path to directory with CSC data.
%
% Output:
% allCsc: Structure with following fields:
%       Data: data matrix in samples x channels.
%       Labels: CSC file name (e.g. 'CSC1').
%       Channels: Channel numbers (e.g. 3)
%       Fs: Sampling frequency (in Hz).
%       ts: timestamps vector (in us).
%       firstEvTs: time recording started.
%       loHiFilt: low- and high-cut filters for each channel.
%       dirPath: folder containing the pre-procesed data.

% Get timestamp at acqusition start
evs = readevnlynx( dirPath );
firstEvTs = evs.TimeStamp( 1 );

% Find all connected channels
if nargin == 1
    [ tempEmpty, tempCsc ] = getempty( dirPath );
    % Sort files into natural order
    [ cscFiles, idx ] = natsortfiles( tempCsc );
    emptyFiles = tempEmpty( idx );
    
elseif nargin == 2
    % keep files in order provided
    [ emptyFiles, cscFiles ] = getempty( dirPath, fList );
    
else
    error( 'Wrong number of arguments' )
    
end


nFiles = length( cscFiles );
% read first non-empty file and allocate data matrix within csc structure.
datMat = nandatamat( emptyFiles, cscFiles, dirPath );
channels = nan( 1, nFiles );
Fs = nan( 1, nFiles );
[ nSamps, nChanns ] = size( datMat );
ts = nan( nSamps, nChanns );
allData = struct(...
    'data', datMat,...
    'channels', channels,...
    'Fs', Fs,...
    'ts', ts,...
    'dirPath', dirPath );

% Loop reading all CSC channels. If not connected, fill with NaNs.
for fIdx = 1 : nFiles
    thisFile = cscFiles{ fIdx };
    csc = readcsc( fullfile( dirPath, thisFile ) );
    
    % Fill matrix with info that is not dependent on empty files.
    [ ~, allData.labels{ fIdx }, ~ ] = fileparts( csc.fileName );
    allData.channels( fIdx ) = csc.hdr.ADChan;
    allData.Fs( fIdx ) = csc.hdr.Fs;
    allData.loHiFilt( fIdx, : ) = [ csc.hdr.lowCut csc.hdr.highCut ];
    
    % Fill data dependent on empty files
    if ~emptyFiles( fIdx )
        allData.data( :, fIdx ) = csc.data;
        allData.relTs( :, fIdx ) = csc.relTs;
        allData.ts( :, fIdx ) = csc.tStamps;
        
    else
        msg = strcat( thisFile, ' is empty.' );
        warning( msg )
        
    end
    
end
% allData.labels = chNames;
allData.firstEvTs = firstEvTs;
allData.emptyFiles = emptyFiles;

% helper fx's
function datMat = nandatamat( emptyFiles, files, dirPath )

nFiles = length( emptyFiles );
if nFiles == sum( emptyFiles )
    error( 'nandatmat:allEmpty', 'All csc files are empty.' )
    
end

for testIdx = 1 : nFiles
    test = emptyFiles( testIdx );
    
    if ~test
        f2read = fullfile( dirPath, files{ testIdx } );
        valSamp = Nlx2MatCSC( f2read, [ 0 0 0 1 0 ], 0, 1, [ ] );
        datMat = nan( sum( valSamp ), nFiles );
        break
        
    end
    
end




