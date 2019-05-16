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
specs2plot = sort( randsample( z, nPlots ) );

switch kind
    case 'spec'
        stdFx = @pow2db;
        
    case 'coher'
        stdFx = @atanh;
        
    otherwise
        warning( 'No transformation.' )
        stdFx = @( x ) 1 * x;
        
end
    
% map = flipud( brewermap( 256, 'RdYlBu' ) );
for plotIdx = 1 : nPlots
    subplot( rows, cols, plotIdx )
    thisSpec =  stdFx( squeeze( specMat( :, :, specs2plot( plotIdx ) ) ) );
    imagesc( thisSpec' )
    axis xy
    axis off
%     colormap( map )
    
    ylim = get( gca, 'ylim' );
    xlim = get( gca, 'xlim' );
    msg = sprintf( '%u', specs2plot( plotIdx ) );
    text( xlim( 1 ), ylim( 2 ), msg )

end
