function idx = getepochidx( ts, epochStart, epochLength )

%GETEPOCHIDX get the indexes for a given epoch.
% 
% Usage:
% idx = getepochidx( ts, epochStart, epochLength )
% 
% Input:
% ts: timestamps vector
% epochStart: time at which to start the epoch.
% epochlength: length of the epoch to extract.
% Note that the units have to be consistent.
% 
% Output:
% idx = logical vector of the same length as ts. It has ones in the
% positions of the desired epoch to extract.

idx = false( length( ts ), 1 );
dt = ts( 2 ) - ts( 1 );
offset = ts( 1 );
idxStart = ceil( ( epochStart - offset + 1 ) / dt );
nPoints = ceil( epochLength / dt );
    
if ( idxStart + nPoints ) <= length( ts );
    idx( idxStart : idxStart + nPoints - 1 ) = true;
    
else
    error( 'Epoch extends beyond length of time vector' )
    
end
