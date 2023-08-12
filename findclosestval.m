function closestVal = findclosestval( ts, reference, pos )
% FINDCLOSESTVAL finds closest values to another in an timestamps vector
%
% Usage:
% closestVals = findclosestval( ts, target )
%
% The intended use case is when you have a timeseries sampled at Fs1, and a 
% discrete event that occurs in continuous time sampled at Fs2, where Fs2 >
% Fs1, and need to find the closest value in ts to the event.
% 
% Input:
% ts: ordered timeseries, typically timestamps.
% reference: value that we need to find the closest in the time series.
% pos: whther to return the preceding or following closest value.
%
% Output:
% closestVals: preceding and succeding values to the reference. If the
% reference value actually exists in time series (within eps) then it is
% returned.

% Check that there are sorted and ascending, and that there are no repeated
% values
if ~issorted( ts, 'strictascend' )
    error( 'timestamps are not monotonically ascending' )

end

% Base case: the reference value actually exist in the timeseries.
baseCase = ts( ts == reference );
if ~isempty( baseCase ) && numel( baseCase ) == 1
    closestVal = baseCase;
    return

end

% Actually find closest values
dt = mean( diff( ts ) );
vals = ts(ts > reference - dt & ts < reference + dt);
switch pos
    case 'preceding'
        closestVal = vals( 1 );

    case 'following'
        closestVal = vals( 2 );

    otherwise
        error( 'Couldn''t find the closest value. Check inputs' )

end


