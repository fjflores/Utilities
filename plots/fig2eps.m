function fig2eps( varargin )
%FIG2EPS converts all matlab figs in a folder to eps.
%
% Usage:
% fig2eps( )
% fig2eps( hFig )
% fig2eps( hFig, path2save )
% 
% Input:
% no argument: Run fig2eps in the folder containing the figures to convert.
% hFig: figure handle to save.

%% create eps figures from Matlab figures
if nargin < 1
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
        print( newFigName, '-depsc2', '-vector' );
        waitbar( i ./ nFiles );
        i = i + 1;
        close( gcf );

    end

    close( hW );

end

if nargin == 1
    hFig = varargin{ 1 };
    hFig.Renderer = 'painters';
    print( hFig, '-depsc2' );

end

if nargin == 2
    hFig = varargin{ 1 };
    path2save = varargin{ 2 };
    hFig.Renderer = 'painters';
    retDir = pwd;
    cd( path2save )
    print( hFig, '-depsc2' );
    cd( retDir );

end
