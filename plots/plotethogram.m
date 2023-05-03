function plotethogram( ethoMat, t, plotLines )
% PLOTETHOGRAM plots an ethogram for any number of states
% 
% Usage:
% hAx = plotethogram( states, t, plotLines )
% 
% Input:
% ethoMat: matrix with state labels in timepoints x # of states format.
% t: timestamps vector. Optional.
% plotLines: boolean flag to whether plot horizontal lines. Optional.


% Check input.
nPoints = size( ethoMat, 1 );
if nargin < 2
    t = 1 : nPoints;
    
end

if nargin < 3 
    plotLines = true;
    
end

% Plot
nStates = size( ethoMat, 2 );
ethoMat( ethoMat == 0 ) = NaN;

% Add fake columns and rows because of stupid pcolor.
dummy = cat( 2, ethoMat, nStates * ones( nPoints, 1 ) );
pcolEtho = cat( 1, dummy, nStates * ones( 1, nStates + 1 ) );

% hAx = axes;
t2plot = [ t t(end) + mean( diff( t ) ) ];
states2plot = 1 : nStates + 1;
pcolor( t2plot, states2plot, pcolEtho' );
shading flat
caxis( [ 1 nStates ] )
hold on
axis xy
box off
set( gca,...
    'YTick', ( 1 : nStates ) + 0.5,...
    'YTickLabels', 1 : nStates,...
    'TickDir', 'out' )

if plotLines
    for i = 1 : nStates
        plot( [ 0 t( end ) ], double( i ) + zeros( 1, 2 ),...
            'Color', [ 0.8 0.8 0.8 ], 'Linewidth', 0.1 )
        
    end

end