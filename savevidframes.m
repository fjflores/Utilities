function savevidframes( dir2save, figHandle )
% SAVEVIDFRAMES rotates 3D plots and saves images for video.
% 
% Usage:
% savevidframes( dir2save, figHandle )
% 
% Input:
% dir2save: directory where the images will be saved.
% figHandle: handle for figure with 3D plot to save.
% 
% Output:
% Series of images with 3D plot rotated at different angles.


% Set up figure properties.
figHandle.Units = 'pixels';
figHandle.Renderer = 'painters';
% ax = get( figHandle, 'Children' );
% ax2use = ax( 1 );
% set( ax2use, 'Units', 'pixels' )
% pos = ax2use.Position;

% Start looping through frames
frameCnt = 1;
for i = 0 : 10 : 350
    view( i, 340 )
    
    fName = sprintf( 'Elec_traj-%u.png', frameCnt );
    fig2save = fullfile( dir2save, fName );
    saveas( figHandle, fig2save, 'png' )
    frameCnt = frameCnt + 1;
    
end

% Saved this at the end in case the one above fails for some reaSON
% guiFig = gcf;
% set(gcf,'Toolbar','figure')
% guiFig.Units = 'pixels';
% guiFig.Renderer = 'painters';
% ax = get( guiFig, 'Children' );
% ax2use = ax( 4 );
% 
% set( ax2use,...
%     'Units', 'pixels',...
%     'XLim', [-7 7],...
%     'YLim', [ -8 6 ],...
%     'ZLim', [ -1 8 ] )
% pos = ax2use.Position;
% 
% resDir = 'D:\Dropbox (Personal)\Projects\017_Electrical_anesthesia\Docs\Pres\2022-01-12 NSRL report\Assets\Video_histology_track';
% 
% frameCnt = 1;
% for i = 0 : 10 : 350
%     view( i, 340 )
%     F = getframe( ax2use );
%     im = frame2im( F );
%     fname = fullfile( resDir, [ 'Elec_traj-' num2str( frameCnt ) '.png' ] );
%     imwrite( im, fname )
% 
% %     fname = [ 'Elec_traj-' num2str( frameCnt ) '.png' ];
% %     fig2save = fullfile( resDir, fname );
% %     saveas( gca, fig2save, 'png' )
%     frameCnt = frameCnt + 1;
% 
% end