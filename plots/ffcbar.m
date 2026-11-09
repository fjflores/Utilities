function hCbar = ffcbar( hFig, hAx, yLab )
% FFCBAR plots a lean colorbar that tracks the axes plot box.
%
% Description:
% Plots a narrow colorbar to the right of the axes plot box without
% changing the size of the attached axes. The colorbar height always
% matches the visible plot box (including axis square/equal/image), and
% it is re-positioned automatically whenever the axes are redrawn (figure
% resize, limit changes, aspect ratio changes, etc.).
%
% Usage:
% ffcbar
% ffcbar( hFig )
% ffcbar( hFig, hAx )
% ffcbar( hFig, hAx, yLab )
% hCbar = ffcbar( hFig, hAx, yLab )
%
% Input:
% hFig: figure handle. Default: gcf.
% hAx: axes handle. Default: current axes of hFig.
% yLab: Label of colorbar y-axis. Default: empty.
%
% Output:
% hCbar: handle to colorbar.
%
% Shortcomings:
% Orientation is limited to the right side of the axes.
% Plot box computation assumes a 2-D view.
% Not intended for axes inside a tiledlayout.

% Check user input.
if nargin < 1 || isempty( hFig ), hFig = gcf; end
if nargin < 2 || isempty( hAx ),  hAx  = hFig.CurrentAxes; end
if nargin < 3, yLab = ''; end
assert( isa( hFig, 'matlab.ui.Figure' ), 'First argument must be a Figure handle.' )
assert( isa( hAx, 'matlab.graphics.axis.Axes' ), 'Second argument must be an Axes handle.' )

gapPx   = 6;   % gap between plot box and colorbar, in pixels.
widthPx = 8;   % fixed colorbar thickness, in pixels.

% Passing Position (and no Location) sets Location to 'manual', so the
% axes are not resized.
hCbar = colorbar( hAx, 'Units', 'pixels', 'Position', cbarPos() );
hCbar.Label.String = yLab;

% Re-place on every axes redraw (figure resize, axis square, limits, etc.).
lis = addlistener( hAx, 'MarkedClean', @( ~, ~ ) place() );
hCbar.DeleteFcn = @( ~, ~ ) delete( lis );

    function place()
        if ~isvalid( hCbar ) || ~isvalid( hAx ), return; end
        p = cbarPos();
        if any( abs( hCbar.Position - p ) > 0.5 ) % avoid redraw loops.
            hCbar.Position = p;

        end

    end

    function p = cbarPos()
        box = plotBoxPx( hAx );
        p = [ box( 1 ) + box( 3 ) + gapPx, box( 2 ), widthPx, box( 4 ) ];

    end

end


function box = plotBoxPx( hAx )
% Visible plot box in pixels, relative to the axes' parent (2-D views).

box = getpixelposition( hAx );
stretchToFill = strcmp( hAx.DataAspectRatioMode, 'auto' ) && ...
    strcmp( hAx.PlotBoxAspectRatioMode, 'auto' ) && ...
    strcmp( hAx.CameraViewAngleMode, 'auto' );
if stretchToFill, return; end

pbar = hAx.PlotBoxAspectRatio; % kept current by MATLAB even under axis equal.
r = pbar( 1 ) / pbar( 2 ); % width / height of the drawn box.
if box( 3 ) / box( 4 ) > r
    % Box limited by height: centered horizontally.
    wNew = box( 4 ) * r;
    box( 1 ) = box( 1 ) + ( box( 3 ) - wNew ) / 2;
    box( 3 ) = wNew;

else
    % Box limited by width: centered vertically.
    hNew = box( 3 ) / r;
    box( 2 ) = box( 2 ) + ( box( 4 ) - hNew ) / 2;
    box( 4 ) = hNew;

end

end
