function sleepStage = importhypno(spikeFile,firstTS,sav)

%IMPORTHYPNO imports a spike sleep stage text into mat format
% SLEEPSTAGE = IMPORTHYPNO(SPIKEFILE,FIRSTTS,SAV)
% INPUT:    spikeFile:  name of the txt file to read from spike
%           firstTS:    first ts from a Nlx CSC file (in secs).
%           sav:        boolean flag. If 1, saves. Default: 0
% OUTPUT:   sleepStage: structure with fields: file: name of the original
%                       spike file. hypno: hypnogram (0 = DOUBT; 1 = WAKE
%                       2 = NREM; 3 = REM); states: logical matrix of states,
%                       and t: times.
%
% See Also PLOTHYPNO
%
% Copyright Francisco J. Flores, 18-May-2010

% 2010-05-27 FJF modified to produce an structure output instead of single
% outputs
% 2010-09-25 FJF modified to correct for offset using hypnogram information.
% Hopefully it will remain consistent!!
% 2010-09-28 FJF modified to save the original spike file name in the output
% structure
% 2010-12-07 FJF Added a subroutine to work on xls or txt input files

% test input parameters
if nargin < 2
    sav = true;
end

% first, test if the data is txt or xls
ext = spikeFile(end-2:end);
switch ext
    case 'xls' % import data from excel file
        newData1 = importdata(spikeFile);
        s = fieldnames(newData1.data);
        eval(['data1 = newData1.data.' s{1} '(15:end,:);']);
        
    case 'txt' % import data from text file
        disp(['Importing data from ' spikeFile])
        newData1 = importdata(spikeFile);
        try
            data1 = newData1.data;
        catch
            data1 = newData1;
        end
end
t = data1(:,2); % get times for each epoch

%{
correct offset here. To do that, substract the first timestamp from the
sleep scoring file from the first timestamp from neuralynx
%}
offset = firstTS - t(1);
t = t + offset;

% once the data is loaded, load the states from columns 4, 5 and 6
logicalStates = logical(data1(:,4:6));
[m,n] = size(logicalStates);

% create a matrix that will assign numbers to each states
states = [ones(m,1) 2*ones(m,1) 3*ones(m,1)];

% multiply logical indices by states
states = logicalStates.*states;
hypno = sum(states,2); % get hypno through state sum
hypno(hypno==0)=NaN;

% create structure
sleepStage = struct('file',spikeFile,'hypno',hypno,'states',logicalStates,'t',t);

% save, if required
if sav == true
    file2Save = [spikeFile(1:end-4) '_hypnogram'];
    testExist = dir(file2Save);
    if isempty(testExist)
        disp([' Saving ' file2Save])
        save(file2Save,'sleepStage')
    else
        choice = questdlg('File already exist. Would you like to replace it?', ...
            'Yes', ...
            'No',...
            'Change name');
        switch choice
            case 1
                % replace file
                save(file2Save,'sleepStage')
            case 2
                % do not save
                disp('  Not Saving')
            case 3
                % open a dialog to change name
                appen = inputdlg(...
                    'Enter string to append','s');
                file2Save = [spikeFile(1:end-4) '_hypnogram_' appen];
                disp([' Saving ' file2Save])
                save(file2Save,'sleepStage')
        end
    end
else
    disp(' Not Saving')
end