function [ segments, nSegments ] = makesegments( signal, Fs, movingWin )
%MAKESEGMENTS reshapes the signal into segments of desired lengths
% 
% makesegments break down signal in the desired time steps, with overlap 
% if desired.
% 
% Usage:
% segments = makesegments( signal, Fs, movingWin );
% [ segments, nSegments ] = makesegments( signal, Fs, movingWin )
% 
% Input:
% signal: timeseries vector to be segmented, in samples x channels.
% Fs: sampling frequency.
% movingWin: 2-element vector with elements [ length step ], in secs if Fs 
% is in Hz.
% 
% Output:
% segments: matrix in samples per window x number of segments;
% nSegments: number of segments. Useful to preallocate matrices.

% check for matrix input, and linearize if true.
[ ~, n ] = size( signal );
if n > 1
    signal = signal( : );
    
end

N = length( signal );
nWin = round( Fs * movingWin( 1 ) ); % number of samples in window

% check signal length to window length. If it is shorter, just return the signal
% and a warning.
if N < nWin
    warning( 'Signal shorter than desired segment. Returning original signal' )
    segments = signal;
    return
    
end

nStep = round( movingWin( 2 ) * Fs ); % number of samples to step through
winStart = 1 : nStep : N - nWin + 1;
nSegments = length( winStart );

for thisSegment = 1 : nSegments;
   idxSegments = winStart( thisSegment ) : winStart( thisSegment ) + nWin - 1;
   segments( :, thisSegment ) = signal( idxSegments );
   
end