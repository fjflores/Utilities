function [S,t,f,win,params,info] = specgramLfp(fileName,fpass,win,epoch,sub,sav)

% Spectrogram of DevilLynx LFP signals at 2 secs win 1 sec step
% INPUT:    fileName:   recording session folder name (as cheetah saves it)
%           fpass:      vector frequency range to compute the specgram
%           epoch:      epoch to analyze. empty if all
%           sub:        boolean flag. 1 for subsampling. 0 for no
%                       subsampling.
%           sav:        boolean flag. 1 saves, 0 don't save.
% OUTPUT    spec: structure with specgram information

% (c) Francisco J. Flores, 2010-04-14

% REVISION HISTORY
% 2010-04-30 Chop the spectrograms into 20 min segments
% 2010-05-12 Work on the whole LFP, but folder independent. can wotk on a
% single file or on a structure with file names (like the output of DIR)
% 2010-05-13 get rid of the 'logs' input
% 2010-06-29 get rid of results folder and date at the end of the name
% 2010-07-01 add input check and epoch extraction. eliminate plotting.
% may be add input params and win later. the problem is the sampling
% frequency
% 2010-07-05 Added display of win size, num tapers and spectral resolution,
% at least
% 2010-09-19 Added subsampling by 20 routine.
% 2011-02-10 Added win input argument and flag for subsampling. Saved as
% Interleave. Modified output to be in variable and not structure form.

% check input arguments
if nargin < 2
    fpass = inputdlg('Enter lower and upper frequency bounds, separated by white space');
    fpass = fpass{1};
    win = [2 1];
    epoch = [];
    sub = false;
    sav = false;
elseif nargin < 3
    epoch = [];
    sub = false;
    sav = false;
elseif nargin < 4
    sub = false;
    sav = false;
end

% how many LFP's there are?
if isstruct(fileName)
    nFiles = length(fileName);
    disp('Structure input')
    disp(['Found ' num2str(nFiles) ' LFPs in this folder'])
else
    nFiles = 1;
end


if sub == true
    interl = input('Enter subsampling interleave');
else
    interl = 1;
end

% process each LFP channel
t1 = tic; % initialize ral time counter
for iFiles = 1:nFiles
    if isstruct(fileName)
        file2Load = fileName(iFiles).name;
    else
        % check that the file extension is present
        if isempty(strfind(fileName,'ncs'))
            fileName = [fileName '.ncs'];
        end
        file2Load = fileName;
    end
    
    disp([' Processing file ' file2Load])
    % The following will extract:
    % - header
    % - data for assesing the total number of records
    if isempty(epoch)
        disp(' No epoch provided. Processing all data')
        [data,hdr] = Nlx2MatCSC(file2Load,[0 0 0 0 1],1,1,[]);
        Fs = str2num(hdr{13}(20:end))./interl;
        eegMult = str2num(hdr{15}(13:end));
        data = data(1:interl:end)*eegMult*1000;
        data = data-mean(data); % removing DC component
    else
        disp([' Processing from ' ffsecs2hms(epoch(1)) ' to ' ffsecs2hms(epoch(2))])
        epoch = epoch*1000000;
        [data,hdr] = Nlx2MatCSC_v4(file2Load,[0 0 0 0 1],1,4,epoch);
        Fs = str2num(hdr{13}(20:end))./interl;
        eegMult = str2num(hdr{15}(13:end));
        data = data(1:interl:end)*eegMult*1000;
        data = detrend(data); % removing DC component
    end
    
    % compute spectrogram
    params = struct(...
        'tapers',[3 5],...
        'pad',-1,...
        'Fs',Fs,...
        'fpass',fpass);
    w = (params.tapers(2)+1)/(2*win(1)); % compute MTM resolution
    disp(['  Computing spectrogram for file ' file2Load(1:end-4) '...'])
    disp('  Using the folowing parameters: ')
    fprintf('   Window:\t\t%-d\n   # Tapers:\t%-d\n   Resolution: \t%-1.1d\n',...
        win(1),params.tapers(2),w);
    [S,t,f] = mtspecgramc(data,win,params);
    clear data
    
    % get first timestamp to add to the time computed
    if isempty(epoch)
        ts = Nlx2MatCSC(file2Load,[1 0 0 0 0],0,1,[]);
        firstTs = ts(1)/1000000;
        clear ts
    else
        ts = Nlx2MatCSC_v4(file2Load,[1 0 0 0 0],0,4,epoch);
        firstTs = ts(1)/1000000;
        clear ts
    end
    
    t = t+firstTs; % add first timestap value to the time from specgramc
    
    % create a structure with all relevant information
    info = struct(....
        'fileName',file2Load,...
        'res',w,... % spectral resolution
        'epoch',epoch,...
        'interleave',interl);

    % save, if required
    if sav == true
        disp('  Saving...')
        file2Save = [file2Load(1:end-4) '_Spec'];
        testExist = dir(file2Save);
        if isempty(testExist)
            save(file2Save,'S','t','f','params','win','info')
        else
            choice = questdlg('File already exist. Would you like to replace it?', ...
                'Yes', ...
                'No',...
                'Change name');
            switch choice
                case 1
                    % replace file
                    save(file2Save,'spec')
                case 2
                    % do not save
                    disp('  Not Saving')
                case 3
                    % open a dialog to change name
                    appen = inputdlg(...
                        'Enter string to append','s');
                    file2Save = [file2Load(1:end-4) '_Spec_' appen];
                    save(file2Save,'spec')
                    %                     print(file2Save,'-depsc2')
            end
        end
    else
        disp('  Not Saving')
    end
    
    % clear and go back to the data folder
    clear S t f
    disp([' '])
end
t2 = toc(t1)
disp(['Processing ' num2str(nFiles) ' LFPs took ' ffsecs2hms(t2)])

