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

% Check user input.
if nargin == 0
    hFig = gcf;
    hAx = gca;
    yLab = {};
    flagLabel = false;
    
elseif nargin == 1
    if strcmp( class( hAx ), 'matlab.ui.Figure' )
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
axPos = hAx.Position;

% Create colorbar at those positions.
cBarPos = [ 0.9111 axPos( 2 ) 0.0084 axPos( 4 ) ];
hCbar = colorbar( 'Units', 'Normalized', 'Position', cBarPos );

if flagLabel
    hCbar.Label.String = yLab;

end



    

