function indices = getepochidx( ts, epochStart, dur )

%GETEPOCHIDX get the indexes for a given epoch (with ms precision).
% 
% Usage:
% idx = getepochidx( ts, epochStart, epochLength )
% 
% Input:
% ts: timestamps vector
% epochStart: time at which to start the epoch.
% epochlength: length of the epoch to extract.
% Fs: if provided, overrides the internal Fs calc.
% Note that the units have to be consistent.
% 
% Output:
% idx = logical vector of the same length as ts. It has ones in the
% positions of the desired epoch to extract.

% convert time values to integers, rounded to microseconds resolution.
% tInt = round( ts .* 1e9 );
% tStart = round( epochStart * 1e9 );
epochEnd = epochStart + dur;

% if nargin < 4
%     Fs = mean( 1 ./ diff( ts ) );
% 
% end
% nSamps = floor( dur * Fs );

% Check that firs time point is less or equal than startTime
if epochStart < ts( 1 )
    error( 'Epoch start time is lesser than the first timestamp' )
    
elseif epochEnd > ts( end )
    error( 'Epoch extends beyond length of time vector' )
    
else
    % if everything is correct, proceed
    % idx = false( length( ts ), 1 ); % allocate idx vector.
    % rightTail = find( ts >= epochStart );
    % leftTail = find( ts < epochEnd );
    
    % Make sure that output is always even in length.
    % if isodd( length( leftTail ) )
    %     leftTail = find( tInt <= tEnd );
    % 
    % end
    % idx( rightTail( 1 ) : leftTail( end ) ) = true;
    % tmpIdx = rightTail( 1 ) : leftTail( end );
    indices = find( ts >= epochStart & ts < epochEnd );
    
end

% try
%     indices = tmpIdx( 1 : nSamps );
% 
% catch
%     indices = tmpIdx( 1 : nSamps + 1 );
% 
% end


% Ensure vector 'idx' has even length
if mod( length( indices ), 2 ) ~= 0
    indices( end ) = []; % Remove last element to make it even

end