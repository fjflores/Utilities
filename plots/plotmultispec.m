function plotmultispec( specMat, rows, cols, kind, specsIdx )
% PLOTMULTISPEC makes a figure with multiple spectra/coherence.
%
% Usage:
% plotmultispec( specMat, rows, cols, kind )
%
% Input:
% specMat: tensor with freqs x times x trials/events.
% rows: number of rows to plot.
% cols: number of columsn to plot.
% kind: defines the data transformation.
% specIdx: indices of specs to plot. Length must be equal to rows x cols.
%
% Output:
% figure with spectrograms or coheregrams.

% Check input correcteness.
nPlots = rows * cols;
if exist( 'specsIdx', 'var' ) ~= 1
    disp(...
        sprintf( 'No idx provided.\n Plotting %u random plots.', nPlots ) )
    [ ~, ~, z ] = size( specMat );
    specsIdx = sort( randsample( z, nPlots ) );
    
end
nIdx = length( specsIdx );
assert( nIdx <= nPlots )

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

for plotIdx = 1 : nIdx
    subplot( rows, cols, plotIdx )
    thisSpec =  squeeze( specs2plot( :, :, plotIdx ) );
    imagesc( thisSpec' )
    axis xy
    axis off
    caxis( cLim );
    colormap( magma )
    
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

