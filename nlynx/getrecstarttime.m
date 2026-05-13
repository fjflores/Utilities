function ts = getrecstarttime( logFilePath )
% Returns the HH:MM:SS.mmm timestamp string from a Cheetah log file.
logContent = fileread( logFilePath );
ts = regexp( logContent,...
    '\d{1,2}:\d{2}:\d{2}\.\d{3}(?= - \d+ - AcquisitionControl::StartRecording)',...
    'match', 'once' );
end
