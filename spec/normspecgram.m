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

nSpec = size( S, 3 );
if nSpec == 1
    fprintf( 'Normalizing spectrogram via %s %s\n', meth, sTrans )
    
else
    fprintf( 'Normalizing spectrograms %s %s\n', meth, sTrans )
    
end

for specIdx = 1 : nSpec
    baseIdx = t >= baseEpoch( 1 ) & t <= baseEpoch( 2 );
    Sbase = squeeze( S( baseIdx, :, specIdx ) );
    S2proc = squeeze( S( :, :, specIdx ) );
    [ m, n ] = size( S2proc );
    muBase = mean( Sbase );
    sdBase = std( Sbase );
    
    % compute normalized
    if strcmp( sTrans, 'log' )
        switch meth
            case 'median'
                % subtract median
                muMat = repmat( median( Sbase ), m, 1 );
                normS( :, :, specIdx ) = S2proc - muMat;
                
            case 'mean'
                % subtract mean
                muMat = repmat( muBase, m, 1 );
                normS( :, :, specIdx ) = S2proc - muMat;
                
            otherwise
                error( 'Bad method and/or transformation')
                
        end
        
    elseif strcmp( sTrans, 'nolog' )
        switch meth
            case 'perc'
                % get percent change from the mean
                muMat = repmat( muBase, m, 1 );
                normS( :, :, specIdx ) = 100 * ( ( S2proc - muMat ) ./ muMat );
                
            case 'ratio'
                % get power ratio
                muMat = repmat( muBase, m, 1 );
                normS( :, :, specIdx ) = S2proc ./ muMat;
                
            case 'zscore'
                % get z-scored spectrogram
                muMat = repmat( muBase, m, 1 );
                sdMat = repmat( sdBase, m, 1 );
                normS( :, :, specIdx ) = ( S2proc - muMat ) ./ sdMat;
                
            case 'median'
                % get median normalized spec
                medS = repmat( median( Sbase ), m, 1 );
                normS( :, :, specIdx ) = S2proc ./ medS;
                
        end
        
    end
    
end