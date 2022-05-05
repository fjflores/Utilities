function allCsc = readallcsc( dirPath )
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
[ tempConn, tempCsc ] = getconnected( dirPath );

% Sort files for natural order
[ cscFiles, idx ] = natsortfiles( tempCsc );
conn = tempConn( idx );

% read first non-empty file and allocate data matrix within csc structure.
datMat = nandatamat( conn, cscFiles, dirPath );
allData = struct(...
    'Data', datMat,...
    'Labels', { },...
    'Channels', [ ],...
    'Fs', Fs,...
    'ts', ts,...
    'dirPath', [ ] );

% Loop reading all CSC channels. If not connected, fill with NaNs.
nFiles = length( cscFiles );
for fIdx = 1 : nFiles
    thisFile = cscFiles( fIdx );
    f2read = fullfile( dirPath, thisFile );
    
    try
        csc = readcsc( f2read );
        
    catch me
        if (strcmp( me.identifier, 'readcsc:emptyFile' ) )
            msg = strcat( thisFile, ' is empty. Filling with NaNs' );
            warning( msg );
            
        else
            error( 'Unknown error' )
            
        end
        
    end
    datMat
    
    
end
    

% helper fx's
function datMat = nandatamat( conn, files, dirPath )


nFiles = length( conn );

for testIdx = 1 : nFiles
    test = conn( testIdx );
    display( [ testIdx test ] )
    
    if test
        f2read = fullfile( dirPath, files{ testIdx } );
        valSamp = Nlx2MatCSC( f2read, [ 0 0 0 1 0 ], 0, 1, [ ] );
        datMat = nan( sum( valSamp ), nFiles );        
        break
        
    end
    
end

if testIdx == length( conn )
    error( 'nandatmat:allEmpty', 'All csc files are empty.' )

end