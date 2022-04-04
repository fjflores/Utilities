function hdrInfo = parsehdrnlynx( hdr, ext )
% PARSENLXHDR(HDR) parses old and new neuralynx header files.
%
% Ussage:
% [Fs,ADChan,date,time,filter,inpRange] = parsenlxhdr(hdr)
%
% Input:
% hdr: cell array containing the header from a CSC neuralynx file.
% ext: File extension of header.
%
% Output:
% hdrInfo: Structure with the most important header information.

% Check if cell
if ~iscell( hdr )
    error('hdr must be a MATLAB cell data class')
    
end

% Check header style
if ~isempty( regexp( hdr{ 5 }, '-Cheetah', 'match' ) )
    style = 1;
    disp('Old header style')
    
elseif ~isempty( regexp( hdr{ 10 }, '-Cheetah', 'match' ) )
    style = 2;
    disp('Cheetah 5.6 header style')
    
elseif ~isempty( regexp( hdr{ 12 }, 'Cheetah', 'match' ) )
    style = 3;
    disp('Cheetah 5.7 header style')
    
else
    error('Problem with header version. Check manually')
    
end

if style == 1
    hdrInfo.Fs = str2double(...
        cell2mat( regexp( hdr{ 13 }, ' .+', 'match' ) ) );
    
    hdrInfo.ADChan = str2double(...
        cell2mat( regexp( hdr{ 18 }, ' .+', 'match') ) );
    
    hdrInfo.day = cell2mat(...
        regexp(...
        hdr{ 3 }, '(?<month>\d+)/(?<day>\d+)/(?<year>\d+)', 'match' ) );
    
    hdrInfo.timeOpen = regexp( hdr{ 3 }, '( ..):(.+):(.+)', 'match' );
    
    hdrInfo.convFactor = str2double(...
        cell2mat( regexp( hdr{ 15 }, ' .+', 'match' ) ) );
    
    hdrInfo.timeClose = regexp(...
        hdr{ 4 }, '( ..):(.+):(.+)', 'match' );
    
    hdrInfo.filterLow = str2double(...
        cell2mat( regexp( hdr{ 21 }, ' .+', 'match' ) ) );
    
    hdrInfo.filterHigh = str2double(...
        cell2mat( regexp( hdr{ 25 }, ' .+', 'match' ) ) );
    
    hdrInfo.inpRange = str2double(...
        cell2mat( regexp( hdr{ 19 }, ' .+', 'match' ) ) );
    
    hdrInfo.inpInverted = lower(...
        cell2mat( regexp( hdr{ 20 }, 'True|False', 'match' ) ) );
    
elseif style == 2
    hdrInfo.day = cell2mat(...
        regexp(...
        hdr{ 3 }, '(?<month>\d+)/(?<day>\d+)/(?<year>\d+)', 'match' ) );
    
    hdrInfo.timeOpen = regexp( hdr{ 3 }, '( ..):(.+):(.+)', 'match' );
    
    hdrInfo.timeClose = regexp( hdr{ 4 }, '( ..):(.+):(.+)', 'match' );
    
    hdrInfo.Fs = str2double(...
        cell2mat( regexp( hdr{ 14 },' .+','match' ) ) );
    
    hdrInfo.convFactor = str2double(...
        cell2mat( regexp( hdr{ 16 }, ' .+', 'match' ) ) );
    
    hdrInfo.ADChan = str2double(...
        cell2mat( regexp( hdr{ 20 }, ' .+','match' ) ) );
    
    hdrInfo.inpInverted = lower(...
        cell2mat( regexp( hdr{ 22 }, 'True|False', 'match' ) )) ;
    
    hdrInfo.filterLow = str2double(...
        cell2mat( regexp( hdr{ 25 }, ' .+', 'match' ) ) );
    
    hdrInfo.filterHigh = str2double(...
        cell2mat( regexp( hdr{ 29 }, ' .+', 'match' ) ) );
    
    hdrInfo.inpRange = str2double(...
        cell2mat( regexp( hdr{ 21 }, ' .+', 'match' ) ) );
    
    hdrInfo.inpInverted = lower(...
        cell2mat( regexp( hdr{ 20 }, 'True|False', 'match' ) ) );
    
    hdrInfo.dspDelEnable = lower(...
        cell2mat( regexp( hdr{ 32 }, 'Disabled|Enabled', 'match' ) ) );
    
    switch hdrInfo.dspDelEnable
        case 'disabled'
            hdrInfo.dspDelay = str2double(...
                cell2mat( regexp( hdr{ 33 }, ' .+', 'match' ) ) );
            
        case 'enabled'
            hdrInfo.dspDelay = 0;
            
    end
    
elseif style == 3
    hdrInfo = parsehdr3( hdr );
    
else
    error('Problem with header version. Check manually')
    
end



