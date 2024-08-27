function varargout = padvectors( varargin )

% Get the number of input vectors
num_vectors = nargin;

% Find the maximum size among the vectors
max_size = max( cellfun( @numel, varargin ) );

% Pad the shorter vectors with zeros
% paddedVecs = cell( 1, num_vectors );
for i = 1 : num_vectors
    varargout{ i } = [...
        varargin{ i }, zeros( 1, max_size - numel( varargin{ i } ) ) ];

end

