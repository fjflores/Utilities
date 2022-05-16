function [ emptyFiles, fName ] = getempty( recDir )

ext = '*.ncs';
files = dir( fullfile( recDir, ext ) );
minBytes = 16384; % from actual empty files

if isempty( files )
    error( 'No .ncs files in this directory' )
    
end

if ~isempty( files )
    nFiles = length( files );
    emptyFiles = false( nFiles, 1 );
    fName = cell( nFiles, 1 );
    
    for fileIdx = 1 : nFiles
        % Check if file is empty. Remember that event empty ncs file have
        % 16384 bytets of header. Mark as true if <= 16384 bytes.
        nBytes = files( fileIdx ).bytes;
        fName{ fileIdx, 1 } = files( fileIdx ).name;
        
        if nBytes <= minBytes
            emptyFiles( fileIdx ) = true;
            
        end
            
    end
    
end