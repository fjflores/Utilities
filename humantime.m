function msg = humantime( timeNum )
% HUMANTIME converts the supplied time in secs to mins or hours.
% 
% Usage:
% [ num, unit ] = humantime( timeNum );
% 
% Is intended to be used in reporting how muich time does a process take.
% 
% Input:
% timeNum: amount of time in secs.
% 
% Output:
% msg: message with time in human readable format.

if ischar( timeNum )
    error( "Input must be a number" )

end

if timeNum <= 1
    % less than a second case
    msg = sprintf( '<1 sec' );

elseif timeNum > 1 & timeNum < 60
    secs = round( timeNum );
    msg = sprintf( '%u secs', secs );

elseif timeNum >= 60 & timeNum < 61
    preMins = timeNum / 60;
    mins = floor( preMins );
    secs = round( 60 * ( preMins - mins ) );
    msg = sprintf( '%u min %u secs', mins, secs );

elseif timeNum >= 61 & timeNum < 3600
    preMins = timeNum / 60;
    mins = floor( preMins );
    secs = round( 60 * ( preMins - mins ) );
    msg = sprintf( '%u mins %u secs', mins, secs );
    
elseif timeNum >= 3600
    preHrs = timeNum / 3600;
    hrs = floor( preHrs );
    preMins = 60 * ( preHrs - hrs );
    mins = floor( preMins );
    secs = round( 60 * ( preMins - mins ) );
    msg = sprintf( '%u hrs %u mins %u secs', hrs, mins, secs );
    
else
    error( 'input argument it is not in the correct format.' )
    
end

