function [ dataClean, remIdx ] = replaceartifact( signal, t, artTimes, meth )
%REPLACEARTIFACT replaces artifacts with nans.
%
% Usage:
% dataClean = replaceartifact( signal, t, artTimes, meth )
% [ dataClean, remIdx ] = replaceartifact( signal, t, artTimes, meth )
%
% Input:
% signal: column vector to be processed.
% t: timestamps for the signal vector.
% artTimes = two-colum matrix of start and end times for artifacts.
% meth: either 'nan' to replace withs nan's, or 'linear', to interpolate
% with a linear function.
%
% Output:
% dataClean = data artifacts removed.
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
fprintf( 'Removing artifacts...' )
for artCnt = 1 : size( artTimes, 1 )
    thisStart = artTimes( artCnt, 1 ) - 0.5;
    thisEnd = artTimes( artCnt, 2 ) + 0.5;
    artIdx = t >= thisStart & t <= thisEnd;
    remIdx = remIdx + artIdx;
    
end
remIdx = logical( remIdx );

switch meth
    case( 'nan' )
        fprintf( 'Replacing with nans' )
        % replaces artifacts with nans
        dataClean = signal;
        dataClean( remIdx ) = nan;
        
    case( 'linear' )
        fprintf( 'Replacing with nearest linear fit' )
        % replaces artifacts with linear interpolation
        % find discontinuity points
        dataClean = signal;
        disIdx = diff( remIdx);
        upIdx = find( disIdx == 1 );
        dnIdx = find( disIdx == -1 ) + 1;
        
        % piecewise replacement
        for repIdx = 1 : length( upIdx )
            p = polyfit(...
                [ t( upIdx( repIdx ) ) t( dnIdx( repIdx ) ) ],...
                [ signal( upIdx( repIdx ) ) signal( dnIdx( repIdx ) ) ],...
                1 );
            fitLine = polyval( p, t( upIdx( repIdx ) : dnIdx( repIdx ) ) );
            dataClean( upIdx( repIdx ) : dnIdx( repIdx ) ) = fitLine;
            
        end
        
    otherwise
        error( 'wrong or no method provided' )
        
end

