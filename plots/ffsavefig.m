function ffsavefig( hFig, folder, figName, ext )
% FFSAVEFIG saves a png the figure to a specified directory.
%
% Usage:
% ffsavefig( hFig, folder, figName )
%
% Input:
% hFig: figure handle.
% folder: directory where you want the figure to be saved. If it does not
%         exists, then it creates it.
% figName: Name of the figure to save.
%
% Output:
% Saves the figure to the specified folder.

% Save figure.
set( hFig, 'PaperPositionMode', 'auto' )

% If folder does not exist, create it.
fig2save = fullfile( folder, figName, '.', ext );
folderFlag = exist( folder, 'dir' );

if folderFlag ~= 7
    fprintf( 'Figure directory did not exist. Creating...\n' )
    fprintf( '%s\n', folder )
    mkdir( folder )

end

switch ext
    case 'png'
        fprintf( 'Printing figure %s\n', figName );
        print( hFig, fig2save, '-dpng', '-r300' )
        
    case 'eps'
        fprintf( 'Printing figure %s\n', figName );
        print( hFig, fig2save, '-dpng', '-r300' )
        
    otherwise
        error( 'Something weird' )
        
end