%% Test that output is cell
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr, ext );
assert( isstruct( hdrInfo ) )
