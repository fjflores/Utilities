function tStamp = interpts( rawTs, buff )
% INTERPTS interpolates the timestamps output from NeuraLynx
%
% Usage:
%   intTs = interpts( rawTs, buffSize )
%
% Input:
%   rawTs: Original timestamps vector.
%   buffSize: Size of record (buffer). Typically 512 (default).
%
%
% Output:
% tStamp: Interpolated timestamps.

% check user input
% if nargin == 1
%     buff = 512; % This is default.
%
% end

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

% Interpolate and accumualte timestamps
% tStamp = nan( 1, sum( buff ) );
tStamp = [];
% tsMat = nan( buff, nRecs );
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
    %     tsMat( :, idxRec ) = thisVec;
    tStamp = cat( 2, tStamp, thisVec );
    
end

% tStamp = tsMat( : );