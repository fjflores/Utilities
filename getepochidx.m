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

% deal with rounding problems derived from non-integer sampling rates
Fs = 1 / mean( diff( ts ) );

% round Fs to the second decimal.
Fs = ( round( Fs * 100 ) ./ 100 );

% and now get dt
dt = 1 ./ Fs;
offset = ts( 1 );
firstTime = ( epochStart - offset + 1 ) / dt;

if firstTime < 0.5
    idxStart = ceil( firstTime );
    
else
    idxStart = round( firstTime );
    
end
nPoints = round( epochLength / dt );
    
if ( idxStart + nPoints ) <= length( ts );
    idx( idxStart : idxStart + nPoints - 1 ) = true;
    
else
    error( 'Epoch extends beyond length of time vector' )
    
end
