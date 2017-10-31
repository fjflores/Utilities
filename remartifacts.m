function [dataClean,tClean] = remartifacts(signal)

% clean the lfp from artifacts and sleep epochs
% Input:
%   signal:  csc object from readnlynx, with artifact times as field
%
% Output:
%   dataClean:  original data, but with artifact removed.
%   tClean:     original timestamps, with artifact times removed.

% (C) 2011 Francisco J. Flores

times = signal.artifact.times;
ts = signal.ts;
data = signal.data(:);
tsKeep = ts;

%% first, remove artifact epochs
hWB = waitbar(0,'Removing artifacts...');
for i = 1:size(times,1)
        tsKeep(tsKeep > times(i,1) & tsKeep < times(i,2)) = [];
        waitbar(i./size(times,1))
end
close(hWB)

% %% then, remove sleep epochs
% for i = 1:length(sleepOn)
%     tsKeep(tsKeep > sleepOn(i) & tsKeep < sleepOff(i)) = [];
% end

tsIdx = ismember(ts,tsKeep);
dataClean = data(tsIdx);
tClean = ts(tsIdx);

    