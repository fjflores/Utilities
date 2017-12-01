function fig2eps
%FIG2EPS converts all matlab figs in a folder to eps.
% 
% Usage:
%   Run fig2eps when in the folder containing the figures to convert.

%% create eps figures from Matlab figures
folder = pwd;
files = dir( strcat( folder, '\*.fig' ) );
nFiles = length( files );
i = 1;
hW = waitbar( 0, 'Please wait...' );
while i <= nFiles
    figName = files( i ).name;
    uiopen( figName, 1 );
    [ pathstr, name, ext ] = fileparts( figName );
    newFigName = [ name '.eps' ];
    print( newFigName, '-depsc2' );
    waitbar( i ./ nFiles );
    i = i + 1;
    close( gcf );
    
end

close( hW );