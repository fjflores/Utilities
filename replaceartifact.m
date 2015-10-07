function dataClean = replaceartifact( signal, t, artTimes )
%REPLACEARTIFACT replaces artifacts with nans.
%
% Usage:
% dataClean = replaceartifact( signal, t, artTimes )
% 
% Input:
% signal: column vector to be processed.
% t: timestamps for the signal vector.
% artTimes = two-colum matrix of start and end times for artifacts.
% 
% Output:
% dataClean = data with nan's where the artifact was.
% 
% Beware that looks for times, not points (unsafe, but ok as long as only
% one signal is being processed).

% first, remove any artifact time lower than t(1) or greater than t(end)
idx1 = artTimes( :, 1 ) < t( 1 );
idx2 = artTimes( :, 2 ) > t( end );
artTimes( logical(idx1+idx2),: ) = [ ];

% assess htat artifact times are within the range of time vector.
remIdx = logical( ( artTimes( :, 1 ) < t( 1 ) ) + ( artTimes( :, 2 ) > t( end ) ) );
artTimes( remIdx, : ) = [ ];

% % tsKeep = t;
remIdx = false( length( t ), 1 );

% first, remove artifact epochs
hWB = waitbar(0,'Removing artifacts...');
for artCnt = 1 : size( artTimes, 1 )
    
    thisStart = artTimes( artCnt, 1 ) - 0.5;
    thisEnd = artTimes( artCnt, 2 ) + 0.5;  
    artIdx = t >= thisStart & t <= thisEnd;
    remIdx = remIdx + artIdx;
    waitbar( artCnt ./ size( artTimes, 1 ) )
    
end
close( hWB )
remIdx = logical( remIdx );

% tsIdx = ismember( t, tsKeep );
dataClean = signal;
dataClean( remIdx ) = nan;