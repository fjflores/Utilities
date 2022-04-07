function hdrRaw = getrawhdr( fileName )
% getrawhdr gets the hdr from a Neuralynx ncs file.
% 
% Usage:
% hdrRaw = getrawhdr( fileName )
% 
% Input
% fileName: File name of an ncs file.
% 

[ ~, ~, ext ] = fileparts( fileName );
if isempty( ext )
    fileName = strcat( fileName, '.ncs' );
    
end

try
    hdrRaw = Nlx2MatCSC( fileName, [ 0 0 0 0 0 ], 1, 3, 1 );
    
catch me
    if strcmp( me.identifier, 'MATLAB:unassignedOutputs' )
        error( 'Utilities:Nlynx', me.message )
        
    else
        error( 'Utilities:Nlynx', 'Provided file is not of .ncs type.' )
        
    end
    
end