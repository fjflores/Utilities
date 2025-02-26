function hAx = plotscalogram( t, f, scalo, coi )
% PLOTSCALOGRAM plots the cwt scalogram.
%
% Usage:
% hAx = plotscalogram( t, f, wave )
% hAx = plotscalogram( t, f, scalo, coi )
%
% Input:
% t: time vector.
% f: frequency vector.
% scalo: scalogram from cwt calculation.
% coi: (optional) cone of influece within the scalogram.
%
% Output:
% hAx: handle to scalogram axes.
% 
% Example:
% Fs = 100;
% dt = 1 / Fs;
% t = 0 : dt : 10;
% sig = sin( 2 * pi * f * t );
% figure 
% plot( t, sig )
% [ wave, f, coi ] = cwt( sig, "amor", Fs );
% plotscalogram( t, f, wave, coi )

% Set options default values
if nargin < 4
    coi = [];

end

% Convert scalogram to magnitude
magScalo = abs( scalo );
imagesc( t, f, magScalo )
axis xy
set( gca, "Yscale", "log" )
axis tight

% If exists, plot cone of influence
if ~isempty( coi )
    hold on
    semilogy( gca, t, coi, 'w--', 'LineWidth', 2 )
    areah = area( gca, t, coi );
    areah.EdgeColor = 'none';
    areah.FaceColor = [ 0.8 0.8 0.8 ];
    alpha( areah, 0.4 );
    areah.PickableParts = 'none';

end

