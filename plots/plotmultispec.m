function plotmultispec( specMat, rows, cols, kind )
% PLOTMULTISPEC makes a figure with multiple spectra/coherence.
% 
% Usage:
% plotmultispec( specMat, rows, cols, kind )
% 
% Input:
% 

[ m, n, z ] = size( specMat );

nPlots = rows * cols;
specsIdx = sort( randsample( z, nPlots ) );

% Define standardization fx.
switch kind
    case 'spec'
        stdFx = @pow2db;
        barLab = 'power (db)';
        
    case 'coher'
        stdFx = @atanh;
        barLab = 'z-coherence (au)';
        
    otherwise
        warning( 'No transformation.' )
        stdFx = @( x ) 1 * x;
        barLab = 'N/A';
        
end
    
specs2plot = stdFx( specMat( :, :, specsIdx ) );
clear specMat
cLim = prctile( specs2plot( : ), [ 5 99 ] );

for plotIdx = 1 : nPlots
    subplot( rows, cols, plotIdx )
    thisSpec =  squeeze( specs2plot( :, :, plotIdx ) );
    imagesc( thisSpec' )
    axis xy
    axis off
    caxis( cLim );
    colormap( viridis )
    
    ylim = get( gca, 'ylim' );
    xlim = get( gca, 'xlim' );
    
    posX = xlim( 1 ) + xlim( 2 ) * 0.025;
    posY = ylim( 2 ) - ylim( 2 ) * 0.1;
    
    msg = sprintf( '%u', specsIdx( plotIdx ) );
    text( posX, posY, msg, 'Color', 'w', 'FontWeight', 'bold' )
    
    if plotIdx == nPlots
        ffcbar( gcf, gca, barLab );
        
    end

end
