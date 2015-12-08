function hPlot = plotoffsetsignals( t, sigMat, offset )
% PLOTOFFSETSIGNALS spaces the signals withing the same axes.
% 
% Usage
% plotoffsetsignals( t, sigMat )
% 
% Input:
% t:        timestamps vector.
% sigMat:   matrix with signals to plot, in column format.
% 
% Output:
% Figure with signals.
% hPlot = handles to each line.

% get size of signal matrix.
[ m, n ] = size( sigMat );

for sigCnt = 1 : n
    hPlot( sigCnt ) = plot(...
        t, sigMat( :, sigCnt ) - offset * ( sigCnt - 1 ), 'color', 'k' );
    hold on
    
end
