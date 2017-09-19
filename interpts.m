function intTs = interpts( ts, Fs, rel, method, buffSize )
% INTERPTS interpolates the timestamps output from DevilLynx
%
% Usage:
% intTs = interpts( ts, Fs, rel )
%
% Input:
% ts:     Original timestamps vector.
% Fs:     Sampling frequency.
% rel:    boolean flag, if true it will substract the first timestamp from
%         all the others, so it will start from zero. Default = false.
%
% Output:
% intTs: Interpolated timestamps.


% check user input
if nargin == 2
    rel = false;
    method = 'simple';
    buffSize = 512; % This is default.
    
elseif nargin == 3
    method = 'simple';
    buffSize = 512;
    
elseif nargin == 4
    buffSize = 512;
    
end

% Save first ts to relativize with respect to it.
firstTs = ts( 1 );

% Get actual ts length based on buffer size.
nTs = length( ts ) * buffSize;

switch method
    case 'simple'
        % Assumes there wer not discontinuities during recording.
        intTs = linspace( firstTs, firstTs + nTs, nTs );
        
    case 'interp'
        % Perform an interpolation based on nlynx saved timestamps. There
        % might be discontinuities.
        warning(...
            { 'Using Interpolation method.',...
            'Check for possible discontinuites' } )
        
        % Get sample interval, and convert to microseconds.
        sampInterv = ( buffSize / Fs ) * 1e6;
        
        % Check if nlynx timestamps have discontinuities.
        dTs = diff( ts );
        accel = round( diff( dTs ) );
        if any( accel )
            warning( { ' Ts vector does not increases monotonically.',...
                ' Using loop.' } )
            % Allocate matrix with zeros
            tsMat = zeros( length( ts ), buffSize );
            nRecs = length( ts );
            
            for recIdx = 1 : nRecs
                if recIdx < nRecs
                    % deal with all records but the last one.
                    tmpFirstTs = ts( recIdx );
                    tmpLastTs = ts( recIdx ) + sampInterv;
                    tsMat( recIdx, : ) = linspace(...
                        tmpFirstTs, tmpLastTs, buffSize );
                    
                else
                    % Deals with the last record.
                    tmpFirstTs = ts( recIdx );
                    tmpLastTs = ts( recIdx ) + sampInterv;
                    tsMat( recIdx, : ) = linspace(...
                        tmpFirstTs, tmpLastTs, buffSize );
                    
                end
                
            end
            intTs = tsMat( : );
            
        else
            disp(...
                { ' Ts vector increases monotonically.',...
                ' Using vectorization.' } )
            lastTs = ts( end ) + ( sampInterv * buffSize );
            intTs = firstTs : sampInterv : lastTs;
            
        end
        
    otherwise
        error( 'Timestamp Interpolation method not defined' )
        
end

% Start at t = zero if desired.
if rel
    intTs = intTs - firstTs;
    
end
