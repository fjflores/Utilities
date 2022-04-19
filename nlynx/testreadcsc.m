% Load test data for Cheetah 5.7
csc = readlfpnlynx('TestData\sampleCSC3-25');

%% Test sampling frequency
Fs = 1600;
assert( abs( csc.Fs - Fs ) < eps )

%% Test that Hdr is cell
assert( iscell( csc.Hdr ) )

%% Test first data point
data1 = 18.37158203125;
assert( abs( csc.Data( 1 ) - data1 ) < eps )

%% Test last data point
dataEnd = 0.67138671875;
assert( abs( csc.Data( end ) - dataEnd ) < eps )

%% Test first timestamp
ts1 = 2322115.666736;
asert( abs( csc.ts( 1 ) - ts1 ) < eps )
