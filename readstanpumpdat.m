function [ pkVars, t, varNames ] = readstanpumpdat( fileName, corrFlag )
%READSTANPUMP extracts variables from a .dat stanpump file.
%
% Usage:
% [ vars, t, varNames ] = readstanpumpdat( fileName )
%
% Input:
%   fileName: full name of the .dat file to read.
%
% Output:
%   vars: cell array with values of the variables saved in .DAT file, with
%         the value of each element in the array as: 1 -> Volume; 
%         2 -> Rate; 3 -> Plasma conc., and 4 -> Effect site conc 
%         (if exists).
%   t: timestamps for each of the variables.

% check user input:
% number of arguments and fallback cases.
if nargin < 1 
    error( 'Need at least one argument.' )
    
elseif nargin < 2
    disp( 'No correction of time reocrds required.' )
    corrFlag = false;
    
else
    % nothing
    
end

% check filename spelling
[ ~, ~, ext ] = fileparts( fileName );
if ~strcmpi(  ext , '.dat' )
    error( 'File does not has the .dat extension' )
    
end

% read file
[ varName1, varName2, varName3 ] = importfile( fileName );

% There are either 3 or 4 codes, depending on whether there is an effect 
% model. (1: Volume; 2: Rate; 3: Plasma conc.; 4: Effect site conc.).
codes = unique( varName1 );
if codes( end ) == 3
    varNames = { 'Volume', 'Rate', 'Plasma conc.' };
    
elseif codes( end ) == 4
    varNames = { 'Volume', 'Rate', 'Plasma conc.', 'Effect site conc.' };
    
else
    error( 'Only two variables saved in .DAT. Weird...' )
    
end


% get indices for each codes. Save in a cell array because there could be
% unequal number of records for each code.
for codeIdx = 1 : codes( end ); 
    varIdx{ codeIdx } = varName1 == codes( codeIdx );
    
    % Get variable specific time.
    t{ codeIdx } = varName2( varIdx{ codeIdx } );
    
    % Get each variable value.
    pkVars{ codeIdx } = varName3( varIdx{ codeIdx } );

end

% check for stanpump writing errors in the time record
for i = 1 : length( t )
    errorFlag = ~all( diff( t{ i } ) );
    if errorFlag
        warning( 'Time record has duplicate values.' )
        
        if corrFlag == true
            disp( 'Correcting...' )
            tCorr{ i } = correctt( t{ i } );
            
        else
            disp( 'Not Correcting...' )
            tCorr{ i } = t{ i };
            
        end
        
    else
        disp( 'No duplicate values were found.' )
        tCorr{ i } = t{ i };
        
    end

end
t = tCorr;


% Helper function to open the file.
function [ VarName1, VarName2, VarName3 ] = importfile( filename )

%IMPORTFILE Import numeric data from a text file as column vectors.
%   [VARNAME1,VARNAME2,VARNAME3] = IMPORTFILE(FILENAME) Reads data from
%   text file FILENAME for the default selection.
%
%   [VARNAME1,VARNAME2,VARNAME3] = IMPORTFILE(FILENAME, STARTROW, ENDROW)
%   Reads data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [VarName1,VarName2,VarName3] = importfile('20130206.DAT',1, 1630);
%
%    See also TEXTSCAN.

% Initialize variables.
delimiter = ',';
if nargin <= 2
    startRow = 1;
    endRow = inf;
end

% Format string for each line of text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%[^\n\r]';

% Open the text file.
fileID = fopen( filename, 'r' );

% Read columns of data according to format string.
dataArray = textscan( fileID, formatSpec, endRow( 1 ) - startRow( 1 ) + 1, 'Delimiter', delimiter, 'HeaderLines', startRow( 1 ) - 1, 'ReturnOnError', false );
for block = 2 : length( startRow )
    frewind( fileID );
    dataArrayBlock = textscan( fileID, formatSpec, endRow( block ) - startRow( block ) + 1, 'Delimiter', delimiter, 'HeaderLines', startRow( block ) - 1, 'ReturnOnError', false);
    
    for col = 1 : length( dataArray )
        dataArray{ col } = [ dataArray{ col }; dataArrayBlock{ col } ];
        
    end
    
end

% Close the text file.
fclose( fileID );

% Allocate imported array to column variable names
VarName1 = dataArray{ :, 1 };
VarName2 = dataArray{ :, 2 };
VarName3 = dataArray{ :, 3 };

% Helper fx to correct discontinuities in stanpump times.
function tCorr = correctt( t )

%CORRECTT adds one second to duplicate stanpump timestamps.
tCorr = t; % copy original time vector
for tIdx = 2 : length( t )
    test = t( tIdx ) - t( tIdx - 1 ); % test the difference
    
    % If zero, add 1 second to the tIdx timestamp
    if test == 0
        tCorr( tIdx ) = t( tIdx ) + 1;
        
    else
        % nothing
        
    end
    
end
