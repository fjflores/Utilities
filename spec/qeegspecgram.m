function [ mf, sef, df ] = qeegspecgram( S, f, fBands )
% QEEGSPECGRAM computes quantitative eeg features from spectrogram
% Usage:
%   [ mf, sef, df ] = qeegspecgram( S, f )
%   [ mf, sef, df ] = qeegspecgram( S, f, fBand )
%
% Input:
%   S: spectrogram matrix.
%   f: frequency vector.
%   fBands: Optional. Frequency limits to analyze as n x 2 matrix, where n is the
%   number of frequency bands.
%
% Output:
%   mf: median frequency. 50th percentile of power concentration.
%   sef: spectral edge. 95th percentile of power concentration.
%   df: dominant frequency. Right now is the peak frequency.

[ nBands, ~ ] = size( fBands );
[m, ~] = size( S );
mf  = NaN( m, nBands );
sef = NaN( m, nBands );
df  = NaN( m, nBands );
for bandIdx = 1 : nBands
    fBand = fBands( bandIdx, : );

    % Cut desired frequency band.
    if nargin == 3
        fIdx = f > fBand( 1 ) & f < fBand( 2 );
        SNew = S( :, fIdx );
        fNew = f( fIdx );

    else
        SNew = S;
        fNew = f;
        
    end
    
    [ m, n ] = size( SNew );
    if m > 1 && n > 1
        dim = 2;
        Ssum = repmat( sum( SNew, dim ), 1, n );
        
        
    else
        dim = 1;
        Ssum = sum( SNew );
        
        
    end
    
    Scum = cumsum( SNew, dim );
    Snorm = Scum ./ Ssum;
    
    % median frequency corresponds to the frequency at (nearest to)
    % the point on the freq axis where pyy_cum = 0.5
    for i = 1 : m
        temp = find( Snorm( i, : ) > 0.5 );
        mfTmp( i, 1 ) = fNew( temp( 1 ) );
        clear temp
        
    end
    mf( :, bandIdx ) = mfTmp;
    clear mfTmp

    % spectral edge frequency corresponds to the frequency at (nearest to)
    % the point on the freq axis where pyy_cum = 0.05
    for i = 1 : m
        temp = find( Snorm( i, : ) > 0.95 );
        sefTmp( i, 1 ) = fNew( temp( 1 ) );
        clear temp
        
    end
    sef( :, bandIdx ) = sefTmp;
    clear sefTmp
    
    % you can extend this code for dominant frequency accordingly ... if
    % all you mean is the peak frequency then you have
    [ ~, idx ] = max( SNew, [ ], dim );
    df( :, bandIdx ) = fNew( idx )';
    
end





