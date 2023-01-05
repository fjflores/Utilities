function [ normS, muBase, sdBase ] = normspecgram( S, t, baseEpoch, meth, sTrans )

%NORMSPECGRAM computes percent change for specgrams
%
% Usage:
% [ normS, muS, sdS ] = normspecgram( S, t, baseEpoch, meth, sTrans )
% computes the normalized spectrogram given a baseline period.
%
% Input:
%   S:          Spectrogram matrix in times x freq dimensions.
%   t:          Time vector for spectrogram.
%   baseEpoch:  Two-vector element with baseline times.
%   meth:       method used to normalize:
%               percent: percent deviation from median baseline.
%               ratio: ratio to mean baseline.
%               zscore: z-score to mean and std. dev. baseline.
%               median: ratio to median baseline. Default.
%   sTrans:     transforms the spectrum. If 'nolog', then normalizations
%               are computed on baseline spectrum. If 'log', normalizations
%               are computed on decibel spectrums.
%
% Output:
%   normS:      nmormalized spectrogram.
%   muS:        mean of bseline.
%   sdS:        standard deviation of baseline

% (C) 2012 Francisco J. Flores

if nargin < 4
    meth = 'median';
    sTrans = 'nolog';
    
elseif nargin < 5
    sTrans = 'nolog';
    
end

if strcmp( sTrans, 'log' )
    S = 10 * log10( S );
    
end

% [ ~, baseIdx ] = replaceartifact(...
%     S, t, baseEpoch, 'nan' );
baseIdx = t >= baseEpoch( 1 ) & t <= baseEpoch( 2 );
Sbase = S( baseIdx, : );
[ m, n ] = size( S );
muBase = mean( Sbase );
sdBase = std( Sbase );

% compute normalized
disp( 'Normalizing spectrogram' )
disp( 'Using method:' )
if strcmp( sTrans, 'log' )
    switch meth
        case 'median'
            % subtract median
            disp( ' Median subtraction' )
            muMat = repmat( median( Sbase ), m, 1 );
            normS = S - muMat;
            
        case 'mean'
            % subtract mean
            disp( ' Mean subtraction' )
            muMat = repmat( muBase, m, 1 );
            normS = S - muMat;
            
        otherwise
            error( 'Bad method and/or transformation')
            
    end
    
elseif strcmp( sTrans, 'nolog' )
    switch meth
        case 'perc'
            % get percent change from the mean
            disp( ' Percent of mean baseline' )
            muMat = repmat( muBase, m, 1 );
            normS = 100 * ( ( S - muMat ) ./ muMat );
            
        case 'ratio'
            % get power ratio
            disp( ' Ratio to mean baseline' )
            muMat = repmat( muBase, m, 1 );
            normS = S ./ muMat;
            
        case 'zscore'
            % get z-scored spectrogram
            disp( ' Z-score' )
            muMat = repmat( muBase, m, 1 );
            sdMat = repmat( sdBase, m, 1 );
            normS = ( S - muMat ) ./ sdMat;
            
        case 'median'
            % get median normalized spec
            disp( ' Ratio to median baseline' )
            medS = repmat( median( Sbase ), m, 1 );
            normS = S ./ medS;
            
    end
    
end
