function tStamp = interpts( rawTs, buff )
% INTERPTS interpolates the timestamps output from NeuraLynx
%
% Usage:
%   intTs = interpts( rawTs, buffSize )
%
% Input:
% rawTs: Original timestamps vector.
% buff: If single value, size of buffer. If > 1 value, number of valid 
%       samples per record.
%
% Output:
% tStamp: Interpolated timestamps.

% check that input length matches
nRecs = numel( buff );
nTs = numel( rawTs );
if nRecs > 1
    try
        assert( isequal( nTs, nRecs ) )
        
    catch
        error( 'Number of elements must match' )
        
    end
    
else
    buff = ones( 1, nTs ) * buff;
    
end

% Interpolate and accumulate timestamps
tStamp = [];
for idxRec = 1 : nRecs
    test = ( idxRec + 1 ) <= nRecs;
    if test
        recDur = rawTs( idxRec + 1 ) - rawTs( idxRec ); % in microseconds
        
    else
        recDur = rawTs( idxRec ) - rawTs( idxRec - 1 ); % in microseconds
        
    end
    
    thisStep = round( recDur / buff( idxRec ) );
    thisOff = linspace( 0, recDur - thisStep, buff( idxRec ) );
    thisVec = round( rawTs( idxRec ) + thisOff );
    tStamp = cat( 2, tStamp, thisVec );
    
end
