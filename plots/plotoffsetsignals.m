function [ off2plot, hPlot ] = plotoffsetsignals( sigMat, offset, t, chLab, col )
% PLOTOFFSETSIGNALS spaces the signals withing the same axes.
% 
% Usage
% plotoffsetsignals( sigMat, offset, t, label, col )
% 
% Input:
%  sigMat: matrix with signals to plot, in column format.
%  offset: separation between signals. If not supplied, half maximum value 
%  t: timestamps vector. Optional. If not supplied, will use indices.
%  will be used.
%  chLab: cell array of strings with channel labels. 
%  col: color to plot channels.
% 
% Output:
% Figure with signals.
% hPlot = handles to each line.

% Check user input: matrix of signals
[ m, n ] = size( sigMat );
if nargin < 2
    offset = max( max( sigMat ) ) / 2;
    t = 1 : m;
    chLab = 1 : n;
    col = 'k';
    
elseif nargin < 3
    t = 1 : m;
    chLab = 1 : n;
    col = 'k';
    
elseif nargin < 4
    chLab = 1 : n;
    col = 'k';
    
elseif nargin < 5
    col = 'k';

end
    
% make plot
for sigCnt = 1 : n
    off2plot( sigCnt ) = offset * ( sigCnt - 1 );
    hPlot( sigCnt ) = plot(...
        t, sigMat( :, sigCnt ) - off2plot( sigCnt ), 'color', col );
    hold on
    
end

% Set tick positions by flipping the offset plot vector.
tickPos = -fliplr( off2plot );
set( gca, 'YTick', tickPos )

% Channel labels have to be flipped left to right too.
chIdx = n : -1 : 1;
for i = 1 : n
   flipLab( i ) =  chLab( chIdx( i ) );
    
end
set( gca, 'YTickLabel', flipLab )
axis tight
hold off