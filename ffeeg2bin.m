function ffeeg2bin(filename)

% EEG2BIN converts AD files to Spike2 readbale binary files
% INPUT:    filename:   name of the file to be converted
% 
% The written file will contain all the eight channels from
% AD extracted passed through the eeg2mat function. The finction msut be
% invoked from the 'extracted' folder, and will create a folder named 'bin'
% containing the binary file to be read in spike. The channels are already
% converted to mV.

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 1...')
filename = [filename '.eeg'];
save('filename.mat','filename')
pre = eeg2mat(filename,1,'n');
chan1 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan1 = (chan1./2048)*1000;
chan1 = chan1./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan1(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are: ')
whos chan1
% pause
save('filename.mat','chan1','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 2...')
load('filename.mat','filename')
pre = eeg2mat(filename,2,'n');
chan2 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan2 = (chan2./2048)*1000;
chan2 = chan2./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan2(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');chan1
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan2
% pause
save('filename.mat','chan2','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 3...')
load('filename.mat','filename')
pre = eeg2mat(filename,3,'n');
chan3 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mVchan1
chan3 = (chan3./2048)*1000;
chan3 = chan3./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan3(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan3
% pause
save('filename.mat','chan3','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 4...')
load('filename.mat','filename')
pre = eeg2mat(filename,4,'n');
chan4 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan4 = (chan4./2048)*1000;
chan4 = chan4./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan4(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan4
% pause
save('filename.mat','chan4','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 5...')
load('filename.mat','filename')
pre = eeg2mat(filename,5,'n');
chan5 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan5 = (chan5./2048)*1000;
chan5 = chan5./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan5(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan5
% pause
save('filename.mat','chan5','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
load('filename.mat','filename')
disp('Processing channel 6...')
pre = eeg2mat(filename,6,'n');
chan6 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan6 = (chan6./2048)*1000;
chan6 = chan6./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan6(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan6
% pause
save('filename.mat','chan6','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 7...')
load('filename.mat','filename')
pre = eeg2mat(filename,7,'n');
chan7 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan7 = (chan7./2048)*1000;
chan7 = chan7./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan7(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan7
% pause
save('filename.mat','chan7','-append')
clear all
disp('Done!!!')
disp(' ')

% put continuous data in matlab format from eeg format
disp('')
disp('Processing channel 8...')
load('filename.mat','filename')
pre = eeg2mat(filename,8,'n');
chan8 = pre.data;
ts = pre.timestamp;
Fs = pre.info.samplefreq;
gain = pre.info.gain;
% clear pre
% convert data to mV
chan8 = (chan8./2048)*1000;
chan8 = chan8./gain;
% plot to check timestamps and channels
plot(ts(1:10000),chan8(1:10000))
axis tight
% xticklabel = get(gca,'xticklabel');
% timehms = ffsecs2hms(cell2mat(xticklabel));
% set(gca,'xticklabel',mat2cell(timehms));
disp('The variables are:')
whos chan8
% pause
save('filename.mat','chan8','-append')
clear pre
disp('Done with channel extraction')
disp(' ')

% mix channels to make it binary readable
load filename
allPre = [chan1 chan2 chan3 chan4 chan5 chan6 chan7 chan8]'; % creat channels matrix
disp('Mixing channels')
all = allPre(:);
clear allPre

% save vector with all channels mixed
cd ..
try
    cd bin
catch
    mkdir bin
    cd bin
end
disp('Saving')
fout = [filename(1:end-4) '_8chan_ieee64.bin']
fid = fopen(fout,'w');
fwrite(fid,all,'float64');
fclose(fid);
cd ..
cd extracted
delete('filename.mat')
disp('Finished')

