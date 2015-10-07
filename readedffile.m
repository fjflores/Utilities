clear all
% This script reads the first 50 records of an EDF file into MATLAB structure named
% RECSTRUCT
%
%   Each element of RECSTRUCT corresponds to one of the signals in
%   the file.  The fields of RECSTRUCT are:
%           label (e.g. EEG Fpz-Cz or Body temp)
%           transducer_type (e.g. AgAgCl electrode)
%           physical_dimension (e.g. uV or degreeC)
%           physical_minimum (e.g. -500 or 34)
%           physical_maximum (e.g. 500 or 40)
%           digital_minimum (e.g. -2048)
%           digital_maximum (e.g. 2047)
%           prefiltering (e.g. HP:0.1Hz LP:75Hz)
%           Number_of_Samples 
%           Reserved
%
%   Example: recstruct = readEDF('02.04.33_1.10.08.edf',500);
%
%   EDF format spec taken from: http://www.edfplus.info/specs/edf.html
%
%

%% OPEN FILE FOR READING
RecsToRead = 10;
RecsAtATime = 5;
fid = fopen('test_data_mrMouse.edf');

%% READ FILE HEADER

%This vector gives the number of bytes allocated to each field
fileheaderfmt = [8 ; ... %version of this data format (0)
    80 ; ... %local patient identification (mind item 3 of the additional EDF+ specs)
    80 ; ... %local recording identification (mind item 4 of the additional EDF+ specs)
    8 ; ... %startdate of recording (dd.mm.yy) (mind item 2 of the additional EDF+ specs)
    8 ; ... %starttime of recording (hh.mm.ss)
    8 ; ... %number of bytes in header record
    44 ; ... %reserved
    8 ; ... %number of data records (-1 if unknown, obey item 10 of the additional EDF+ specs)
    8 ; ... %duration of a data record, in seconds
    4] ; %number of signals (ns) in data record

% Read the file header
fhbuf = fread(fid,sum(fileheaderfmt));

% Create a structure containing the file info
fileinfo.nsig = str2double(char(fhbuf(end-3:end))); %Number of signals in each data record
fileinfo.nrecs = str2double(char(fhbuf(end-19:end-12))); %Number of data records
fileinfo.patientID = char(fhbuf(9:88)');
%Could add more to this structure if information is desired


nsig = fileinfo.nsig; %number of signals per data record
nrecs = fileinfo.nrecs; %number of data records

%% READ DATA HEADER

%The data record header is formed by repeating the value for each field
%NSIG times.  For example, if NSIG = 2, the data record woud have 2 x 16
%bytes for label followed by 2 x 80 bytes for transducer type, etc.

%This vector gives the number of bytes used to represent each field
dataheaderfmt1sig = [ 16 ; ... %nsig * label (e.g. EEG Fpz-Cz or Body temp) (mind item 9 of the additional EDF+ specs)
    80 ; ... %nsig * transducer type (e.g. AgAgCl electrode)
    8 ; ... %nsig * physical dimension (e.g. uV or degreeC)
    8 ; ... %nsig * physical minimum (e.g. -500 or 34)
    8 ; ... %nsig * physical maximum (e.g. 500 or 40)
    8 ; ... %nsig * digital minimum (e.g. -2048)
    8 ; ... %nsig * digital maximum (e.g. 2047)
    80 ; ... %nsig * prefiltering (e.g. HP:0.1Hz LP:75Hz)
    8 ; ... %nsig * nr of samples in each data record
    32] ; ... %nsig * reserved
    
dataheaderfmt = nsig * dataheaderfmt1sig;
dfbuf = fread(fid,sum(dataheaderfmt));

%% Create a record structure RECSTRUCT.  Populate it with description for each signal

% RECSTRUCT field labels
dhfields = {'label','transducer','physical_dimension','physical_minimum',...
    'physical_maximum','digital_minimum','digital_maximum','prefiltering',...
    'Number_of_Samples','Reserved'};

% Fill the fields with the header data
for k = 1:length(dataheaderfmt)
    if k == 1
        recstruct = struct(dhfields{1},cellstr(char(reshape(dfbuf(1:dataheaderfmt(1)),dataheaderfmt1sig(1),nsig)')));
    else
        fieldvalue = cellstr(char(reshape(dfbuf(sum(dataheaderfmt(1:k-1))+1:sum(dataheaderfmt(1:k))),dataheaderfmt1sig(k),nsig)'));
        [recstruct.(dhfields{k})] = deal(fieldvalue{:});
    end
end

% Preallocate space for record data
for k = 1:length(recstruct)
    recstruct(k).data = zeros(RecsToRead,str2num(recstruct(k).Number_of_Samples));
end

%% READ DATA
%Each sample value is represented as a 2-byte integer in 2's complement
%format.

% This is the number of bytes to read for each buffer
% We want to divide data read into chunks to avoid memory errors
sampspersig = cellfun(@str2num,{recstruct.Number_of_Samples});
databufsize = 2*sum(sampspersig);

% Increase this number to speed program execution, but run the risk of
% memory errors.


%Loop through records
for k1 = 1:RecsAtATime:RecsToRead
    % Read data for the k1th:k1+(reacsatatime-1)th record
    if ( k1 + RecsAtATime ) < nrecs
        bytestoread = databufsize.*RecsAtATime;
    else
        bytestoread = databufsize.*(nrecs-k1+1);
    end
    databuf0 = fread(fid,bytestoread);
    
    %Need to swap byte order before concatenation
    databuf = reshape(databuf0,2,numel(databuf0)/2);
    databuf = flipud(databuf);
    databuf = reshape(databuf,numel(databuf),1);
    
    %Now convert to binary to combine bytes 
    databuf = arrayfun(@(x) dec2bin(x,8),databuf,'UniformOutput',0);
    databuf = strvcat(databuf)'; %%%%%%#ok<VCAT>
    databuf = reshape(databuf,16,length(databuf)/2)';
    
    % convert to positive values to decimal
    sign = databuf(:,1);
    data = int16(zeros(size(sign)));
    data(~logical(str2num(sign))) = bin2dec(databuf(~logical(str2num(sign)),:)); %#ok<ST2NM>

    % Convert two's complement to decimal for negative values
    negativedata = arrayfun(@str2num,databuf(logical(str2num(sign)),:));
    negativedata = ~logical(negativedata);
    negativedata = -(bin2dec(num2str(negativedata))+1);
    data(logical(str2num(sign))) = negativedata; %#ok<ST2NM>
    
    data = reshape(data,numel(data)/(databufsize/2),databufsize/2);
    
    for j = 1:length(recstruct)
        if j~=1
            recstruct(j).data(k1:min(k1+RecsAtATime-1,nrecs),:) = data(:,sum(sampspersig(1:j-1))+1:sum(sampspersig(1:j)));
        else
            recstruct(j).data(k1:min(k1+RecsAtATime-1,nrecs),:) = data(:,1:sampspersig(1));
        end
    end
    
end

        
clear databuf databuf0 data;
