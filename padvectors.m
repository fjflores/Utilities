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
% 
% Note that row vectors will be transformed to column vectors and output as
% such. Re-convert the column to row vectors if needed after using this
% function.

% Deal with the last element being a string
if isstring( varargin{ end } )
    method = varargin{ end };
    varargin{ end } = [ ];
    num_vectors = nargin - 1;

else
    method = "zeros";
    num_vectors = nargin;

end

% Find the maximum size among the vectors
max_size = max( cellfun( @numel, varargin ) );

% Pad the shorter vectors with zeros
for i = 1 : num_vectors
    thisVec = tocolumn( varargin{ i } );

    switch method
        case "zeros"
            varargout{ i } = [...
                thisVec;...
                zeros( max_size - numel( thisVec ), 1 ) ];

        case "nans"
            varargout{ i } = [...
                thisVec;...
                nan( max_size - numel( thisVec ), 1 ) ];

        case "linear"
            spacing = diff( thisVec );
            el2add = max_size - numel( thisVec );
            varargout{ i } = [...
                thisVec;...
                thisVec( end ) + ( ( 1 : el2add ) .* spacing( 1 ) )' ];

    end

end

% helper subfunction to change row to column vector
function vec = tocolumn( vec2change )
if isrow( vec2change )
    vec = vec2change.';

else
    vec = vec2change;

end