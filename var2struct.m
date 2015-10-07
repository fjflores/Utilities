function out = var2struct( varargin )
% VAR2STRUCT pack individual variables into a structure.
%
%

% check user input:
if nargin == 0
    error( 'Need at least one input argument' )
    
elseif nargin >= 1
    args = cell( 2, nargin );
    num = 1;
    for varIdx = 1 : nargin
        args( :, varIdx ) = { inputname( varIdx ); varargin{ varIdx } };
        
        if isempty( args{ 1, varIdx }
            args{ 1, varIdx } = sprintf( 'ans%d', num );
            num = num + 1;
            
        end
        
    end    
    % create structure using comma-separated list
    out = struct( args{ : } );
    
end