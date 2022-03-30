%% Test that output is cell
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr, ext );
assert( isstruct( hdrInfo ) )

%% Test that is newer hdr style
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr, ext );
assert( hdrInfo.inpInverted == True )
