function hAx = plotmultitf( t, f, specMat, dims, varargin )
% PLOTMULTITF makes a figure with multiple timefrequency charts.
%
% Usage:
% plotmultitf( t, f, specMat, dims )
% plotmultitf( t, f, specMat, dims, Name, Value )
%
% The function assumes that all the time-frequency charts have the same
% size.
% 
% Input:
% t: timestamps vector for x-axis.
% f: frequency vector for y-axis.
% specMat: tensor with freqs x times x charts.
% dims: two-element vector with [ rows cols ] for subplot.
% transform: transformation to apply. 'spec' for 10*log10, 'coher' 
% for atanh. 'none' for none.
% labels: cell array text to display in the top left corner of the chart, 
% identifying it to the general public.
%
% Output:
% figure with a montage of time-frequency charts.

% set up name-value pairs
transform = 'none';

nCharts = size( specMat, 3 );
for i = 1 : nCharts
    labels{ i } = i;

end
clear i

% Parse  name-value pairs
names = lower( varargin( 1 : 2 : end ) );
values = varargin( 2 : 2 : end );
for k = 1 : numel( names )
    switch lower( names{ k } )
        case "transform"
            transform = values{ k };
            
        case "labels"
            labels = values{ k };
            
        otherwise
            error( '''%s'' is not a valid Name for Name, Value pairs.',...
                names{ k } )
            
    end
    
end

% Check input correctness.
rows = dims( 1 );
cols = dims( 2 );
nPlots = rows * cols;
nSpecs = size( specMat, 3 );
if nSpecs > nPlots
    warning(...
        'More spectrograms than plots. Plotting only first %u\n', nPlots )
    specMat = specMat( :, :, 1 : nPlots );
    nSpecs = nPlots;
    
end

% Define standardization fx.
switch transform
    case 'spec'
        stdFx = @( x ) 10 * log10( x );
        barLab = 'power (db)';
        
    case 'coher'
        stdFx = @atanh;
        barLab = 'z-coherence (au)';
        
    otherwise
        stdFx = @( x ) 1 * x;
        barLab = 'N/A';
        
end


gap = [ 0.01 0.01 ];
for plotIdx = 1 : nSpecs
    hAx( plotIdx ) = subtightplot( rows, cols, plotIdx, gap );
    thisSpec =  squeeze( specMat( :, :, plotIdx ) );
    spec2plot = stdFx( thisSpec );
    allLims( plotIdx, 1 : 2 ) = prctile( spec2plot( : ), [ 5 99 ] );
    imagesc( t, f, spec2plot' );
    axis xy
    axis off
    colormap( magma )
    
    ylim = get( gca, 'ylim' );
    xlim = get( gca, 'xlim' );
    
    posX = xlim( 1 ) + xlim( 2 ) * 0.025;
    posY = ylim( 2 ) - ylim( 2 ) * 0.05;
    
    msg = sprintf( '%s', num2str( labels{ plotIdx } ) );
    text( posX, posY, msg, 'Color', 'w', 'FontWeight', 'bold' )
    
    if plotIdx == 1
        axis on
        set( hAx( plotIdx ), 'XTickLabel', {} )
        box off

    end

    if plotIdx == nSpecs
        ffcbar( gcf, gca, barLab );
        axis on
        set( hAx( plotIdx ), 'YTickLabel', {} )
        box off

    end
    
end

globalCLim = [ min( allLims( :, 1 ) ) max( allLims( :, 2 ) ) ];
for i = 1 : nSpecs
    caxis( hAx( i ), globalCLim );
    
end
