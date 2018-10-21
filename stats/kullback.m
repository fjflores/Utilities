function [ KLD, D, Dinv ] = kullback( pdf1, pdf2, dx );
% KULLBACK computes kullbac-leibler divergence between two pdf's.
% 
% Usage:
% [ KLD, D, Dinv ] = kullback( pdf1, pdf2 )
% 
% Input:
% pdf1, pdf2 = pdf's to evaluate. Must have the same number of elements,
% dx: sampling interval of the RV.
% 
% Output:
% KLD: Simmetric K-L divergence, independent of which is the refernce pdf.
% D: Standard K-L divergence, where pdf1 is the reference.
% Dinv: Inverted K-L diveregence, where pdf2 is the reference. If pdf1 and
% pdf2 are gaussians with the same variance but different mean, D = Dinv.
% 
% Reference:
% Berger et al, 

KL = dx * sum( pdf1 .* ( log( pdf1 ) - log( pdf2 ) ) );
KLinv = dx * sum( pdf2 .* ( log( pdf2 ) - log( pdf1 ) ) );
KLD = 1 ./ ( ( 1 ./ KL ) + ( 1 ./ KLinv ) );