function durlocs = consecones( idx )

% CONSECONES finds number and location of consecutive ones.
%
% Usage:
% durlocs = eventdur( idx )
% 
% Input:
% idx: logical vector.
% 
% Output:
% durlocs: vector with duration of consecutive ones at the location where 
% it starts.
% 
% Taken from: 
% https://bit.ly/2lGKazl (mathworks central.)

% Convert column vectors to row vectors.
[ m, n ] = size( idx );
if n == 1
    idx = idx';
    
end

durlocs = zeros( size( idx ) );
idx2find = [ 0 idx 0 ];
startIdx = strfind( idx2find, [ 0 1 ]);
durlocs( startIdx ) = strfind( idx2find, [ 1 0 ] ) - startIdx;