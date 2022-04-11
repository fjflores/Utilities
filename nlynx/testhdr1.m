% Test parse of header 1
load( 'TestData\testHdr1' )
hdrInfo = parsehdrnlynx( hdr );

% Precondition: test that output is structure
assert( isstruct( hdrInfo ), 'Output is not a structure!' )

%% Test day
day = '2/10/2011';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
timeOpen = '10:9:33';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
timeClose = '13:3:33';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
Fs = 2713.000000;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
convFactor = 0.0000000458;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD name
ADName = 'CSC1';
assert( strcmp( hdrInfo.ADName, ADName ) );

%% Test AD channel
ADChan = 0;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input
% Inverted input is true.
assert( islogical( hdrInfo.inverted ) && hdrInfo.inverted )

%% Test low cut
lowCut = 1.000000;
assert( abs( hdrInfo.lowCut - lowCut ) < eps )

%% Test high cut
highCut = 500.000000;
assert( abs( hdrInfo.highCut - highCut ) < eps )

%% Test enabling of DSP delay
% delayEnabled is false.
assert( islogical( hdrInfo.delayEnabled ) && ~hdrInfo.delayEnabled )

%% Test DSP delay value
delay = 0;
assert( abs( hdrInfo.delay - delay ) < eps )
