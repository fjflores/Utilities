function [ emptyFiles, fName ] = getempty( recDir, fList )
% GETEMPTY find empty csc/ncs files and returns boolean list.
% 
% Usage:
% [ emptyFiles, fName ] = getempty( recDir )
% [ emptyFiles, fName ] = getempty( recDir, fList )
% 
% Input:
% recDir: path to directory with csc/ncs files.
% fList: Optional. List of files to process as cell array.
% 
% Output:
% emptyFiles: boolean list with true for each empty csc/ncs file.
% fName: file names.


ext = '*.ncs';
if nargin == 1
    files = dir( fullfile( recDir, ext ) );
    % throw an exception if the dir contains no ncs files.
    if isempty( files )
        error( 'getempty:noncsfiles', 'No .ncs files in this directory' )
        
    end
    
else
    for idx = 1 : length( fList )
        files( idx ) = dir( fullfile( recDir, fList{ idx } ) );
        
    end
    
end

minBytes = 16384; % from actual empty files
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