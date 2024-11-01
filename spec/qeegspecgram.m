function [ mf, sef, df ] = qeegspecgram( S, f, fBand )
% QEEGSPECGRAM computes quantitative eeg features from spectrogram
% Usage:
%   [ mf, sef, df ] = qeegspecgram( S, f )
%   [ mf, sef, df ] = qeegspecgram( S, f, fBand )
% 
% Input:
%   S: spectrogram matrix.
%   f: frequency vector.
%   fBand: Optional. Frequency limits to analyze as two-element vector. 
% 
% Output:
%   mf: median frequency. 50th percentile of power concentration.
%   sef: spectral edge. 95th percentile of power concentration.
%   df: dominant frequency. Right now is the peak frequency.

% Cut desired frequncy band.
if nargin == 3
    bandIdx = f > fBand( 1 ) & f < fBand( 2 );
    S = S( :, bandIdx );
    f = f( bandIdx );
    
end

[ m, n ] = size( S );
if m > 1 && n > 1
    dim = 2;
    Ssum = repmat( sum( S, dim ), 1, n );
    
else
    Ssum = sum( S );
    dim = 1;
    
end

Scum = cumsum( S, dim );
Snorm = Scum ./ Ssum;

% median frequency corresponds to the frequency at (nearest to)
% the point on the freq axis where pyy_cum = 0.5
for i = 1 : m
    temp = find( Snorm( i, : ) > 0.5 );
    mf( i, 1 ) = f( temp( 1 ) );
    clear temp
    
end

% spectral edge frequency corresponds to the frequency at (nearest to)
% the point on the freq axis where pyy_cum = 0.05
for i = 1 : m
    temp = find( Snorm( i, : ) > 0.95 );
    sef( i, 1 ) = f( temp( 1 ) );
    clear temp
    
end
 
% you can extend this code for dominant frequency accordingly ... if
% all you mean is the peak frequency then you have
[ dummy, idx ] = max( S, [ ], dim );
df = f( idx )';






