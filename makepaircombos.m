function combos = makepaircombos( nElements )
% MAKEPAIRCOMBOS creates a matrix with non-repeating pairwise combinations.
% 
% Usage:
% combos = makepaircombos( nElements )
% 
% Matlab provides the nchoosek function that will do the same.
% 
% Input:
% nElements: number of elements in the combiantion vector.
% 
% Output:
% combos = all pairwise non-repeating combinations up to nElements.


[ X, Y ] = meshgrid( 1 : nElements, 1 : nElements );
rawCombos = [ X( : ) Y( : ) ];

repIdx = logical( X( : ) - Y( : ) );

nonRepCombos = [ X( repIdx ) Y( repIdx ) ];

mirrorIdx = diff( nonRepCombos, 1, 2 ) < 0
combos = nonRepCombos( ~mirrorIdx, : );