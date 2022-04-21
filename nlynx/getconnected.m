function [ conn, fName ] = getconnected( recDir )

ext = '*.ncs';
files = dir( fullfile( recDir, ext ) );
minBytes = 16384; % from actual empty files

if ~isempty( files )
    nFiles = length( files );
    conn = false( nFiles, 1 );
    fName = cell( nFiles, 1 );
    
    for fileIdx = 1 : nFiles
        % Check file not empty. If < 16384 bytes, discard.
        nBytes = files( fileIdx ).bytes;
        fName{ fileIdx, 1 } = files( fileIdx ).name;
        
        if nBytes > minBytes
            conn( fileIdx ) = true;
            
        end
            
    end
    
end