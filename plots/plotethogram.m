function hAx = plotethogram( states, t, plotLines )

% zValues = combineCells(embVals);
% N = length( states( :, 1 ) );

% [s,v,obj,pRest] = findWatershedRegions(zValues,xx,LL,[],[],[]);

nStates = max( states );
nPoints = length( states );
ethogram = zeros( nPoints, nStates + 1 );
for ptsIdx = 1 : nPoints
    ethogram( ptsIdx, states( ptsIdx ) + 1 ) = states( ptsIdx );
    
end

if nargin < 2
    t = 1 : length( states );
    
end

hAx = axes;
imagesc( t, 0 : nStates, ethogram' );
% colormap( cc )
caxis( [ 0 nStates ] )
hold on
axis xy
box off
set( hAx, 'YTick', unique( states ) )

if nargin < 3 
    plotLines = true;
    
end

if plotLines
    for i = 0 : nStates
        plot( [ 0 t( end ) ], double( i ) - 0.5 + zeros( 1, 2 ),...
            'Color', [ 0.8 0.8 0.8 ], 'Linewidth', 0.1 )
        
    end

end