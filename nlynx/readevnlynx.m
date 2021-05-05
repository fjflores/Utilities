function events = readevnlynx( evPath )
% READEVNLYNX read nlynx events file to a table.
% 
% Input:
%   fPath: path to events file.
% 
% Output:
%   events: table with columns:
%       idx: event index number
%       TimeStamp: in microseconds
%       eventID: XXX 
%       TTL: TTL port logical state
%       Type: string describing the event
% 

% Copyright:
% 2011 Francisco J. Flores

f2read = fullfile( evPath, 'Events.nev' );
[tRaw,ids,ttl,type] = Nlx2MatEV( f2read, [ 1 1 1 0 1 ], 0, 1, [ ] );

warning( 'Timestamps are in microseconds.' )
tRaw = tRaw';
ids = ids';
ttl = ttl';
idx = ( 1 : numel( tRaw ) )';
events = table( idx, tRaw, ids, ttl, type,...
    'VariableNames',{ 'idx', 'TimeStamp', 'EventID', 'TTL', 'Type' } );