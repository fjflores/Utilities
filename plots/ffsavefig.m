function ffsavefig( hFig, folder, figName, ext )
% FFSAVEFIG saves a png the figure to a specified directory.
%
% Usage:
% ffsavefig( hFig, folder, figName, ext )
%
% Input:
% hFig: figure handle.
% dir: directory where you want the figure to be saved. If it does not
%      exists, then it creates it.
% figName: Name of the figure to save.
% ext: format in which to save the figure. Rightn now only supports png at
%      300 dpi, and eps in ps2 color format.
%
% Output:
% Saves the figure to the specified folder.

% Save figure.
set( hFig, 'PaperPositionMode', 'auto' )

% If folder does not exist, create it.
fig2save = strcat( fullfile( folder, figName ), [ '.' ext ] );
folderFlag = exist( folder, 'dir' );

if folderFlag ~= 7
    msg1 = sprintf( 'Requested directory did not exist. Creating...\n' );
    msg2 = sprintf( '%s\n', folder );
    disp( msg1 )
    disp( pad( msg1, 'left' ) )
    mkdir( folder )
    
else
    msg1 = sprintf( 'Requested directory already exists.\n' );
    disp( msg1 )

end

msg1 = sprintf( 'Printing figure %s in %s format...\n', figName, ext );
disp( pad( msg1, 'left' ) )
switch ext
    case 'png'
        print( hFig, fig2save, '-dpng', '-r300' )
        
    case 'eps'
        print( hFig, fig2save, '-depsc2' )
        
    otherwise
        error( 'Invalid figure extension.' )
        
end
fprintf( 'Done.\n' )