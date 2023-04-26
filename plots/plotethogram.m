function hAx = plotethogram( states, t )

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

hAx = imagesc( t, 0 : nStates, ethogram' );
% colormap( cc )
caxis( [ 0 nStates ] )
hold on
axis xy
% for i = 0 : nStates
%     plot( [ 0 t( end ) ], double( i ) - 0.5 + zeros( 1, 2 ), 'k-' )
%     
% end