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

% save first TS to relativize with respect to it
firstTs = ts( 1 );

% Get sample interval, and convert to microseconds.
sampleInterval = 1 / Fs * 1e6;

% Check if nlynx timestamps have discontinuities.
dTs = diff( ts );
accel = round( diff( dTs ) );
if any( accel )
    warning( 'Ts vector does not increases monotonically. Using loop.' )
    % Allocate matrix with zeros
    tsMat = zeros( length( ts ), 512 );
    for i = 2 : length( ts )
        tsMat( i, : ) = linspace( ts( i - 1 ), ts( i ) - sampleInterval, 512 );
        
    end
    intTs = tsMat( : );
    
else
    disp( 'Ts vector increases monotonically. Using vectorization.' )
    nTs = length( ts ) * 512;
    intTs = linspace(...
        ts( 1 ), ts( end ) + sampleInterval * 512, nTs ) * sampleInterval;
    
end
