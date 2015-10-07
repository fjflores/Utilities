% explore lfps, emg and eeg. for use with spike sleep scoring


subplot(3,1,1)
load Specgram_CSC5.mat
imagesc(t,f,10*log10(S')), axis xy
set(gca,'fontname','palatino linotype')
title('Rat: R100325; Session: 100608; CSC5','interpreter','latex')

subplot(3,1,2)
bar(t,emg(2:14443))
set(gca,'fontname','palatino linotype')
title('Rat: R100325; Session: 100608; EMG','interpreter','latex')
axis tight

subplot(3,1,3)
load Specgram_CSC15.mat
imagesc(t,f,10*log10(S')), axis xy
set(gca,'fontname','palatino linotype')
title('Rat: R100325; Session: 100608; EEG','interpreter','latex')

print('CSC5_EMG_EEG','-depsc2')