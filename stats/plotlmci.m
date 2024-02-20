function [ yFit, ci ] = getlmci( mdl, X )
%  GETLMCI obtains studentized confidence intervals for a lm object.
% 
% Usage:
% [ yFit, ci ] = getlmci( mdl, X )
% 
% Input:
% mdl: LinearModel object from fitlm function.
% X: design matrix.
% 
% Output:
% yFit: linear fit to data.
% ci: upper and lower studentized confidence intervals.


x = sort( X( :, 2 ) ); % assumes a single predictor
coefs = mdl.Coefficients{ :, 1 };
yFit = X * coefs; % get fit
wts = ones( size( x ) );
n = length( x );
sumw = sum( wts );
mse = mdl.MSE;
[ ~, R ] = qr( X, 0 );
E = [ ones( size( x ) ), x ] / R;
alpha = 0.05;
dy = -tinv( alpha / 2, mdl.DFE ) * sqrt( sum( E .^ 2, 2 ) * mse );

% Compute fitted line and bounds on this grid
upper = yFit + dy;
lower = yFit - dy;

ci = [ upper lower ];

