function allData = readallcsc( dirPath )
% READCSC reads all csc channels inside a folder.
%
% Usage:
% allCsc = readallcsc( dirPath )
%
% Input:
% dirPath: Path to directory with CSC data.
%
% Output:
% allCsc: Structure with fields:
%   Data: data matrix in samples x channels.
%   Labels: CSC file name (e.g. 'CSC1').
%   Channels: Channel numbers (e.g. 3)
%   Fs: Sampling frequency (in Hz).
%   ts: timestamps vector (in s).
%   dirPath: folder containing the pre-procesed data.

% Find all connected channels
[ tempEmpty, tempCsc ] = getempty( dirPath );

% Sort files for natural order
[ cscFiles, idx ] = natsortfiles( tempCsc );
emptyFiles = tempEmpty( idx );
nFiles = length( cscFiles );

% read first non-empty file and allocate data matrix within csc structure.
datMat = nandatamat( emptyFiles, cscFiles, dirPath );
% labels = cell( 1, nFiles );
channels = nan( 1, nFiles );
Fs = nan( 1, nFiles );
ts = nan( size( datMat ) );
allData = struct(...
    'data', datMat,...
    'channels', channels,...
    'fs', Fs,...
    'ts', ts,...
    'dirPath', dirPath );

% Loop reading all CSC channels. If not connected, fill with NaNs.
for fIdx = 1 : nFiles
    thisFile = cscFiles{ fIdx };
%     [ ~, temp, ~ ] = fileparts( thisFile );
    csc = readcsc( fullfile( dirPath, thisFile ) );
    
    % Fill matrix with info that is not dependent on empty files.
    allData.labels{ fIdx } = csc.hdr.ADName;
    allData.channels( fIdx ) = csc.hdr.ADChan;
    
    if ~emptyFiles( fIdx )
        allData.data( :, fIdx ) = csc.data;
        
    else
        msg = strcat( thisFile, ' is empty.' );
        warning( msg )
        
    end
    

    
end


% helper fx's
function datMat = nandatamat( conn, files, dirPath )


nFiles = length( conn );

for testIdx = 1 : nFiles
    test = conn( testIdx );
    display( [ testIdx test ] )
    
    if ~test
        f2read = fullfile( dirPath, files{ testIdx } );
        valSamp = Nlx2MatCSC( f2read, [ 0 0 0 1 0 ], 0, 1, [ ] );
        datMat = nan( sum( valSamp ), nFiles );
        break
        
    end
    
end

if testIdx == length( conn )
    error( 'nandatmat:allEmpty', 'All csc files are empty.' )
    
end