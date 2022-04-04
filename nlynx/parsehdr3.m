function hdrInfo = parsehdr3( hdr )
%% PARSEHDR3 gets the relevant info from Cheetah 5.7 hdr.
% 
% Usage:
% hdrInfo = parsehdr3( hdr )
% 
% Input:
% hdr: cell array from readlfpnlynx or the Neuralynx functions.
% 
% Output:
% hdrInfo: structure with all relevant header info.


timeOpen = regexp( hdr{ 8 }, '(\d+):(\d+):(\d+)', 'match' );
day = regexp( hdr{ 8 }, '(\d+)\/(\d+)\/(\d+)', 'match' );
timeClose = regexp( hdr{ 9 }, '(\d+):(\d+):(\d+)', 'match' );
Fs = regexp( hdr{ 15 },'(\d+)','match' );
convFactor = regexp( hdr{ 17 }, ' .+', 'match' );
ADChan = regexp( hdr{ 20 }, ' .+','match' );
lowCut = regexp( hdr{ 25 }, ' .+', 'match' );
highCut = regexp( hdr{ 29 }, ' .+', 'match' );
inputRange = regexp( hdr{ 21 }, ' .+', 'match' );
inverted = regexp( hdr{ 22 }, 'True|False', 'match' );
delayEnabled = regexp( hdr{ 32 }, 'Disabled|Enabled', 'match' );
delay = regexp( hdr{ 33 }, ' .+', 'match' );

hdrInfo.day = day{ 1 };
hdrInfo.timeOpen = timeOpen{ 1 };
hdrInfo.timeClose = timeClose{ 1 };
hdrInfo.Fs = str2double( Fs{ 1 } );
hdrInfo.convFactor = str2double( convFactor{ 1 } );
hdrInfo.ADChan = str2double( ADChan{ 1 } );
hdrInfo.inverted = strcmpi( inverted{ 1 }, 'true' );
hdrInfo.lowCut = str2double( lowCut{ 1 } );
hdrInfo.highCut = str2double( highCut{ 1 } );
hdrInfo.inputRange = str2double( inputRange{ 1 } );
hdrInfo.delayEnabled = strcmpi( delayEnabled{ 1 }, 'Enabled' );
hdrInfo.delay = str2double( delay{ 1 } );