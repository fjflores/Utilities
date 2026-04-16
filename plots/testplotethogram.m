function tests = testplotethogram
tests = functiontests( localfunctions );

end

%% --- Vector input, default options ---
function testvectorinput( testCase )
states = [ 1 1 2 2 3 3 1 1 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states );
ax = gca;
children = findobj( ax, 'Type', 'surface' );
verifyNotEmpty( testCase, children, 'pcolor surface not created' )

end

%% --- Matrix input (non-binary values get binarized) ---
function testmatrixinput( testCase )
ethoMat = [ 1 0 0; 1 0 0; 0 2 0; 0 2 0; 0 0 3; 0 0 3 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( ethoMat );
ax = gca;
children = findobj( ax, 'Type', 'surface' );
verifyNotEmpty( testCase, children, 'pcolor surface not created' )

end

%% --- Binary matrix input ---
function testbinarymatrix( testCase )
ethoMat = [ 1 0 0; 1 0 0; 0 1 0; 0 1 0; 0 0 1; 0 0 1 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( ethoMat );
ax = gca;
children = findobj( ax, 'Type', 'surface' );
verifyNotEmpty( testCase, children, 'Binary matrix should produce surface' )

end

%% --- Custom timestamps ---
function testcustomtimestamps( testCase )
states = [ 1 1 2 2 3 3 ];
t = 0 : 0.5 : 2.5;
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, t );
ax = gca;
xLim = get( ax, 'XLim' );
verifyGreaterThanOrEqual( testCase, xLim( 2 ), t( end ) )

end

%% --- SingleRow mode ---
function testsinglerow( testCase )
states = [ 1 1 2 2 3 3 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, [], 'SingleRow', true );
ax = gca;
yLim = get( ax, 'YLim' );
verifyEqual( testCase, yLim, [ 1 2 ] )

end

%% --- StateNames option ---
function teststatenames( testCase )
states = [ 1 1 2 2 3 3 ];
names = { 'Wake', 'NREM', 'REM' };
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, [], 'StateNames', names );
ax = gca;
tickLabels = get( ax, 'YTickLabel' );
verifyEqual( testCase, tickLabels, names(:) )

end

%% --- States filter option ---
function teststatesfilter( testCase )
states = [ 1 1 2 2 3 3 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, [], 'States', [ 1 3 ] );
ax = gca;
yLim = get( ax, 'YLim' );
verifyEqual( testCase, yLim, [ 1 3 ] )

end

%% --- PlotLines false ---
function testnolines( testCase )
states = [ 1 1 2 2 3 3 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, [], 'PlotLines', false );
ax = gca;
lines = findobj( ax, 'Type', 'line' );
verifyEmpty( testCase, lines, 'Lines should not be plotted' )

end

%% --- PlotLines true ---
function testwithlinesdefault( testCase )
states = [ 1 1 2 2 3 3 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, [], 'PlotLines', true );
ax = gca;
lines = findobj( ax, 'Type', 'line' );
verifyNotEmpty( testCase, lines, 'Lines should be plotted by default' )

end

%% --- Column vector input ---
function testcolumnvector( testCase )
states = [ 1; 1; 2; 2; 3; 3 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states );
ax = gca;
children = findobj( ax, 'Type', 'surface' );
verifyNotEmpty( testCase, children, 'Column vector should work' )

end

%% --- SingleRow with non-contiguous state labels ---
function testsinglerownoncontiguous( testCase )
states = [ 1 1 3 3 5 5 ];
fig = figure( 'Visible', 'off' );
cleanup = onCleanup( @() close( fig ) );
plotethogram( states, [], 'SingleRow', true );
ax = gca;
children = findobj( ax, 'Type', 'surface' );
verifyNotEmpty( testCase, children, 'Non-contiguous states in SingleRow' )
yLim = get( ax, 'YLim' );
verifyEqual( testCase, yLim, [ 1 2 ] )

end
