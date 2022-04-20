% Load test data for Cheetah 5.7
csc = readcsc('TestData\sampleCSC3-25');

%% Test sampling frequency
Fs = 1600;
assert( abs( csc.Fs - Fs ) < eps )

%% Test correct header
timeOpen = '12:44:40';
assert( strcmp( csc.Hdr.timeOpen, timeOpen ) )

%% Test first data point
data1 = 18.37158203125;
assert( abs( csc.Data( 1 ) - data1 ) < eps )

%% Test last data point
dataEnd = 0.67138671875;
assert( abs( csc.Data( end ) - dataEnd ) < eps )

%% Test first timestamp
ts1 = 2322115.666736;
assert( abs( csc.ts( 1 ) - ts1 ) < eps )
