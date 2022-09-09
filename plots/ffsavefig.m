function ffsavefig( hFig, dir, figName, ext )
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
% ext: format in which to save the figure. It supports 'png' at
%      300 dpi, 'eps' in ps2 color format, and regular matlab 'fig'.
%
% Output:
% Saves the figure to the specified folder.

% Save figure.
set( hFig, 'PaperPositionMode', 'auto' )

% If folder does not exist, create it.
fig2save = strcat( fullfile( dir, figName ), [ '.' ext ] );
folderFlag = exist( dir, 'dir' );

if folderFlag ~= 7
    fprintf( 'Requested directory did not exist. Creating...' );
%     msg2 = sprintf( '%s\n', dir );
%     disp( msg1 )
%     disp( pad( msg1, 'left' ) )
    mkdir( dir )
    fprintf( 'Done.\n' )
    
else
    fprintf( 'Requested directory already exists.\n' );
%     disp( msg1 )

end

msg1 = sprintf( 'Printing figure %s in %s format...', figName, ext );
disp( pad( msg1, 'left' ) )
switch ext
    case 'png'
        print( hFig, fig2save, '-dpng', '-r300' )
        
    case 'eps'
        set( hFig, 'Renderer', 'Painters' )
        print( hFig, fig2save, '-depsc2' )
        
    case 'fig'
        savefig( hFig, fig2save )
        
    otherwise
        error(...
            'Invalid figure extension. Has to be either fig, png, or eps.' )
        
end
fprintf( 'Done.\n' )