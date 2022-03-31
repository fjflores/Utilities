%% Test that output is structure
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
assert( isstruct( hdrInfo ) )

%% Test day
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
day = '2022/03/22';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
timeOpen = '12:44:40';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
timeClose = '15:11:00';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
Fs = 1600;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
convFactor = 0.000000061035156250000001;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD channel
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
ADChan = 23;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input is boolean
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.inverted ) )

%% Test inverted input is true
load( 'TestData\testHdr' )
hdrInfo = parsehdrnlynx( hdr );
inverted = false;
assert( hdrInfo.inverted == inverted )



