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
% Name-value pairs:
%   Transform: transformation to apply. 'spec' for power, 'coher'
%   for atanh, 'wavemag' for wavelet abs, 'wavepow' for wavelet
%   abs squared, and 'none' for none.
%
%   Labels: cell array text to display in the top left corner of the chart,
%   Default is the index of eafh tf chart.
%
%   PlotMap: vector with the same length as rows * cols, which dictates the
%   subplot in which tf charts should appear in the figure. If zero, then
%   that position is skipped.
% 
%   ColorScale: 'global' sets the same color scale for all the plots.
%   'local' keeps each plot to its own colorscale.
%
%
% Output:
% Figure with a montage of time-frequency charts and axes handles for each
% subplot.

% set up name-value pairs
transform = 'none';
colorScale = 'global';
nCharts = size( specMat, 3 );
labels = vec2cell( 1 : nCharts );
plotMap = 1 : nCharts;
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

        case "barlab"
            barLab = values{ k };

        case "plotmap"
            plotMap = values{ k };

        case "colorscale"
            colorScale = values{ k };

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
        barLab = 'Power (dB)';

    case 'coher'
        stdFx = @atanh;
        barLab = 'atanh^{-1} (a.u.)';

    case 'wavemag'
        specMat = permute( specMat, [ 2 1 3 ] );
        stdFx = @( x ) abs( x );
        barLab = 'Amp. (\muV)';

    case 'wavepow'
        specMat = permute( specMat, [ 2 1 3 ] );
        stdFx = @( x ) abs( x ) .^ 2;
        barLab = 'Power (\muV ^{2})';

    otherwise
        stdFx = @( x ) 1 * x;
        barLab = 'N/A';

end


gap = [ 0.01 0.01 ];
cnt = 1;
if ~iscell( labels )
    lab2 = vec2cell( labels );
    clear labels
    labels = lab2;

end

for plotIdx = 1 : nPlots
    thisTf = plotMap( plotIdx );

    if thisTf > 0
        hAx( cnt ) = subtightplot( rows, cols, plotIdx, gap );
        thisSpec =  squeeze( specMat( :, :, thisTf ) );
        spec2plot = stdFx( thisSpec );
        allLims( cnt, 1 : 2 ) = prctile( spec2plot( : ), [ 5 99 ] );
        imagesc( t, f, spec2plot' );
        axis xy
        axis off

        ylim = get( gca, 'ylim' );
        xlim = get( gca, 'xlim' );

        posX = xlim( 1 ) + xlim( 2 ) * 0.025;
        posY = ylim( 2 ) - ylim( 2 ) * 0.05;

        msg = sprintf( '%s', num2str( labels{ cnt } ) );
        text( posX, posY, msg, 'Color', 'w', 'FontWeight', 'bold' )

        if cnt == 1
            axis on
            set( hAx( cnt ),...
                'XTickLabel', {} )
            ylabel( 'Freq. (Hz)', 'Parent', hAx( cnt ) )
            box off

        end

        if cnt == nSpecs
            if strcmp( colorScale, 'global' )
                ffcbar( gcf, gca, barLab );

            end
            
            axis on
            set( hAx( cnt ), ...
                'YTickLabel', {} )
            xlabel( 'Time (s)', 'Parent', hAx( cnt ) )
            box off

        end

        if plotIdx < nPlots
            cnt = cnt + 1;

        end

    end

end


if strcmp( colorScale, 'global' )
    globalCLim = [ min( allLims( :, 1 ) ) max( allLims( :, 2 ) ) ];

    for i = 1 : cnt
        caxis( hAx( i ), globalCLim );

    end

end

% HELPER FUNCTION TO CONVERT VECTORS TO CELL
function labs = vec2cell( vec )

n = length( vec );
for i = 1 : n
    labs{ i } = vec( i );

end
