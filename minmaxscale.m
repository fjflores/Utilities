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
% scaledMat: min-max scaled matrix in column-major form.
% mm: min (1st col) and max (2nd col) for each matrix column.

mm = minmax( origMat' );
scaledMat = ( origMat - mm( :, 1 )' ) ./ ( mm( :, 2 )' - mm( :, 1 )' );