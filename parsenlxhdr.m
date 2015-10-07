function [Fs,ADChan,time,filter,inpRange,convFactor,inpInverted] = parsenlxhdr(hdr)

% PARSENLXHDR(HDR) parses old and new neuralynx header files.

% Ussage:
% [Fs,ADChan,date,time,filter,inpRange] = parsenlxhdr(hdr)
% 
% Input:
%   hdr:    cell array containing the header from a CSC neuralynx file.
% 
% Output:
%   Fs:     Sampling frequency, in Hz.
%   ADChan: channel number in cheetah.
% 
% (C) 2012 Francisco J. Flores

if strcmp( class( hdr ), 'cell' )
    
    if ~isempty( regexp( hdr{ 5 }, '-Cheetah', 'match' ) )
        old = true;
        new = false;
        disp('Old header style')
        
    elseif ~isempty(regexp(hdr{10},'-Cheetah','match'))
        old = false;
        new = true;
        disp('Newest header style')
        
    else
        error('Problem with header version. Check manually')
        
    end
        
    if old == true
        Fs = str2double(cell2mat(regexp(hdr{13},' .+','match')));
        ADChan = str2double(cell2mat(regexp(hdr{18},' .+','match')));
        idxDate = cell2mat(regexp(hdr{3},'(..)/(..)/(.{4})','tokenExtents'));
        date = [hdr{3}(idxDate(3,1):idxDate(3,2)) '-' hdr{3}(idxDate(1,:)) '-' hdr{3}(idxDate(2,:))];
        time.open = regexp(hdr{3},'( ..):(.+):(.+)','match');
        convFactor = str2double(cell2mat(regexp(hdr{15},' .+','match')));
        time.close = regexp(hdr{4},'( ..):(.+):(.+)','match');
        filter.low = str2double(cell2mat(regexp(hdr{21},' .+','match')));
        filter.high = str2double(cell2mat(regexp(hdr{25},' .+','match')));
        inpRange = str2double(cell2mat(regexp(hdr{19},' .+','match')));
        inpInverted = lower(cell2mat(regexp(hdr{20},'True|False','match')));
    
    elseif new == true
        Fs = str2double(cell2mat(regexp(hdr{14},' .+','match')));
        ADChan = str2double(cell2mat(regexp(hdr{20},' .+','match')));
%         idxDate = cell2mat(regexp(hdr{3},'(..)/(..)/(.{4})','tokenExtents'));
%         date = [hdr{3}(idxDate(3,1):idxDate(3,2)) '-' hdr{3}(idxDate(1,:)) '-' hdr{3}(idxDate(2,:))];
        time.open = regexp(hdr{3},'( ..):(.+):(.+)','match');
        time.close = regexp(hdr{4},'( ..):(.+):(.+)','match');
        convFactor = str2double(cell2mat(regexp(hdr{16},' .+','match')));
        inpInverted = lower(cell2mat(regexp(hdr{22},'True|False','match')));
        filter.low = str2double(cell2mat(regexp(hdr{25},' .+','match')));
        filter.high = str2double(cell2mat(regexp(hdr{29},' .+','match')));
        inpRange = str2double(cell2mat(regexp(hdr{21},' .+','match')));
        
    else
        error('Problem with header version. Check manually')
        
    end
    
else
    error('hdr must be a MATLAB cell data class')
end
    