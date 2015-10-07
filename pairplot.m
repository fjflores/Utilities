function pairplot( data, med, color2plot )

% PAIRPLOT plots paired data points with trend lines
%
% Usage:
% pairplot( data ) will plot each row of the data matrix paired with any
% other row of data.
% pairplot( data, med ) will also plot the median of each column.
% Input has to be in column format

% check user input
if nargin == 1
    med = false;
    
end

% get rid of nans
nanIdx = isnan( data );
data( nanIdx ) = [ ];

% plot individual data points.
[ m, n ] = size( data );
for i = 1 : m
    plot(...
        [ 1 : n ],...
        data( i, : ),...
        'o-',...
        'markersize', 5,...
        'markerfacecolor', color2plot,...
        'markeredgecolor', color2plot,...
        'color', color2plot )
    hold on
end
xlim( [ 0 n + 1 ] )

% plot median of data points
if med == true
    xhat = median( data );
    plot( 1 : n, xhat,...
        '+-k',...
        'markersize',10)
    
end