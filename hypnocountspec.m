function hypnocountspec(cellTs,sleepScore,spec,epoch,offset)

%HYPNOCOUNTSPEC plots hypnograms, spike counts and specgrams in a figure
%
% it works for a hypnogram session, one cell and one specgram. you can
% choose either the EEG specgram or the unit LFP specgram.
% INPUTS:   cellTs:     cell timestamps.
%           sleepScore: structure output from IMPORTSPIKEHYPNO.
%           specFile:   specgram to load from SPECGRAMLFP.
%           epoch:      2 element vector with epoch to look at. if empty, all.
%           offset:     hypnogram time offset.
%
% (c) 27-May-2010 Francisco J. Flores

% update this function to plot the hypnogram using plothypno

% get hypnogram and time
hypno = sleepScore.hypno;
tHyp = sleepScore.t;

% plot hypnogram, offset corrected
tHyp = tHyp+offset; % correct offset from reading stuff in spike2

% if no epoch input, use all record
if isempty(epoch)
    epoch = [tHyp(1) tHyp(end)];
end

% generate epoch index
idxEpoch = tHyp>=epoch(1) & tHyp<=epoch(2);
tHypEpoch = tHyp(idxEpoch);
hypnoEpoch = hypno(idxEpoch);

% compute spike count
tsSecs = cellTs/10000;
idxEpoch = tsSecs>=epoch(1) & tsSecs<=epoch(2);
tsEpoch = tsSecs(idxEpoch);
edgesPsth = tHypEpoch(1):10:tHypEpoch(end);
psth = histc(tsEpoch,edgesPsth);

% plot hypnogram
figure(1)
subplot(3,1,1)
stairs(tHypEpoch,hypnoEpoch,'k')
set(gca,'fontname','times new roman')
ylim([-1 4]), xlim([tsEpoch(1) tsEpoch(end)])
set(gca,'ytick',[0 1 2 3])
set(gca,'yticklabel',{'DOUBT'; 'WAKE'; 'NREM'; 'REM'})
box off
% title('R100325, session 100517')
clear idxEpoch

% plot spike count
subplot(3,1,2)
% [ts, numSpikes] = readMclustTfile('ST9_epoch_1.t');
bar(edgesPsth,psth/10)
set(gca,'fontname','times new roman')
box off
axis tight
xlim([tsEpoch(1) tsEpoch(end)])
% title('ST9, cluster 1')
ylabel('Spike rate (Hz)','fontname','times new roman')
clear idxEpoch

% plot specgram for EEG
tSpec = spec.t+tHyp(1); clear t
idxEpoch = tSpec>=epoch(1) & tSpec<=epoch(2);
tSpecEp = tSpec(idxEpoch);
subplot(3,1,3)
imagesc(tSpecEp,spec.f,10*log10(spec.S(idxEpoch,:)')), axis xy
set(gca,'fontname','times new roman')
xlabel('time (s)','fontname','times new roman')
ylabel('frequency (Hz)','fontname','times new roman')
box off
% title('EEG specgram','fontname','times new roman')


