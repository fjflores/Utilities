function cleanT = prunetable( T, nanFlag )
%PRUNETABLE eliminates the dangling cells from tables.
% 
% Usage:
% cleanT = prunetable( T );
% 
% Input:
% T: table to prune.
% 
% Output:
% cleanT: pruned table.

missIdx = ismissing( T );
if nanFlag == false || nargin == 1
    remIdx = missIdx;
    
else
    nanIdxTemp = isnan( T{ :, 1 } );
    [ m, n ] = size( missIdx );
    nanIdx = repmat( nanIdxTemp, 1, n );
    remIdx = missIdx | nanIdx;
    
end
cleanT = T( ~all( remIdx, 2 ), ~all( remIdx, 1 ) );