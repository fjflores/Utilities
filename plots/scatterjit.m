function s = scatterjit( varargin )
% SCATTERJIT is a wrapper function for SCATTER where you can input the
% amount of jitter desired. 
% 
% Input arguments should be the same as SCATTER, with the addition of 
% Name-Value pairs:
%   'Jit' or 'Jitter': the amount of jitter desired. Note: 0.1 jitter will
%       lead to points jittered +/-0.1 around the original value.
%   'Axis': which axis to jitter around. Options: 'x' (default), 'y', or 
%       'both'. If both, 2 jitter values should be listed: [ x, y ]. If 
%       only one is listed, it will jitter the same amount in both axes.

% Set default values.
jit = 0; 
ax2jit = 'x';

% Find the relevant Name-Value pair.
args = varargin;
for idx = 1 : length( args )
    thisArg = args{ idx };
    if ~isnumeric( thisArg )
        switch lower( thisArg )
            case { 'jit', 'jitter' }
                jitIdx = idx;
                jit = args{ jitIdx + 1 };
                
            case { 'axis' }
                axIdx = idx;
                ax2jit = args{ axIdx + 1 };
                
        end
        
    end
    
end

if ~exist( 'jitIdx', 'var' ) % Deal with cases where function is called 
% without a jitter N-V pair.
    args4scat = args;
    warning( 'No jitter amount selected.' )
    
else % Remove jitter N-V pair from argument list.
    idx4scat = [ 1 : jitIdx - 1, jitIdx + 2 : length( args ) ];
    args4scat = args( idx4scat );
    
end

% Remove axis N-V pair from argument list.
if exist( 'axIdx', 'var' )
    % Find new index of 'Axis' N-V pair.
    for idx = 1 : length( args4scat )
        thisArg = args4scat{ idx };
        if ~isnumeric( thisArg )
            switch lower( thisArg )
                case { 'axis' }
                    newAxIdx = idx;
            end
        end
    end
    
    idx4scat = [ 1 : newAxIdx - 1, newAxIdx + 2 : length( args4scat ) ];
    args4scat = args4scat( idx4scat );
    
end

% Unpacks jit into jit values for each axis.
switch ax2jit
    case { 'x', 'X' }
        xJit = jit( 1 );
        yJit = 0;
        
    case { 'y', 'Y' }
        xJit = 0;
        yJit = jit( 1 );
        
    case { 'both', 'xy', 'XY' }
        if numel( jit ) == 2
            xJit = jit( 1 );
            yJit = jit( 2 );
            
        elseif numel( jit ) == 1
            xJit = jit;
            yJit = jit;
            
        end
        
end

% Create the random jitter vector(s) and add it to the values.
xJitArray = -xJit + ( 2 * xJit ) * rand( length( args{ 1 } ), 1 );
yJitArray = -yJit + ( 2 * yJit ) * rand( length( args{ 1 } ), 1 );

if iscolumn( args{ 1 } )
    args4scat{ 1 } = args{ 1 } + xJitArray;    
elseif isrow( args{ 1 } )
    args4scat{ 1 } = args{ 1 } + xJitArray';    
end

if iscolumn( args{ 2 } )
    args4scat{ 2 } = args{ 2 } + yJitArray;    
elseif isrow( args{ 1 } )
    args4scat{ 2 } = args{ 2 } + yJitArray';    
end

% Pass all the arguments minus the jitter N-V pair to SCATTER function.
s = scatter( args4scat{ : } );


end

