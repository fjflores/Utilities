function colIdx = findcolindex( T, colNames )
% This function returns the indices of specified column names in a table.
% 
% Usage:
% T: table to check.
% colNames: cell array of 
% 
% Inputs:
% T: The input table.
% colNames: A cell array of column names to find.
% 
% Outputs:
% colIdx: An array of indices corresponding to the column names.

% Initialize an array to hold the indices
colIdx = zeros( 1, length( colNames ) );

% Find the indices of the specified column names
varNames = T.Properties.VariableNames;
for i = 1 : length( colNames )
    colIdx( i ) = find( strcmp( varNames, colNames{ i } ) );

end