% Average 10 second epochs of emg data.
% problems:
% - out of memory
% - subs vector is not being created properly

%% for out of memory, subsample 2 points... bold, but quick.
% the plot looks fine, of course higher frequencies are lost, but the
% overall waveform is fairly well preserved.
% still out of memory!!
clear all
[tS,emg]=nlx2matCSC_v4(...
    'CSC16_epoch.ncs',...
    [1 0 0 0 1],...
    0,...
    1,...
    []); % read emg file
Fs = 2713; % set sampling frequency
emg = emg(:);  % vectorize emg
emgSub = emg(1:2:end); % subsampling emg
clear emg 
absEmg = abs(emgSub);
L = length(absEmg);
clear emgSub
nEpochs = floor(L/((Fs/2)*10)); % compute number of 10 secs epochs
epochLengt = (Fs/2)*10;
a = repmat(1:nEpochs,epochLengt,1);
aT = a(:);
clear a tS
aveAmplitude = accumarray(aT,absEmg(1:25420810),[],@mean);
%%
clear all
[tS,emg]=nlx2matCSC_v4(...
    'CSC16_epoch.ncs',...
    [1 0 0 0 1],...
    0,...
    1,...
    []); % read emg file
Fs = 2713; % set sampling frequency
absEmg = abs(emg(:)); % vectorize emg
L = length(absEmg);
clear emg
save('temp','absEmg','tS') % save a temporal file with variables to HDD
clear tS
for i = 1:2
    newL = floor(length(absEmg)/2);
    if i == 1
        newEmg = absEmg(1:newL);
        clear absEmg
        nEpochs = floor(length(newEmg)/(Fs*10));
        a = repmat(1:2713*10,nEpochs,1); % creates a base matrix
        % a = a'; % transpose base matrix
        subs = a(:); %  create a vector of indices to accumulate from the base matrix
        % absEmg(length(subs)+1:end)=[];
        clear a
        newEmg(length(subs)+1:end)=[];
        aveAmplitude = accumarray(subs,newEmg,[],@mean); % apply mean function to the specified indices
    end
end