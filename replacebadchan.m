function cleanSig = replacebadchan( sigMat, goodCh )
% REPLACEBADCHAN replaces bad channels with NaN's
% 
% Usage:
% cleanSig = replacebadchan( sigMat, ch2rep )
% 
% Input:
% sigMat: matrix of multichannel signals. smaples x channels.
% goodCh: lolgical index vector with good channels.
% 
% Output:
% cleanSig: matrix of signals with bad channels replaced with nans.

% Check input.
[ m, n ] = size( sigMat );
if m == 1
    error( 'Signal shoud have more than one sample' )
    
elseif n == 1
    error( 'Signal shoud have more than one channel.' )
    
elseif m < n
    error( 'Signal matrix should be in samples x channels format.' )
    
end

% Do the replacement
badCh = ~goodCh;
nanVec = nan( m, sum( badCh ) );
sigMat( :, badCh ) = nanVec;
cleanSig = sigMat;


