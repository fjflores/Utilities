function tStamp = interpts( rawTs, buffSize )
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
if nargin == 1
    buffSize = 512; % This is default.
    
end

% Interpolate
nRecs = numel( rawTs );
tsMat = nan( buffSize, nRecs );
for idxRec = 1 : nRecs
    test = ( idxRec + 1 ) <= nRecs;
    if test
        recDur = rawTs( idxRec + 1 ) - rawTs( idxRec ); % in microseconds
        
    else
        recDur = rawTs( idxRec ) - rawTs( idxRec - 1 ); % in microseconds
        
    end
    
    thisStep = round( recDur / buffSize );
    thisOff = linspace( 0, recDur - thisStep, buffSize );
    thisVec = round( rawTs( idxRec ) + thisOff );
    tsMat( :, idxRec ) = thisVec;
    
end

tStamp = tsMat( : );