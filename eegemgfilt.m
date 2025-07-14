function dataFilt = eegemgfilt( data, fBand, Fs )
% EEGEMGFILT helper fx to bandpass filter eeg and emg.
% 
% Eegemgfilt band-pass filter single or multi-channel time-series signals,
% mainly eeg and emg. It uses a non-causal filtering algorithm and 
% 
% Usage:
% dataFilt = eegfilt( data, fBand, Fs )
% 
% Input:
% data: data matrix in samples x channels format.
% fBand: filter band in [ low high ] cut format.
% Fs: sampling frequency.
% 
% Output:
% dataFilt: matrix with filtered data, same format as 'data'.

Ny = Fs / 2;
order = 1024;
b = fir1( order, fBand / Ny );
h = hamming( length( b ) );
bSmooth = b .* h';
dataFilt = filtfilt( bSmooth, 1, data );