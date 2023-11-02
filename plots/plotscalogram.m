function hAx = plotscalogram( t, f, scalo, coi )
%%  PLOTSCALOGRAM plots the cwt scalogram.
%
% Usage:
%
%
% Input:
%
%
% Output:
%
% 
% Example:
% 

% Set options default values
if nargin < 4
    coi = [];

end

% Convert scalogram to magnitude
hAx = axes;
magScalo = abs( scalo );
imagesc( hAx, t, f, magScalo )
axis xy
set( hAx, "Yscale", "log" )
axis tight

% If exists, plot cone of influence
if ~isempty( coi )
    hold on
    semilogy( hAx, t, coi, 'w--', 'LineWidth', 2 )
    areah = area( hAx, t, coi );
    areah.EdgeColor = 'none';
    areah.FaceColor = [ 0.8 0.8 0.8 ];
    alpha( areah, 0.4 );
    areah.PickableParts = 'none';

end

