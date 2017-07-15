function intTs = interpts( ts, Fs, rel, buffSize )
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
    buffSize = 512; % This is default.
    
end

% save first TS to relativize with respect to it
firstTs = ts( 1 );

% Get sample interval, and convert to microseconds.
sampInterv = ( buffSize / Fs ) * 1e6;

% Check if nlynx timestamps have discontinuities.
dTs = diff( ts );
accel = round( diff( dTs ) );
if any( accel )
    warning( 'Ts vector does not increases monotonically. Using loop.' )
    % Allocate matrix with zeros
    tsMat = zeros( length( ts ), buffSize );
    nRecs = length( ts );
    
    for recIdx = 1 : nRecs - 1
        if recIdx < nRecs - 1
            % deal with all records but the last one.
            tmpFirstTs = ts( recIdx );
            tmpLastTs = ts( recIdx + 1 ) - sampInterv;
            tsMat( recIdx, : ) = tmpFirstTs : sampInterv : tmpLastTs;
            
        else
            % Deals with the last record.
            tmpFirstTs = ts( recIdx + 1 ) - sampInterv;
            tmpLastTs = ts( recIdx + 1 ) + ( sampInterv * buffSize );
            tsMat( recIdx + 1, : ) = tmpFirstTs : sampInterv : tmpLastTs;
            
        end
        
    end
    intTs = tsMat( : );
    
else
    disp( 'Ts vector increases monotonically. Using vectorization.' )
    nTs = length( ts ) * buffSize;
    lastTs = ts( end ) + ( sampInterv * buffSize );
    intTs = firstTs : sampInterv : lastTS;
    
end
