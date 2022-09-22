function P = powerperband( S, f, fBand, modeP )
%POWERPERBAND computes power for a given frequency band f1 to f2.
%
% Usage:
% P = powerperband( spec, f, fBand, modeP )
%
% Input:
% S: time-frequency spectrogram or coheregram.
% f: all frequencies vector.
% fBand: two-element vector with limits of frequency band.
% modeP: how the marginal is computed:
%     'mean': mean power across the frequency band.
%     'total': total power as area under the curve (integral).
%     'median': median power across frequency band.
%
% Output:
% P: power across the frequency band.

nBands = size( fBand, 1 );
for bandIdx = 1 : nBands
    thisBand = fBand( bandIdx, : );
    f1 = thisBand( 1 );
    f2 = thisBand( 2 );
    fIdx = f >= f1 & f <= f2;
    SBand = S( :, fIdx );
    
    switch modeP
        case 'total'
            P( :, bandIdx ) = trapz( f( fIdx ), SBand, 2 );
            
        case 'mean'
            P( :, bandIdx ) = mean( SBand, 2 );
            
        case 'median'
            P( :, bandIdx ) = median( SBand, 2 );
            
        otherwise
            error( 'Not valid mode for computing marginal' )
            
    end
    
end
    
    
