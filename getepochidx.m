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

% convert time values to integers, rounded to milliseconds resolution.
tInt = floor( ts * 1000 );
tStart = floor( epochStart * 1000 );
tEnd = floor( epochLength .* 1000 ) + tStart;

% Check that firs time point is less or equal than startTime
if tStart < tInt( 1 );
    error( 'Epoch start time is lesser than the first timestamp' )
    
elseif tEnd > tInt( end )
    error( 'Epoch extends beyond length of time vector' )
    
else
    % if everything is correct, proceed
    idx = false( length( ts ), 1 ); % allocate idx vector.
    rightTail = find( tInt >= tStart );
    leftTail = find( tInt <= tEnd );
    idx( rightTail( 1 ) : leftTail( end ) ) = true;
    
end



    


% deal with rounding problems derived from non-integer sampling rates
% Fs = 1 / abs( mean( diff( ts ) ) );

% round Fs to the second decimal.
% Fs = ( round( Fs * 100 ) ./ 100 );

% and now get dt
% dt = 1 ./ Fs;
% dt = tInt( 2 ) - tInt( 1 );
% offset = ts( 1 );
% % firstTime = ( epochStart - offset + 1 ) / dt;
% 
% if firstTime < 0.5
%     idxStart = ceil( firstTime );
%     
% else
%     idxStart = round( firstTime );
%     
% end
% nPoints = round( epochLength / dt );
    

