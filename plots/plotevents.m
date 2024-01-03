function plotevents( evTs, yLims, kind, color, hAx )
% PLOTEVENTS plot the location of events in a timeseries plot
% 
% Usage:
% plotevents( evTs, yLims, kind )
% 
% Input:
% evTs: timestamps of events to be plotted.
% yLims: y limits for events lines or areas.
% kind: whether to plot as lines or as shades. Lines are better for tf
% charts.


if nargin < 3
    kind = 'lines';

end

if nargin < 4
    color = [ 0.5 0.5 0.5 ];

end

if nargin < 5
    hAx = gca;

end

% Plot events as lines if time-frequency, as patches otherwise.
kind = lower( kind );
switch kind
    case { 'lines', 'line' }
        if isrow( evTs )
            evTs = evTs';

        end
        
        X = evTs * ones( 1, 2 );
        Y = yLims .* ones( length( evTs ), 1 );
        line( hAx, X', Y',...
            'Color', color,...
            'Linewidth', 2 )
        
    case { 'shades', 'shaded', 'shade' }
        if isodd( numel( evTs ) )
            error( 'for shaded plot there must be even number of events' )

        end

        for i = 1 : 2 : length( evTs )
            X = [ evTs( i ), evTs( i ), evTs( i + 1 ), evTs( i + 1 ) ];
            Y = [ yLims( 1 ), yLims( 2 ), yLims( 2 ), yLims( 1 ) ];
            patch( hAx, X, Y, [ 0.5 0.5 0.5 ],...
                'FaceAlpha', 0.3,...
                'EdgeColor', 'none' )
            
        end

end