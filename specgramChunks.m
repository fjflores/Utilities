function specgramChunks(subjectID,session,fileName,epochLength)

% load n-seconds chunks of data from continuously sampled channels and
% computes the spectrogram.
% this should

% future function arguments
% fileName = 'CSC1.ncs';
% epochLength = 3600; % length of lfp chunk in secs.

% set up folders
dataFolder = ['D:\BiomimeticSleepData\BF_recording_stimulation\' subjectID '\' session];
resFolder = ['D:\BiomimeticSleepData\BF_recording_stimulation\' subjectID '\' session '_Results\'];

% extract timestamps, FS, number of Samples and HDR from the CSC file
cd(dataFolder)
[ts,Fs,numSamp,HDR] = Nlx2MatCSC_v4(fileName,[1 0 1 1 0],1,1);
Fs = Fs(1); % save onlyt first sampling frequency.

% process Timestamps
fTs = ts(1); % save first ts to relativize with respect to it
% d = diff(ts); % get interval between record ts
% r = d(1)/512; % get 512th interval size
% tbase = repmat(linspace(0,d(1)-r,512)',1,length(numSamp)); % create base matrix with time intervals
% treal = tbase+repmat(ts,512,1); % sum base timestamps with real ts's.
% trel = treal(:)-fTs; % vectorizes treal matrix and substract first ts to get relative time

% read acquisition time from header
begin = ffhms2secs(HDR{3}(end-12:end-1));
ends = ffhms2secs(HDR{4}(end-12:end-1));
elapsed = ends-begin;
disp(['Acq. Time = ' num2str(elapsed) ' secs (from header)'])
disp(['Equivalent to ' ffsecs2hms(elapsed) ' hr'])
disp(' ')

% compute recording time from number of Samples
% computation is explained in Lab Notebook 4 page 109
validSamples = (length(numSamp)-1)*512 + numSamp(end);
recTime = validSamples/Fs(1);
disp(['Rec. Time = ' num2str(recTime) ' secs'])
disp(['Equivalent to ' ffsecs2hms(recTime) ' hr'])
disp(['Valid samples: ' num2str(validSamples)])
disp(' ')

% compute number of epochs in recording time
nSamples = epochLength*Fs;
nTs = epochLength*1e6;
nEpochs = floor(validSamples/nSamples);
disp(['Computed epochs for ' num2str(epochLength) ' are ' num2str(nEpochs)])
cnt = 0;
for iEpoch = 1:nEpochs
    disp([' Processing channel ' fileName])
    cnt = cnt+1;
    if cnt == 1
        epochBegin = fTs;
        epochEnd = fTs + nTs;
    else
        epochBegin = epochEnd+1;
        epochEnd = fTs + nTs*cnt
    end
    
    % The following will extract:
    % - data epoch
    data = Nlx2MatCSC_v4(fileName,[0 0 0 0 1],0,4,[epochBegin epochEnd]);
    eegMult = str2num(HDR{15}(13:end));
    data = data(:)*eegMult*1000;
    %     subData = data(1:4:end);
    %     subFS = FS/4;
    %     disp(['  Subsampling 4 times. New FS = ' num2str(subFS)])
    data = detrend(data);
    
    % setting the parameters for the multitaper analysis. Resolution set to
    % 0.5 Hz for a 2 sec window
    params = struct(...
        'tapers',[1 2],...
        'pad',-1,...
        'Fs',Fs,...
        'fpass',[0.5 55]);
    
    % compute spectrogram
    disp(['  Computing spectrogram for channel ' fileName(1:end-4) '...'])
    [S,t,f] = mtspecgramc(data,[2 1],params);
    figure
    imagesc(t,f,10*log10(S')), axis xy
    pbaspect([2 1 1])
%     pause
    %     subplot(nEpochs/2,2,)
    a
    % make results folder, and save
    disp(' Saving')
    try
        cd(resFolder)
    catch mE1
        if ~exist(resFolder,'dir')
            fprintf('...creating directory %s\n',resFolder);
            mkdir(resFolder)
            cd(resFolder)
        end
    end
    file2Save = ['Specgram_' fileName(1:end-4) '_' num2str(cnt) 'h'];
    save(file2Save,'S','t','f')
end
