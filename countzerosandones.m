function [ lgtChunkOnes, lgtChunkZeros, startIdxOnes, endIdxOnes, startIdxZeros, endIdxZeros ] = countzerosandones( vec )
% COUNTZEROSANDONES

if ~islogical( vec )
    warning( 'Vector must be a logical vector. Converting. ' )
    vec = logical( vec );
end
    

startIdxOnes = find( diff( [ 0; vec ] ) == 1 );
endIdxOnes = find( diff( [ vec; 0 ] ) == -1 );
lgtChunkOnes = endIdxOnes - startIdxOnes + 1;

startIdxZeros = find( diff( [ 0; ~vec ] ) == 1 );
endIdxZeros = find( diff( [ ~vec; 0 ] ) == -1 );
lgtChunkZeros = endIdxZeros - startIdxZeros + 1;