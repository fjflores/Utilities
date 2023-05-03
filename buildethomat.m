function ethoMat = buildethomat( states )
% BUILDETHOMAT creates an ethogram matrix for analysis and plotting.
% 
% Usage:
% ethoMat = buildethomat( states )
% 
% The vector of states it is easier to plot and analyze when put into a
% matrix format.
% 
% Input:
% states: vector with state per time point. States must be coded with
% integer numbers. E.g.: [ 1 1 1 2 2 1 1 3 3  ] represents three states
% occurring in 9 consecutive timepoints.
% 
% Output:
% ethoMat: states represented in matrix form, where rows are timepoints and
% columns are the (mutually exclusive) state codes. The timepoints in a 
% column where that state is not present are filled with zeros.


% Check if lowest state index is 0.
if min( states ) == 0
    warning( 'Adding one to states to match matlab indexing.' )
    states = states + 1;
    
end

nStates = max( states );
nPoints = length( states );
ethoMat = zeros( nPoints, nStates );
for ptsIdx = 1 : nPoints
    ethoMat( ptsIdx, states( ptsIdx ) ) = states( ptsIdx );
    
end