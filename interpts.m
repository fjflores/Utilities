function intTs = interpts( ts, Fs, rel )
% INTERPTS interpolates the timestamps output from DevilLynx
%
% Usage:
% intTs = interpts( ts, Fs, rel )
%
% Input:
% ts:     Original timestamps vector.
% Fs:     Sampling frequency.
% rel:    boolean flag, if true it will substract the first timestamp from
%         all the others, so it will start from zero. Default = false.
%
% Output:   
% intTs: Interpolated timestamps.
% 
% Example:
% ts = [ 0 : 2 : 4 6 ]; % simulate nlynx original timestamps.
% intTS = interpts( ts, 1 ); % Assume 1 Hz sampling frequency.
% The result should be: 0 1 2 3 4 5 6.

% check user input
if nargin == 2
    rel = false;
    
end

% Check if nlynx timestamps have discontinuities.
dTs = diff( ts );
accel = round( diff( dTs ) );
if any( accel )
    warning( 'Ts vector is not monotonically increasing' )
    
end

% generate interpolated timestamps by using vectorization.
firstTs = ts( 1 ); % save first TS to relativize with respect to it
sampleInterval = 1 / Fs;

% check that timestamps are not already interpolated.
if sampleInterval >= dTs
    error( 'Timestamps might be already interpolated' )
    
% else, procedd with with interpolation.
else
    interpSpace = linspace( 0, dTs - sampleInterval, dTs )'; % generate a matrix of 512 x nTs equally spaced points
    tBase = repmat( interpSpace, 1, length( ts ) ); % create base matrix with time intervals
    tsMatrix = repmat( ts, dTs, 1 ); % generate ts reapeated matrix.
    intTs = tBase + tsMatrix; % sum base timestamps with real TS's.
    intTs = intTs( : );
    clear ts
    
    if rel == true
        intTs = intTs - firstTs; % linearizes treal matrix and substract first TS to get relative time
        
    end
    
end
