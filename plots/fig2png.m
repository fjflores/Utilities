function fig2png( varargin )
%FIG2PNG converts matlab figures to png.
%
% If no input, goes over the curent folder to find 
% .fig files, and converts them to png's.
%
% With one input, it must be a figure handle, and
%it will convert that figure to png.

if isempty( varargin )
files = dir( '*.fig' );
nFiles = length( files );

for i = 1 :nFiles
    fn = files( i ).name ;
    h = openfig( fn );
    [ ~, fig2save, ext ] = fileparts( fn );
    print( '-dpng', [ fig2save '.png' ] );
    close( h );
    
end

elseif strcmp( varargin( 1 ), 'gcf' )
    set( gcf )
    print( '-dpng', [ fig2save '.png' ] );
     
end
