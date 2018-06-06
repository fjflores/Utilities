function dropDir = getdropdir( )
% GETDROPDIR returns the root Dropbox directory.
% 
% Usage:
% dropDir = getdropdir( )
% 
% dropDir is the path to the Dropbox directory in this computer.



% get user name
un = getenv('username');
% iterate over different drive letters, until one exists.
test1 = strcat( 'C:\Users\', un, '\Dropbox (MIT)' );
test2 = strcat( 'D:', 'Dropbox (MIT)' );
test3 = strcat( 'E:', 'Dropbox (MIT)' );

if exist( test1 ) == 7
    dropDir = test1;
    
elseif exist( test2 ) == 7
    dropDir = test1;
    
elseif exist( test3 ) == 7
    dropDir = test1;
    
else
    error( 'Dropbox directory not found.' )
    
end
