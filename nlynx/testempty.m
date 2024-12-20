% Load known connected files
recDir = 'E:\Code\Matlab\Utilities_akira\nlynx\TestData';

%% Test connected status
connTst = [ false false false false true ]';
[ emptyFiles, fName ] = getempty( recDir );
assert( isequal( emptyFiles, connTst ) )

%% Test file names
fnTst =  {...
    'sampleCSC2-17.ncs';...
    'sampleCSC2-28.ncs';...
    'sampleCSC3-23.ncs';...
    'sampleCSC3-25.ncs';...
    'sampleEmptyCSC3-7.ncs' };
[ emptyFiles, fName ] = getempty( recDir );
assert( isequal( fnTst, fName ) )

%% Test some file connected
connTst = [ false false true ]';
fnTst =  {...
    'sampleCSC2-17.ncs';...
    'sampleCSC2-28.ncs';...
    'sampleEmptyCSC3-7.ncs' };
[ emptyFiles, fName ] = getempty( recDir, fnTst );
assert( isequal( emptyFiles, connTst ) )

%% Test some file names
fnTst =  {...
    'sampleCSC2-17.ncs';...
    'sampleCSC2-28.ncs';...
    'sampleEmptyCSC3-7.ncs' };
[ emptyFiles, fName ] = getempty( recDir, fnTst );
assert( isequal( fnTst, fName ) )
