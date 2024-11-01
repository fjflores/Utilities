function dataRep = replacedatachunk( data, ts, tArt, method, nRep )


% Define the replacement value
switch method
    case 'min'
        newValue = min( data, [], "all" );

    case 'nan'
        newValue = nan;

    case 'zero'
        newValue = 0;

end

% Define the row indices to replace
tIdx = find( ts >= tArt( 1 ) & ts <= tArt( 2 ) );

% Replace the rows with the new value
dataRep = data;
if size( data, 1 ) == 1 || size( data, 2 ) == 1 % check if row or column vector
    dataRep( tIdx ) = newValue;

else
    dataRep( tIdx, : ) = newValue;

end
