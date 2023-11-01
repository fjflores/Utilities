function s = scatterjit( varargin )
% SCATTERJIT is a wrapper function for SCATTER where you can input the
% amount of x-axis jitter desired. 
% 
% Input arguments should be the same as SCATTER, with the addition of 
% Name-Value pair:
%   'Jit' or 'Jitter': the amount of jitter desired. Note: 0.1 jitter will
%   lead to points jittered +/-0.1 around the original x value.

% Find the relevant Name-Value pair.
args = varargin;
for idx = 1 : length( args )
    thisArg = args{ idx };
    if ~isnumeric( thisArg )
        switch lower( thisArg )
            case { 'jit', 'jitter', 'xjit', 'xjitter' }
                jitIdx = idx;
                xJit = args{ jitIdx + 1 };
                
        end
        
    end
    
end

if ~exist( 'jitIdx', 'var' ) % Deals with cases where function is called 
% without a jitter N-V pair.
    xJit = 0;
    args4scat = args;
    warning( 'No jitter amount selected.' )
    
else % Removes jitter N-V pair from argument list.
    idx4scat = [ 1 : jitIdx - 1, jitIdx + 2 : length( args ) ];
    args4scat = args( idx4scat );
    
end

% Create the random jitter vector and add it to the x values.
jit = -xJit + ( 2 * xJit ) * rand( length( args{ 1 } ), 1 );
if iscolumn( args{ 1 } )
    args4scat{ 1 } = args{ 1 } + jit;    
elseif isrow( args{ 1 } )
    args4scat{ 1 } = args{ 1 } + jit';    
end

% Pass all the arguments minus the jitter N-V pair to SCATTER function.
s = scatter( args4scat{ : } );


end

