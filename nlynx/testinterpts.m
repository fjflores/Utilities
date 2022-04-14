% Test funtion to interpolate timestamps
load( 'TestData\testTsEqual' )
ts = interpts( rawTs, nBuff );

%% Test no repeated ts
d = diff( ts );
assert( all( d ) )

%% Test almost perfect r
x = 1 : numel( ts );
tol = 1e-10;
r = corrcoef( x, ts );
assert( abs( r(2) - 1 ) < tol )

% Test funtion to interpolate timestamps
load( 'TestData\testTsDifEnd' )
ts = interpts( rawTs, nBuff );

%% Test no repeated ts
d = diff( ts );
assert( all( d ) )

%% Test almost perfect r
x = 1 : numel( ts );
tol = 1e-10;
r = corrcoef( x, ts );
assert( abs( r(2) - 1 ) < tol )


