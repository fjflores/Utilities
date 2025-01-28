function [ dataClean, remIdx, tClean ] = replaceartifact( signal, t, artTimes, meth )
%REPLACEARTIFACT replaces or removes artifacts, depending on desired method.
%
% Usage:
% dataClean = replaceartifact( signal, t, artTimes, meth )
% [ dataClean, remIdx ] = replaceartifact( signal, t, artTimes, meth )
% [ dataClean, remIdx, tClean ] = replaceartifact( signal, t, artTimes, meth )
%
% Input:
% signal: column vector to be processed. Can be multiple signals (each in a
% column) as long as the timestamp vector applies to all columns.
% t: timestamps for the signal vector.
% artTimes: two-colum matrix of start and end times for artifacts.
% meth: 'nan' to replace withs nan's, 'zeros' to replace with zeros,
% 'linear' to interpolate with a linear function, 'none' to just delete the
% data. This also outputs the removed time.
%
% Output:
% dataClean: data with artifacts removed.
% remIdx: indeces of removed signal.
% tClean: updated timestamp vector without removed signals (only for method
% 'none').
%
% Beware that looks for times, not points (unsafe, but ok as long as only
% one signal is being processed).

% first, remove any artifact time lower than t(1) or greater than t(end)
idx1 = artTimes( :, 1 ) < t( 1 );
idx2 = artTimes( :, 2 ) > t( end );
testIdx = logical( idx1 + idx2 );
artTimes( testIdx,: ) = [ ];
remIdx = false( length( t ), 1 );

% first, remove artifact epochs
fprintf( 'Removing artifacts...' )
for artCnt = 1 : size( artTimes, 1 )
    thisStart = artTimes( artCnt, 1 ) - 0.5;
    thisEnd = artTimes( artCnt, 2 ) + 0.5;
    artIdx = t >= thisStart & t <= thisEnd;
    
    % test that t is either a row or column vector. Throw exception
    % otherwise.
    if iscolumn( t )
        remIdx = remIdx + artIdx;
        
    elseif isrow( t )
        remIdx = remIdx + artIdx';
        
    else
        error( 't must be a column or row vector' )
        
    end
    
end
remIdx = logical( remIdx );

switch meth
    case( 'nan' )
        fprintf( 'Replacing with nans\n' )
        % replaces artifacts with nans
        dataClean = signal;
        dataClean( remIdx, : ) = nan;

    case( 'zeros' )
        dataClean = signal;
        dataClean( remIdx, : ) = 0;

    case( 'none' )
        fprintf( 'Removing bad data\n' )
        % remove artifactual chunk
        dataClean = signal;
        dataClean( remIdx, : ) = [ ];
        tClean = t;
        tClean( remIdx ) = [ ];
        
    case( 'linear' )
        fprintf( 'Replacing with nearest linear fit\n' )
        disIdx = diff( remIdx );
        upIdx = find( disIdx == 1 );
        dnIdx = find( disIdx == -1 ) + 1;

        assert( ~isempty( upIdx ) & ~isempty( dnIdx ),...
            [ 'Cannot perform linear interpolation bc artifact ',...
            'includes beginning or end of signal.' ] )

        % replaces artifacts with linear interpolation
        % find discontinuity points
        for sigIdx = 1 : size( signal, 2 )
            dataClean( :, sigIdx ) = signal( :, sigIdx );

            % piecewise replacement
            for repIdx = 1 : length( upIdx )
                p = polyfit(...
                    [ t( upIdx( repIdx ) ) t( dnIdx( repIdx ) ) ],...
                    [ signal( upIdx( repIdx ), sigIdx ) signal( dnIdx( repIdx ), sigIdx ) ],...
                    1 );
                fitLine = polyval( p, t( upIdx( repIdx ) : dnIdx( repIdx ) ) );
                dataClean( upIdx( repIdx ) : dnIdx( repIdx ), sigIdx ) = fitLine;

            end

        end
        
    otherwise
        error( 'wrong or no method provided' )
        
end
        
end

