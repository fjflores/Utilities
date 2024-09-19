function hdrInfo = parsehdr2( hdr )
% PARSEHDR2 gets the relevant info from Cheetah 5.7 hdr.
% 
% Usage:
% hdrInfo = parsehdr3( hdr )
% 
% Input:
% hdr: cell array from readlfpnlynx or the Neuralynx functions.
% 
% Output:
% hdrInfo: structure with all relevant header info.

day = regexp( hdr{ 3 }, '(\d+)\/(\d+)\/(\d+)', 'match' );
timeOpen = regexp( hdr{ 3 }, '(\d+):(\d+):(\d+)', 'match' );
timeClose = regexp( hdr{ 4 }, '(\d+):(\d+):(\d+)', 'match' );
Fs = regexp( hdr{ 14 },'(\d+)','match' );
convFactor = regexp( hdr{ 16 }, '(\d*\.\d+)', 'match' );
ADName = regexp( hdr{ 18 }, '([a-zA-Z]*\d*)$','match' );
ADChan = regexp( hdr{ 20 }, '(\d+)','match' );
inputRange = regexp( hdr{ 21 }, '(\d+)', 'match' );
inverted = regexp( hdr{ 22 }, 'True|False', 'match' );
lowCut = regexp( hdr{ 25 }, '(\d*\.?\d+)', 'match' );
highCut = regexp( hdr{ 29 }, '(\d*\.?\d+)', 'match' );
delayEnabled = regexp( hdr{ 32 }, 'Disabled|Enabled', 'match' );
delay = regexp( hdr{ 33 }, '(\d+)', 'match' );

hdrInfo.day = day{ 1 };
hdrInfo.timeOpen = timeOpen{ 1 };
% hdrInfo.timeClose = timeClose{ 1 };
hdrInfo.Fs = str2double( Fs{ 1 } );
hdrInfo.convFactor = str2double( convFactor{ 1 } );
hdrInfo.ADName = ADName{ 1 };
hdrInfo.ADChan = str2double( ADChan{ 1 } );
hdrInfo.inverted = strcmpi( inverted{ 1 }, 'true' );
hdrInfo.lowCut = str2double( lowCut{ 1 } );
hdrInfo.highCut = str2double( highCut{ 1 } );
hdrInfo.inputRange = str2double( inputRange{ 1 } );
hdrInfo.delayEnabled = strcmpi( delayEnabled{ 1 }, 'Enabled' );
hdrInfo.delay = str2double( delay{ 1 } );
