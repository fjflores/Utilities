function hPlot = plotoffsetsignals( sigMat, offset, t )
% PLOTOFFSETSIGNALS spaces the signals withing the same axes.
% 
% Usage
% plotoffsetsignals( t, sigMat )
% 
% Input:
% sigMat:   matrix with signals to plot, in column format.
% t:        timestamps vector. Optional. If not supplied, will uses
% indices.
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
    
elseif nargin < 3
    [ m, n ] = size( sigMat );
    t = 1 : m;

end
    
% make plot
for sigCnt = 1 : n
    hPlot( sigCnt ) = plot(...
        t, sigMat( :, sigCnt ) - offset * ( sigCnt - 1 ), 'color', 'k' );
    hold on
    
end
axis tight