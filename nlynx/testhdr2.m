% Test parse of header 1
load( 'TestData\testHdr2' )
hdrInfo = parsehdrnlynx( hdr );

% Precondition: test that output is structure
assert( isstruct( hdrInfo ), 'Output is not a structure!' )

%% Test day
day = '2/8/2022';
assert( strcmp( hdrInfo.day, day ) )

%% Test time file was open
timeOpen = '11:46:40';
assert( strcmp( hdrInfo.timeOpen, timeOpen ) )

%% Test time file was closed
timeClose = '13:54:48';
assert( strcmp( hdrInfo.timeClose, timeClose ) )

%% Test Fs
Fs = 1600;
assert( abs( hdrInfo.Fs - Fs ) < eps )

%% Test conversion factor
convFactor = 0.000000030518510385491027;
assert( abs( hdrInfo.convFactor - convFactor ) < eps )

%% Test AD name
ADName = 'CSC1';
assert( strcmp( hdrInfo.ADName, ADName ) );

%% Test AD channel
ADChan = 31;
assert( abs( hdrInfo.ADChan - ADChan ) < eps )

%% Test inverted input
% Inverted input is false.
assert( islogical( hdrInfo.inverted ) && ~hdrInfo.inverted )

%% Test low cut
lowCut = 0.1;
assert( abs( hdrInfo.lowCut - lowCut ) < eps )

%% Test high cut
highCut = 500;
assert( abs( hdrInfo.highCut - highCut ) < eps )

%% Test enabling of DSP delay
% delayEnabled is false.
assert( islogical( hdrInfo.delayEnabled ) && ~hdrInfo.delayEnabled )

%% Test DSP delay value
delay = 1969;
assert( abs( hdrInfo.delay - delay ) < eps )




