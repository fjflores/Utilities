function fig2png
%FIG2PNG converts matlab figures to png.
%
% No inputs or outputs. Just run in the folder with figures.

files = dir( '*.fig' );
nFiles = length( files );

for i = 1 :nFiles
    fn = files( i ).name ;
    h = openfig( fn );
    [ ~, fig2save, ext ] = fileparts( fn );
    print( '-dpng', [ fig2save '.png' ] );
    close( h );
    
end