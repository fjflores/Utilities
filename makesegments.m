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
%
% Notes:
% Window and step sample counts are computed with floor(Fs * seconds), so
% non-integer Fs is supported deterministically. Window length is enforced
% to be even by trimming one sample when needed.

% validate user input
if ~isscalar( Fs ) || ~isnumeric( Fs ) || ~isreal( Fs ) || ~isfinite( Fs ) || Fs <= 0
    error( 'Fs must be a finite, real, positive scalar.' )
    
end

if ~isnumeric( movingWin ) || numel( movingWin ) ~= 2 || any( ~isfinite( movingWin ) ) || ...
        any( ~isreal( movingWin ) ) || any( movingWin <= 0 )
    error( 'movingWin must be a finite, real, positive 2-element vector [length step].' )
    
end

% check for matrix input, and linearize if true.
[ ~, n ] = size( signal );
if n > 1
    signal = signal( : );
    
end

N = length( signal );
nWin = floor( Fs * movingWin( 1 ) ); % deterministic sample count for window

% enforce even number of samples per segment
if mod( nWin, 2 ) == 1
    nWin = nWin - 1;
    
end

if nWin < 2
    error( 'Window length is too short. Increase movingWin(1) and/or Fs.' )
    
end

% check signal length to window length. If it is shorter, just return the signal
% and a warning.
if N < nWin
    warning( 'Signal shorter than desired segment. Returning original signal' )
    segments = signal;
    nSegments = 1;
    return
    
end

nStep = floor( movingWin( 2 ) * Fs ); % deterministic sample count for step
if nStep < 1
    error( 'Step length is too short. Increase movingWin(2) and/or Fs.' )
    
end

winStart = 1 : nStep : N - nWin + 1;
nSegments = length( winStart );

segments = nan( nWin, nSegments );
for thisSegment = 1 : nSegments
   idxSegments = winStart( thisSegment ) : winStart( thisSegment ) + nWin - 1;
   segments( :, thisSegment ) = signal( idxSegments );
   
end