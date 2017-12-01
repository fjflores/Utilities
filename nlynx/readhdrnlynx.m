function readhdrnlx(file)

% will extract and display useful information from the header, to test
% recording durations mainly

[Fs,numSamp,HDR] = Nlx2MatCSC_v4(fileName,[0 0 1 1 0],1,1);
Fs = Fs(1); % save onlyt first sampling frequency.

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