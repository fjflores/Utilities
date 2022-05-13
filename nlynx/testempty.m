% Load known connected files
recDir = 'D:\Code\Matlab\Utilities\nlynx\TestData';

%% Test connected status
connTst = [ false false false false true ]';

[ emptyFiles, fName ] = getempty( recDir );
assert( isequal( emptyFiles, connTst ) )

%% Test file names
recDir = 'D:\Code\Matlab\Utilities\nlynx\TestData';
fnTst =  {...
    'sampleCSC2-17.ncs';...
    'sampleCSC2-28.ncs';...
    'sampleCSC3-23.ncs';...
    'sampleCSC3-25.ncs';...
    'sampleEmptyCSC3-7.ncs' };
[ emptyFiles, fName ] = getempty( recDir );
assert( isequal( fnTst, fName ) )