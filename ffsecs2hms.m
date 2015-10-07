function time = ffsecs2hms(time_in_secs)

% FFSECS2HMS - converts a time in seconds to a string giving the time in hours, minutes and second
% useful for generating xtick labels for time series plotting
% 
% INPUT:    'time_in_secs': time in seconds
% OUTPUT:   'times': string of time in hh:mm:ss format
% 
% 

% test for column vector
[ m, n ] = size( time_in_secs );
if m < n
    time_in_secs = time_in_secs';
    
end
clear n

n = length( time_in_secs );
for i = 1 : n
    time_string = '00:00:00';
    nHours = 0;
    nMins = 0;
    
    % computing hours
    if time_in_secs( i, 1 ) >= 3600
        nHours = floor( time_in_secs( i, 1 ) / 3600 );
        
        if nHours > 9
            time_string( 1 : 2 ) = num2str( nHours );
            
        else
            time_string( 2 ) = num2str(nHours);
            
        end
        
    end

    % computing minutes
    if time_in_secs( i, 1 ) >= 60
        nMins = floor( ( time_in_secs( i, 1 ) - 3600 * nHours ) / 60 );
        
        if nMins > 9
            time_string( 4 : 5 ) = num2str( nMins );
            
        else
            time_string( 5 ) = num2str( nMins );
            
        end
        
    end

    % compute remnant seconds
    nSecs = round( time_in_secs( i, 1 ) - 3600 * nHours - 60 * nMins);   
    if nSecs > 9
        time_string( 7 : 8 )= num2str( nSecs );
        
    else
        time_string( 8 ) = num2str( nSecs );
        
    end
    time( i, : ) = time_string;
    
end