function [ off2plot, hPlot ] = plotoffsetsignals( sigMat, offset, t, col )
% PLOTOFFSETSIGNALS spaces the signals withing the same axes.
% 
% Usage
% plotoffsetsignals( sigMat, offset, t, col )
% 
% Input:
% sigMat:   matrix with signals to plot, in column format.
% t:        timestamps vector. Optional. If not supplied, will use indices.
% offset: separation between signals. If not supplied, half maximum value 
% will be used.  
% 
% Output:
% Figure with signals.
% hPlot = handles to each line.

% check user input: matrix of signals
if nargin < 1
    error( 'sigMat argument is required' )

elseif nargin < 2
    offset = max( max( sigMat ) ) / 2;
    [ m, n ] = size( sigMat );
    t = 1 : m;
    col = 'k';
    
elseif nargin < 3
    [ m, n ] = size( sigMat );
    t = 1 : m;
    col = 'k';
    
elseif nargin < 4
    [ m, n ] = size( sigMat );
    col = 'k';
    
else
    col = 'k';

end
    
% make plot
for sigCnt = 1 : n
    off2plot( sigCnt ) = offset * ( sigCnt - 1 );
    hPlot( sigCnt ) = plot(...
        t, sigMat( :, sigCnt ) + off2plot( sigCnt ), 'color', col );
    hold on
    
end
yTicks = 1 : n;
tickPos = off2plot + ( offset ./ 2 );
set( gca, 'YTick', tickPos, 'YTickLabel', yTicks );
axis tight
hold off