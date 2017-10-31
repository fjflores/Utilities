function varargout = struct2var( inStruct )
% STRUCT2VAR unpacks a structure into individual variables
%
% Usage:
%   varargout = struct2var( inStruct )
% 
% Input:
%   inStruct: structure.
% 
% Output:
%   varargout: variable-length output, with as many variables as fields 
%   were in the structure, and with same names as the fields.

if nargin == 0
    error( 'Structure input argument required' )
    
elseif nargin == 1    
    if ~isstruct( inStruct ) || length( inStruct ) ~= 1
        error( 'Input must be a structure' )
        
    end
    
    % get structure fieldnames
    names = fieldnames( inStruct );
    
    % If outpur arguments, assign in caller workspace ('base').
    if nargout == 0
        for i = 1 : length( names )
            assignin( 'caller', names{ i }, inStruct.( names{ i } ) );
            
        end
        
    else
        varargout = cell( 1, nargout );
        for i = 1 : nargout
            varargout{ i } = inStruct.( names{ i } );
            
        end
        
    end
    
else
    error( 'Function only takes one structure input argument' )
    
end
