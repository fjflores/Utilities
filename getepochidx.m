function idx = getepochidx( ts, epochStart, epochLength )

%GETEPOCHIDX get the indexes for a given epoch (with ms precision).
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

% convert time values to integers, rounded to microseconds resolution.
tInt = round( ts .* 1e6 );
tStart = round( epochStart * 1e6 );
tEnd = round( epochLength .* 1e6 ) + tStart;

% Check that firs time point is less or equal than startTime
if tStart < tInt( 1 )
    error( 'Epoch start time is lesser than the first timestamp' )
    
elseif tEnd > tInt( end )
    error( 'Epoch extends beyond length of time vector' )
    
else
    % if everything is correct, proceed
    idx = false( length( ts ), 1 ); % allocate idx vector.
    rightTail = find( tInt >= tStart );
    leftTail = find( tInt < tEnd );
    
    % Make sure that output is always even in length.
    if isodd( length( leftTail ) )
        leftTail = find( tInt <= tEnd );
        
    end
    idx( rightTail( 1 ) : leftTail( end ) ) = true;
    
end