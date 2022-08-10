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

f1 = fBand( 1 );
f2 = fBand( 2 );
idxBand = f >= f1 & f <= f2;
SBand = S( :, idxBand );

switch modeP
    case 'total'
        P = trapz( f( idxBand ), SBand, 2 );
        
    case 'mean'
        P = mean( SBand, 2 );
        
    case 'median'
        P = median( SBand, 2 );
    
    otherwise
        error( 'Not valid mode for computing marginal' )
       
end




