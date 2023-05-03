function plotethogram( states, t, plotLines )
% PLOTETHOGRAM plots an ethogram for any number of states
% 
% Usage:
% hAx = plotethogram( states, t, plotLines )
% 
% Input:
% states: vector with numerical states labels.
% t: timestamps vector. Optional.
% plotLines: boolean flag to whether plot horizontal lines. Optional.
% 
% Output:
% hAx = axes handle


% Check input.
if nargin < 2
    t = 1 : length( states );
    
end

if nargin < 3 
    plotLines = true;
    
end

% % Check if lowest state index is 0.
% if min( states ) == 0
%     warning( 'Adding one to states to match matlab indexing.' )
%     states = states + 1;
%     
% end
% 
% nStates = max( states );
% nPoints = length( states );
% ethogram = zeros( nPoints, nStates );
% for ptsIdx = 1 : nPoints
%     ethogram( ptsIdx, states( ptsIdx ) ) = states( ptsIdx );
%     
% end

ethogram( ethogram == 0 ) = NaN;

% Add fake columns and rows because of stupid pcolor.
dummy = cat( 2, ethogram, nStates * ones( nPoints, 1 ) );
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