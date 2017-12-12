function info = parsenlxhdr( hdr, ext )

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
        
    elseif ~isempty( regexp( hdr{ 10 }, '-Cheetah', 'match' ) )
        old = false;
        new = true;
        disp('Newest header style')
        
    else
        error('Problem with header version. Check manually')
        
    end
        
    if old == true
        info.Fs = str2double(...
            cell2mat( regexp( hdr{ 13 }, ' .+', 'match' ) ) );
        
        info.ADChan = str2double(...
            cell2mat( regexp( hdr{ 18 }, ' .+', 'match') ) );
        
        idxDate = cell2mat(...
            regexp( hdr{ 3 }, '(..)/(..)/(.{4})', 'tokenExtents' ) );
        
        info.date = [ hdr{ 3 } ( idxDate( 3, 1 ) : idxDate( 3, 2 ) )...
            '-' hdr{ 3 }( idxDate( 1, : ) ) '-' hdr{ 3 }( idxDate( 2, : ) ) ];
        
        info.timeOpen = regexp( hdr{ 3 }, '( ..):(.+):(.+)', 'match' );
        
        info.convFactor = str2double(...
            cell2mat( regexp( hdr{ 15 }, ' .+', 'match' ) ) );
        
        info.timeClose = regexp(...
            hdr{ 4 }, '( ..):(.+):(.+)', 'match' );
        
        info.filterLow = str2double(...
            cell2mat( regexp( hdr{ 21 }, ' .+', 'match' ) ) );
        
        info.filterHigh = str2double(...
            cell2mat( regexp( hdr{ 25 }, ' .+', 'match' ) ) );
        
        info.inpRange = str2double(...
            cell2mat( regexp( hdr{ 19 }, ' .+', 'match' ) ) );
        
        info.inpInverted = lower(...
            cell2mat( regexp( hdr{ 20 }, 'True|False', 'match' ) ) ); 
        
    elseif new == true
        info.Fs = str2double(...
            cell2mat( regexp( hdr{ 14 },' .+','match' ) ) );
        
        info.ADChan = str2double(...
            cell2mat( regexp( hdr{ 20 }, ' .+','match' ) ) );
        
%         idxDate = cell2mat(regexp(hdr{3},'(..)/(..)/(.{4})','tokenExtents'));
%         date = [hdr{3}(idxDate(3,1):idxDate(3,2)) '-' hdr{3}(idxDate(1,:)) '-' hdr{3}(idxDate(2,:))];

        info.timeOpen = regexp( hdr{ 3 }, '( ..):(.+):(.+)', 'match' );
        
        info.timeClose = regexp( hdr{ 4 }, '( ..):(.+):(.+)', 'match' );
        
        info.convFactor = str2double(...
            cell2mat( regexp( hdr{ 16 }, ' .+', 'match' ) ) );
        
        info.inpInverted = lower(...
            cell2mat( regexp( hdr{ 22 }, 'True|False', 'match' ) )) ;
        
        info.filterLow = str2double(...
            cell2mat( regexp( hdr{ 25 }, ' .+', 'match' ) ) );
        
        info.filterHigh = str2double(...
            cell2mat( regexp( hdr{ 29 }, ' .+', 'match' ) ) );
        
        info.inpRange = str2double(... 
            cell2mat( regexp( hdr{ 21 }, ' .+', 'match' ) ) );
        
        info.inpInverted = lower(...
            cell2mat( regexp( hdr{ 20 }, 'True|False', 'match' ) ) );
        
        info.dspDelEnable = lower(...
            cell2mat( regexp( hdr{ 32 }, 'Disabled|Enabled', 'match' ) ) );
        
        switch dspDelEnable
            case 'disabled'
                info.dspDelay = str2double(...
                    cell2mat( regexp( hdr{ 33 }, ' .+', 'match' ) ) );
                
            case 'enabled'
                info.dspDelay = 0;
                
        end
        
    else
        error('Problem with header version. Check manually')
        
    end
    
else
    error('hdr must be a MATLAB cell data class')
end

    