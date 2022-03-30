%% Test that output is structure
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
assert( isstruct( hdrInfo ) )

%% Test that is Cheetah 5.7 hdr style
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
timeOpen = '12:44:40';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )
