function ffsavefig( hFig, folder )
% FFSAVEFIG saves the figure to a specified directory.
%
% Usage:
% ffsavefig( hFig, folder )
%
% Input:
% hFig: figure handle.
% folder: directory where you want the figure to be saved. If it does not
% exists, then it creates it.
%
% Output:
% Saves the figure to the specified folder.

% Save figure.
set( hFig, 'PaperPositionMode', 'auto' )
% If folder does not exist, create it.
figName = 'Pfc_layers_states';
fig2save = fullfile( folder );
folderFlag = exist( folder, 'dir' );
if folderFlag == 7
    fprintf( 'Printing figure %s\n', figName );
    print( hFig, fig2save, '-dpng', '-r300' )
    
else
    fprintf( 'Figure directory did not exist. Creating...\n' )
    fprintf( '%s', folder )
    mkdir( folder )
    print( hFig, fig2save, '-dpng', '-r600' )
    
end