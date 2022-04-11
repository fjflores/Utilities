function tests = testrawhdr
tests = functiontests( localfunctions );

end

% Test that output is cell with normal call
function testiscell( testCase )
fileName = 'testData\sampleCSC3-25.ncs';
hdrRaw = getrawhdr( fileName );
verifyClass( testCase, hdrRaw, 'cell' )

end

% Test without extension but correct file type
function testwoext( testCase )
fileName = 'testData\sampleCSC3-25';
hdrRaw = getrawhdr( fileName );
verifyClass( testCase, hdrRaw, 'cell' )

end

% Test error with incorrect file type with extension
function testwrongtype( testCase )
fileName = 'testData\sampleSE.nse';
actual = @() getrawhdr( fileName );
errType = 'Utilities:Nlynx';
verifyError( testCase, actual, errType )

end

% Test error with incorrect file type wo extension
function testwrongtypenoext( testCase )
fileName = 'testData\sampleSE';
actual = @() getrawhdr( fileName );
errType = 'Utilities:Nlynx';
verifyError( testCase, actual, errType )

end

% Test error with wrong file.
function testwrongfile( testCase )
fileName = 'testData\testHdr1.mat';
actual = @() getrawhdr( fileName );
errType = 'Utilities:Nlynx';
verifyError( testCase, actual, errType )

end