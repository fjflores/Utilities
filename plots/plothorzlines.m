function edges = plothorzlines( tEvents, y );
% PLOTHORZLINES plots lines to mark epochs in time.
% 
% Description:
% It is often desired to visually observe epochs in time-series data. This
% function plots tose epochs as grey lines, at whatever y value inputed.
% 
% Input:
% tEvents: timestamps of the binary events.
% y: y-value at which to plot the lines.
% 
% Output:
% edges:events edges, for posterior use.

% Find the edges fo epochs.
dt = diff( tEvents );
idxChange = find( dt > 0.1 );
edges = tEvents( idxChange - 1 );
y = [ y y ];

% plot wake lines
nEdges = length( edges );
for edgeIdx = 1 : 2 : nEdges - 1
    x = [ edges( edgeIdx ) edges( edgeIdx + 1 ) ];
    disp( x )
    line( x, y,...
    'color', [ 0.5 0.5 0.5 ],...
    'linewidth', 3 )
    
end