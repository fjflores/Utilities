function hAx = plotmultispec( specMat, rows, cols, trans )
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
nSpecs = size( specMat, 3 );
if nSpecs > nPlots
    warning(...
        'More spectrograms than plots. Plotting only first %u\n', nPlots )
    specMat = specMat( :, :, 1 : nPlots );
    nSpecs = nPlots;
    
end

% Define standardization fx.
switch trans
    case 'spec'
        stdFx = @( x ) 10 * log10( x );
        barLab = 'power (db)';
        
    case 'coher'
        stdFx = @atanh;
        barLab = 'z-coherence (au)';
        
    otherwise
        warning( 'No transformation.' )
        stdFx = @( x ) 1 * x;
        barLab = 'N/A';
        
end

for plotIdx = 1 : nSpecs
    hAx( plotIdx ) = subplot( rows, cols, plotIdx );
    thisSpec =  squeeze( specMat( :, :, plotIdx ) );
    spec2plot = stdFx( thisSpec );
    allLims( plotIdx, 1 : 2 ) = prctile( spec2plot( : ), [ 5 99 ] );
    imagesc( spec2plot' );
    axis xy
    axis off
    colormap( magma )
    
    ylim = get( gca, 'ylim' );
    xlim = get( gca, 'xlim' );
    
    posX = xlim( 1 ) + xlim( 2 ) * 0.025;
    posY = ylim( 2 ) - ylim( 2 ) * 0.05;
    
    msg = sprintf( '%u', plotIdx );
    text( posX, posY, msg, 'Color', 'w', 'FontWeight', 'bold' )
    
    if plotIdx == nSpecs
        ffcbar( gcf, gca, barLab );
        
    end
    
end

globalCLim = [ min( allLims( :, 1 ) ) max( allLims( :, 2 ) ) ];
for i = 1 : nSpecs
    caxis( hAx( i ), globalCLim );
    
end
