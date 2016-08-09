function cleanT = prunetable( T )
% PRUNETABLE eliminates the dangling cells from tables.
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
cleanT = T( ~all( missIdx, 2 ), ~all( missIdx, 1 ) );