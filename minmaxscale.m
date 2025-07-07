function [ scaledMat, mm ] = minmaxscale( origMat )
% MINMAXSCALE returns the minmax scaled matrix and the min and max values.
% 
% Usage:
% [ scaledMat, mm ] = minmaxscaling( origMat )
% 
% Input:
% origMat: matrix in column-major form.
% 
% Output:
% sacaledMat: min-max scaled matrix in column-major form.
% mm: min (1st col) and max (2nd col) for each matrix column.

% minVals = min( origMat );
% maxVals = max( origMat );
% scaledMat = ( origMat - minVals ) ./ ( maxVals - minVals );
mm = minmax( origMat' );
scaledMat = ( origMat - mm( :, 1 )' ) ./ ( mm( :, 2 )' - mm( :, 1 )' );