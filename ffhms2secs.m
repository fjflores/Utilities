function secs = ffhms2secs(hms)

% FFHMS2SECS converts an h:m:s time string to secs
% 
% it reads an string with h:m:s in it and returns the value in seconds
% Input:    
% hms: string with h:m:s format at the end (like DevilLynx header)
% 
% Output:   
% secs: corresponding seconds.
% 
% (c) Francisco J. Flores 2010-May-12

hms( hms == ' ' ) = [ ]; % get rid of all the blanks
idxColon = findstr( hms, ':' ); % find all the colons

% if there are more than 2 colons...
if numel( idxColon ) > 2
    % discard everything before the third to last colon inclusive
    hms( 1 : idxColon( end - 2 ) )= [ ];  
end

% find colons again
idxColon = findstr( hms, ':' );
% extract hours and convert to secs
h = str2double( hms( 1 : idxColon( 1 ) - 1 ) ) * 3600;
 % extract minutes and convert to secs
m = str2double( hms( idxColon( 1 ) + 1 : idxColon( 2 ) - 1 ) ) * 60;
% extract seconds
s = str2num( hms( idxColon( 2 ) + 1 : end ) );
% sum everything
secs = h + m + s; 


