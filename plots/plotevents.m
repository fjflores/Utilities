function plotevents( evTs, yLims, kind )
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

% Plot events as lines if time-frequency, as patches otherwise.
kind = lower( kind );
switch kind
    case { 'lines', 'line' }
        X = evTs * ones( 1, 2 );
        Y = yLims .* ones( length( evTs ), 1 );
        line( gca, X', Y',...
            'Color', [ 0.5 0.5 0.5 ],...
            'Linewidth', 2 )
        
    case { 'shades', 'shaded', 'shade' }
        if isodd( numel( events ) )
            error( 'for shaded plot there must be even number of events' )

        end

        for i = 1 : 2 : length( evTs )
            X = [ evTs( i ), evTs( i ), evTs( i + 1 ), evTs( i + 1 ) ];
            Y = [ yLims( 1 ), yLims( 2 ), yLims( 2 ), yLims( 1 ) ];
            patch( X, Y, [ 0.5 0.5 0.5 ],...
                'FaceAlpha', 0.3,...
                'EdgeColor', 'none' )
            
        end

end