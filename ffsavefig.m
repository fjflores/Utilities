function ffsavefig( hFig, folder, figName )
% FFSAVEFIG saves the figure to a specified directory.
%
% Usage:
% ffsavefig( hFig, folder )
%
% Input:
% hFig: figure handle.
% folder: directory where you want the figure to be saved. If it does not
%         exists, then it creates it.
% figName: Name of the figure.
%
% Output:
% Saves the figure to the specified folder.

% Save figure.
set( hFig, 'PaperPositionMode', 'auto' )
% If folder does not exist, create it.
fig2save = fullfile( folder, figName );
folderFlag = exist( folder, 'dir' );
if folderFlag == 7
    fprintf( 'Printing figure %s\n', figName );
    print( hFig, fig2save, '-dpng', '-r300' )
    
else
    fprintf( 'Figure directory did not exist. Creating...\n' )
    fprintf( '%s\n', folder )
    mkdir( folder )
    print( hFig, fig2save, '-dpng', '-r300' )
    
end