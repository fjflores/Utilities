function [times,idx] = findartifacts2(signal,factor)

% artifacts are defines as any amplitude event greater than 6 sigma

% Input
%   signal:   continuous time series object, like the one from readnlynx
%   factor:   factor to multiply by sigma. Will be used as threshold.
%           Default: 6.
%
% Output:
%   times:  2 column matrix, with rows equals to artifact start and end
%           times.
%   idx:    2 column matrix, with rows equal to artifact start and end
%           indexes.

% (C) 2011 Francisco J. Flores

% test nargin
if nargin < 2
    factor = 6;
    fprintf(' No amplitude factor provided.\n Using default (%d*sigma)\n',...
        factor)
end

% extract relevant data from signal object
data = signal.data;
[m,n] = size(data);
% test column data format
if m == 1
    data = data';
elseif n == 1
    data = data;
else
    data = data(:);
end

Fs = signal.Fs;
t = signal.ts;

% computing sigma and envelope
sigma = std(data);
disp(' Computing envelope...')
amp = sqrt(real(hilbert(data)).^2 + imag(hilbert(data)).^2);
win = hamming(round(Fs*.1)); % smooth with a 100 msec window
areaWin = cumsum(win);
normWin = win./areaWin(end); % normalize window dividing by the area
disp(' Smoothing envelope')
smoothAmp = filtfilt(normWin,1,amp);
idxPeaks = smoothAmp > factor*sigma; % find amplitudes greater tha six sigma

if sum(idxPeaks) > 0
    % establish artifact epochs, by looping through idx peaks. Find points with
    % differences == -1 for start and differences == 1 for epoch ends.
    idxPeaks = [0; idxPeaks; 0];
    dPeaks = diff(idxPeaks);
    idxOn = find(dPeaks == 1);
    idxOff = find(dPeaks == -1);
    if idxOff(end) > numel(data)
        idxOff(end) = numel(data);
    end
    
    % Then, look for the first sample before the artifact start that has a value
    % lesser than sigma/3.
    hWB = waitbar(0,'Find artifact start point...');
    detectCount = 1;
    for i = 1:length(idxOn)
        detect =  false;
        count = 1;
        while detect == false
            if (idxOn(i) - count) > 0
                if amp(idxOn(i) - count) < sigma/2
                    actIdxOn(detectCount,1) = idxOn(i) - count;
                    detectCount = detectCount + 1;
                    detect = true;
                else
                    count = count + 1;
                end
            else
                actIdxOn(detectCount,1) = idxOn(i);
                detectCount = detectCount + 1;
                detect = true;
            end
            
        end
        waitbar(i./length(idxOff))
    end
    close(hWB)
    
    clear count detectCount detect
    
    hWB = waitbar(0,'Find artifact end point...');
    detectCount = 1;
    lastSample = numel(amp);
    for i = 1:length(idxOff)
        detect =  false;
        count = 1;
        while detect == false
            if (idxOff(i) + count) < lastSample
                if amp(idxOff(i) + count) < sigma/2
                    actIdxOff(detectCount,1) = idxOff(i) + count;
                    detectCount = detectCount + 1;
                    detect = true;
                    
                else
                    count = count + 1;
                end
                
            else
                actIdxOff(detectCount,1) = lastSample;
                detectCount = detectCount + 1;
                detect = true;
            end
        end
        waitbar(i./length(idxOff))
    end
    close(hWB)
    
    % consider artifacts that are less than 1 s apart as the same event
    disp(' Joining close artifacts')
    count = length(actIdxOff)-1;
    for i = 1:count
        distance = t(actIdxOn(i+1)) - t(actIdxOff(i));
        if distance < 1
            actIdxOn(i+1) = NaN; actIdxOff(i) = NaN;
        end
    end
    
    actIdxOn(isnan(actIdxOn)) = [];
    actIdxOff(isnan(actIdxOff)) = [];
    
    idx = [actIdxOn actIdxOff];
    times = [t(actIdxOn) t(actIdxOff)];
    
else
    disp(' No artifacts found!')
    idx = [];
    times = [];
    
end


