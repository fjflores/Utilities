% Test parse of header 1
load( 'TestData\testHdr3' )
hdrInfo = parsehdrnlynx( hdr );

% Precondition: test that output is structure
assert( isstruct( hdrInfo ), 'Output is not a structure!' )

%% Test day
day = '2022/03/22';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
timeOpen = '12:44:40';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
timeClose = '15:11:00';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
Fs = 1600;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
convFactor = 0.000000061035156250000001;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD name
ADName = 'CSC25';
assert( strcmp( hdrInfo.ADName, ADName ) );

%% Test AD channel
ADChan = 23;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input
% Inverted input ios false.
assert( islogical( hdrInfo.inverted ) && ~hdrInfo.inverted )

%% Test enabling of DSP delay 
assert( islogical( hdrInfo.delayEnabled ) && hdrInfo.delayEnabled )

%% Test DSP delay value
delay = 1969;
assert( abs( hdrInfo.delay - delay ) < eps )




