function hCbar = ffcbar( hFig, hAx, yLab )
% FFCBAR plots the colorbar in a more useful location with label.
%
% Description:
% Plots a colorbar that does not changes the size of the attached axes.
%
% Usage:
% ffcbar
% ffcbar( hFig )
% ffcbar( hFig, hAx )
% ffcbar( hFig, hAx, yLab )
% hCbar = ffcbar( hFig, hAx, yLab )
%
% Input:
% hFig: figure handle.
% hAx: axes handle.
% yLab: Label of colorbar y-axis.
%
% Output:
% hCbar: handle to colorbar.
%
% Shortcomnings:
% Orientation is limited to 'EastOutside'.

% Check user input.
if nargin == 0
    hFig = gcf;
    hAx = gca;
    yLab = {};
    flagLabel = false;
    
elseif nargin == 1
    if strcmp( class( hFig ), 'matlab.ui.Figure' )
        hAx = gca;
        yLab = {};
        flagLabel = false;
        
    else
        error( 'First argument must be a Figure handle.' )
        
    end
    
elseif nargin == 2
    if strcmp( class( hAx ), 'matlab.graphics.axis.Axes' )
        yLab = {};
        flagLabel = false;
        
    else
        error( 'Second argument must be an Axes handle.' )
        
    end
    
else
    flagLabel = true;
    
end

% Get axis position. The 2nd and 4th element are the necessary ones.
set( hFig, 'Units', 'Normalized' );
set( hAx, 'Units', 'Normalized' );

% Get standard axes position
axPos = hAx.Position;
left = axPos( 1 );
bott = axPos( 2 );
w = axPos( 3 );
h = axPos( 4 );

% Checck for axis square and update positions
if sum( hAx.PlotBoxAspectRatio ) == 3
    %     if height is greater than width
    if h > w
        left = left + w + 0.01; % place the cbar an epsilon beyond the axes.
        bott = bott + ( h - w ) / 2;
        h = w;
        
    elseif w > h
        left = left + ( w - ( 1.9 * h ) ) + 0.01; % place the cbar an epsilon beyond the axes.
        
    end
    
else
    % normal case
    left = left + w + 0.01;
    
end

% Create colorbar at those positions.
w = 0.0084; % fixed, narrow width.
cBarPos = [ left bott w h ];
hCbar = colorbar(...
    'Units', 'Normalized',...
    'Position', cBarPos,...
    'Location', 'EastOutside' );

if flagLabel
    hCbar.Label.String = yLab;
    
end





