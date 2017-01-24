function events = readnlynxnev

% read nlynx events file and place it into a dataset object

% Input:
% This function needs no input. it assumes that Nlynx events are all named
% "Events.nev".
% 
% Output:
%   events = dataset object containing Timestamp in seconds, event ID, TTL
%   to which the event was commited, and string describing the event.

% (c) 2011 Francisco J. Flores

[t,ids,ttl,type] = Nlx2MatEV( 'Events.nev', [ 1 1 1 0 1 ], 0, 1, [ ] );
t = t' ./ 1e6;
ids = ids'; 
ttl = ttl';
idx = 1 : numel( t );
events = table( idx', t, ids, ttl, type,...
    'VariableNames',{ 'idx', 'Timestamp', 'EventID', 'Ttl', 'String' } );