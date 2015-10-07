function [smEmg,ts] = smoothemg(fileName,bin,epoch)

% SMOOTHEMG rectifies emg and takes a sample every 'bin' secs.
% INPUT:    fileName: emg continuous file
%           bin: bin size in seconds
%           epoch: epoch to extract, in secs.
% OUTPUT:   smEmg: smoothed (?) emg.
%           ts: timestamps to plot.

% (c) Francisco J. Flores 2010-07-01

% remember to implement epoch extraction

if nargin < 2
    bin = 1;
elseif nargin < 3
    epoch = [];
end

% check that the file extension is present
if isempty(strfind(fileName,'ncs'))
    fileName = [fileName '.ncs'];
end

if isempty(epoch)
    % get only sampling frequency and emg
    [emg,hdr]=nlx2matCSC(...
        fileName,...
        [0 0 0 0 1],...
        1,...
        1,...
        []);
else
    % place epoch extraction here
    disp([' Processing from EMG ' ffsecs2hms(epoch(1)) ' to ' ffsecs2hms(epoch(2))])
    epoch = epoch*1000000;
    [emg,hdr] = Nlx2MatCSC(...
        fileName,...
        [0 0 0 0 1],...
        1,...
        4,...
        epoch);
end

% get Fs from header
Fs = str2num(hdr{13}(20:end));

% process emg
emg = emg(:); % linearize
smEmg = abs(emg(1:bin*Fs:end)); % rectify and subsample
clear emg
adBitVolt = str2num(hdr{15}(13:end)); % get adBitVolt factor
smEmg = smEmg*adBitVolt*1000; % convert bits to mV

% get timestamps to help with plotting
if isempty(epoch)
    ts = nlx2matCSC(...
        fileName,...
        [1 0 0 0 0],...
        0,...
        1,...
        []);
else
    % place epoch extraction here
    ts = Nlx2MatCSC(...
        fileName,...
        [1 0 0 0 0],...
        0,...
        4,...
        epoch);
end
dummy = linspace(ts(end),ts(end)+188720,512);
lastTs = dummy(end);
tsEpoch = [ts(1) lastTs]/1000000;
clear ts
ts = linspace(tsEpoch(1),tsEpoch(2),length(smEmg));




