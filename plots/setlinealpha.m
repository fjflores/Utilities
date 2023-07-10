function setlinealpha( hLine, alphaVal )
% SETLINEALPHA adds an alpha value to line plots
%
% Matlab does not natively allow to set transparency (alpha) values for
% lines. This function implements a hack that overrides that issue.
%
% Usage:
% setlinealpha( hLine, alphaVal )
%
% Input:
% hLine: handles for line objects, coming from 'plot' for example.
% alphaVal: alpha (transparency) value from 0 (fully transparent) to 1
% (fully opaque).
%
% Output:
% None. The line alpha values will change in the figure.

for i = 1 : length( hLine )
    if strcmp(...
            class( hLine( i ) ), 'matlab.graphics.chart.primitive.Line' )
        col = get( hLine( i ), 'Color' );
        newCol = [ col alphaVal ];
        hLine( i ).Color = newCol;
        
    else
        warning( 'object not a line.' )
        
    end
    
end