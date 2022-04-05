%% Test that output is structure
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
assert( isstruct( hdrInfo ) )

%% Test day
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
day = '2/10/2011';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
timeOpen = '10:9:33';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
timeClose = '13:3:33';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
Fs = 2713.000000;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
convFactor = 0.0000000458;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD name
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
ADName = 'CSC1';
assert( strcmp( hdrInfo.ADName, ADName ) );

%% Test AD channel
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
ADChan = 0;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input
% Inverted input is true.
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.inverted ) && hdrInfo.inverted )

%% Test low cut
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
lowCut = 1.000000;
assert( abs( hdrInfo.lowCut - lowCut ) < eps )

%% Test high cut
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
highCut = 500.000000;
assert( abs( hdrInfo.highCut - highCut ) < eps )

%% Test enabling of DSP delay
% delayEnabled is false.
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
assert( islogical( hdrInfo.delayEnabled ) && ~hdrInfo.delayEnabled )

%% Test DSP delay value
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );
delay = 0;
assert( abs( hdrInfo.delay - delay ) < eps )




