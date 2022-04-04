%% Test that output is structure
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
assert( isstruct( hdrInfo ) )

%% Test day
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr )
day = '2/8/2022';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
timeOpen = '11:46:40';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
timeClose = '13:54:48';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
Fs = 1600;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
convFactor = 0.000000030518510385491027;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD channel
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
ADChan = 31;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input
% Inverted input is false.
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.inverted ) && ~hdrInfo.inverted )

%% Test enabling of DSP delay
% delayEnabled is false.
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.delayEnabled ) && ~hdrInfo.delayEnabled )

%% Test DSP delay value
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );
delay = 1969;
assert( abs( hdrInfo.delay - delay ) < eps )




