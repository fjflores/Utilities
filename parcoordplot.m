function parcoordplot( data, med, color2plot )

% PAIRPLOT plots paired data points with trend lines
%
% Usage:
% pairplot( data ) 
% pairplot( data, med ) 
% pairplot( data, med, color2plot )
% 
% Input:
% data: data matrix with aleast two columns. required.
% med: Optional boolean flag. True if median is desired. Default: false.
% color2plot: RGB vector with the color to use for plot. Default: grey.
% 
% Output:
% figure with paired plot.

% check user input
if nargin < 1
    error( 'Needs at least one argument' )
    
elseif nargin < 2
    med = false;
    color2plot = [ 0.5 0.5 0.5 ];
    
elseif nargin < 3
    color2plot = [ 0.5 0.5 0.5 ];
    
end

% throw and exception if there are nan's present
if sum( isnan( data ) ) > 0
    error( 'Data cannot contain nan values' )
    
end

% plot individual data points.
[ m, n ] = size( data );

% throw an exception if less than two columns
if n < 2
    error( 'data must have at least two columns' )
    
end

% if everythong ok, plot.
for i = 1 : m
    plot(...
        [ 1 : n ],...
        data( i, : ),...
        'o-',...
        'markersize', 5,...
        'markerfacecolor', color2plot,...
        'markeredgecolor', 'none',...
        'color', color2plot )
    hold on
    
end
xlim( [ 0 n + 1 ] )

% plot median of data points if desired
if med == true
    xhat = median( data );
    plot( 1 : n, xhat,...
        '+-k',...
        'markersize',10)
    
end