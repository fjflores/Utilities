function events = readevnlynx( evPath )

% READEVNLYNX read nlynx events file and place it into a dataset object

% Input:
% fPath = path to events file.
% 
% Output:
%   events = dataset object containing Timestamp in seconds, event ID, TTL
%   to which the event was commited, and string describing the event.

% (c) 2011 Francisco J. Flo

f2read = fullfile( evPath, 'Events.nev' );
[t,ids,ttl,type] = Nlx2MatEV( f2read, [ 1 1 1 0 1 ], 0, 1, [ ] );
t = t' ./ 1e6;
ids = ids'; 
ttl = ttl';
idx = 1 : numel( t );
events = table( idx', t, ids, ttl, type,...
    'VariableNames',{ 'idx', 'TimeStamp', 'EventID', 'TTL', 'String' } );