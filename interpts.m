function intTs = interpts( ts, Fs, rel )

% INTERPTS interpolates the timestamps output from DevilLynx
%
% USAGE:
% intTs = interpts( ts, Fs, rel )
%
% INPUT:    Ts:     Original timestamps vector.
%           Fs:     Sampling frequency.
%           rel:    boolean flag, if true it will substract the first timestamp from
%                   all the others, so it will start from zero. Default = 0
%
% OUTPUT:   intTs: Interpolated timestamps.
%
% (C) Francisco J. Flores 2010-May-12


% check user input
if nargin == 2
    rel = false;
    
end

% generat interpolated timestamps by using vectorization.
firstTs = ts( 1 ); % save first TS to relativize with respect to it
dTs = diff( ts( 1 : 2 ) ); % get interval between record TS.
sampleInterval = 1 / Fs;

% check that timestamps are not already interpolated.
if sampleInterval >= dTs
    error( 'Timestamps might be already interpolated' )
    
% else, procedd with with interpolation.
else
    interpSpace = linspace( 0, dTs - sampleInterval, 512 )'; % generate a matrix of 512 x nTs equally spaced points
    tBase = repmat( interpSpace, 1, length( ts ) ); % create base matrix with time intervals
    tsMatrix = repmat( ts, 512, 1 ); % generate ts reapeated matrix.
    intTs = tBase + tsMatrix; % sum base timestamps with real TS's.
    intTs = intTs( : );
    clear ts
    
    if rel == true
        intTs = intTs - firstTs; % linearizes treal matrix and substract first TS to get relative time
        
    end
    
end
