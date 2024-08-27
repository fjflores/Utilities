function varargout = padvectors( varargin )
% PADVECTORS adds elements to match the longest vector.
% 
% Usage:
% [ a1, b1, c1, ... ] = padvectors( a, b, c, ... )
% [ a1, b1, c1, ... ] = padvectors( a, b, c, ..., method )
% 
% Input:
% a, b, c: vectors to pad. The longest vector will be used as reference.
% method: Optional. Method to pad the vectors. Can be "zeros" to pad with
% zeros, "nans" to pad with nan's, or "linear" to linearly continue the
% sequence. Note this last option only works well for monotonically
% increasing vectors. Default: "zeros".
% 
% Output:
% a1, b1, c1: padded vectors, except for the original ongest on e that
% stays the same.

% Deal with the last element being a string
if isstring( varargin{ end } )
    method = varargin{ end };
    varargin{ end } = [];
    num_vectors = nargin - 1;

else
    method = "zeros";
    num_vectors = nargin;

end

% Find the maximum size among the vectors
max_size = max( cellfun( @numel, varargin ) );

% Pad the shorter vectors with zeros
% paddedVecs = cell( 1, num_vectors );
for i = 1 : num_vectors

    switch method

        case "zeros"
            varargout{ i } = [...
                varargin{ i },...
                zeros( 1, max_size - numel( varargin{ i } ) ) ];

        case "nans"
            varargout{ i } = [...
                varargin{ i },...
                nan( 1, max_size - numel( varargin{ i } ) ) ];

        case "linear"
            spacing = diff( varargin{ i } );
            el2add = max_size - numel( varargin{ i } );
            varargout{ i } = [...
                varargin{ i },...
                varargin{ i }( end ) + ( ( 1 : el2add ) .* spacing( 1 ) ) ];

    end

end

