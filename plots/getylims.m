function yLims = getylims( hAx )
% GETYLIMS gets the min and max y-limits from a set of Axes handles
%
% Usage:
% yLims = getylims( hAx )
%
% Input:
% hAx: set of axes handles.
%
% Ouptut:
% yLims = global minimum and maximum from all the axes y-limits.

for hAxIdx = 1 : length( hAx )
    lowLim( hAxIdx ) = hAx( hAxIdx ).YLim( 1 );
    highLim( hAxIdx ) = hAx( hAxIdx ).YLim( 2 );
    
end
yLims = [ min( lowLim ) max( highLim ) ];

