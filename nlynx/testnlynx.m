%% Test that output is structure
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
assert( isstruct( hdrInfo ) )

%% Test day
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
day = '2022/03/22';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
timeOpen = '12:44:40';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
timeClose = '15:11:00';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
Fs = 1600;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
convFactor = 0.000000061035156250000001;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD channel
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
ADChan = 23;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input
% Inverted input ios false.
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.inverted ) && ~hdrInfo.inverted )

%% Test enabling of DSP delay 
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.delayEnabled ) && hdrInfo.delayEnabled )

%% Test DSP delay value
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );
delay = 1969;
assert( abs( hdrInfo.delay - delay ) < eps )




