function ts = readsmits( fn )
%READSMITS parses the timestamps from smi files.

fid = fopen( fn ,'r'); %# open csv file for reading

% skip header
headLength = 18;
for i = 1 : headLength
    fgets( fid );
    
end

% start reading timestamps
count = 1;
while ~feof( fid )
    line = fgets( fid ); %# read line by line
    startIdx = regexp( line, 'CC>' );
    
    if ~isempty( startIdx )
        endIdx = regexp( line, '</S' );
        ts( count, 1 ) = sscanf( line( startIdx : endIdx - 1 ), 'CC>%f' );
        count = count + 1;
        
    end
    
end
fclose( fid );
