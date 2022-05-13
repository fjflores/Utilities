% Load test data for Cheetah 5.7
csc = readcsc('TestData\sampleCSC3-23');

%% Test sampling frequency
Fs = 1600;
assert( abs( csc.Fs - Fs ) < eps )

%% Test correct header
timeOpen = '12:44:40';
assert( strcmp( csc.hdr.timeOpen, timeOpen ) )

%% Test first data point
data1 = 8.85009765625;
assert( abs( csc.data( 1 ) - data1 ) < eps )

%% Test last data point
dataEnd = -0.244140625;
assert( abs( csc.data( end ) - dataEnd ) < eps )

%% Test first timestamp
ts1 = 2322115666736;
assert( csc.rawTs( 1 ) == ts1 )
assert( csc.tStamps( 1 ) == ts1 )

%% Test last raw timestamp
tsEnd = 2325874066736;
assert( csc.rawTs( end ) == tsEnd )

%% Test last interpolated timestamp
tsEnd = 2325874386111;
assert( csc.tStamps( end ) == tsEnd )

%% Test last relative ts
tsEnd = 3758719375;
assert( csc.relTs( end ) == tsEnd )

%% Test last valid sample
lastVal = 486;
assert( csc.valSamps( end ) == lastVal )


