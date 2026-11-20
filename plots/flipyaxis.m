function flipyaxis( ax )
% FLIPYAXIS flips the y axis direction of an existing plot.
%
% Description:
% In electrophysiology, positive deflections of EEG or LFP traces are
% conventionally plotted downwards. This function reverses the direction of
% the y axis so that positive values lie below zero and negative values
% above it. The data and the tick labels are untouched, only the axis
% direction changes, so the numerical values keep their true sign. Calling
% the function again restores the original orientation.
%
% Usage:
% flipyaxis
% flipyaxis( ax )
%
% Input:
% ax: (optional) handle(s) to axes. Default is the current axes ( gca ).
% Axes with two y sides ( yyaxis ) are flipped on both sides.
%
% Output:
% None. The y axis direction will change in the figure.

if nargin < 1
    ax = gca;
end

for i = 1 : numel( ax )
    if ~isa( ax( i ), 'matlab.graphics.axis.Axes' )
        warning( 'object %d is not an axes.', i )
        continue

    end

    % Toggle every y ruler, so that yyaxis plots flip on both sides.
    for j = 1 : numel( ax( i ).YAxis )
        if strcmp( ax( i ).YAxis( j ).Direction, 'normal' )
            ax( i ).YAxis( j ).Direction = 'reverse';

        else
            ax( i ).YAxis( j ).Direction = 'normal';

        end

    end

end
