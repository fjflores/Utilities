function plotbandtimecourse( bandtc, S, t, f, yLims )
%PLOTBANDTIMECOURSE plots markers for band presence on the spectrogram.
% 
% Usage:
% plotbandtimecourse( bandtc, S, t, f, yLims )
% 
% Input:
% bandtc: structure with band time-course output.
% S: Spectrogram.
% t: time.
% f: frequency.
% yLims: limits to plot the spectrogram.
% 
% Output:
% A plot with spectrogram and white lines where the band was detected.

% Get yLims if they exist.
if exist( "yLims", "var" )
    if yLims( 2 ) > f( end )
        fIdx = f > yLims( 1 );

    else
        fIdx = f > yLims( 1 ) & f < yLims( 2 );

    end
    f = f( fIdx );
    S = S( :, fIdx );

end

imagesc( t, f, pow2db( S' ) )
axis xy
colormap( magma )
caxis( [ 0 30 ] )
hold on
tDelta = t( logical( bandtc.deltaCleanIdx ) );
plot( tDelta, yLims( 2 ) - 2, '_w', "LineWidth", 4 )
box off