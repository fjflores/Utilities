%% Test that output is cell
fileName = 'testData\CSC25.ncs';
hdrRaw = getrawhdr( fileName );
assert( iscell( hdrRaw ) )

%% Test without extension
fileName = 'testData\CSC25';
hdrRaw = getrawhdr( fileName );
assert( iscell( hdrRaw ) )
