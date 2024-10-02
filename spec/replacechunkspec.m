function Sclean = replacechunkspec( S, t, tArt )


% Define the row indices to replace
tIdx = t >= tArt( 1 ) & t <= tArt( 2 );

% Define the new value or new rows (e.g., replacing with the value 7)
newValue = min( S, [], "all" );

% Replace the rows with the new value
Sclean = S;
Sclean( tIdx, : ) = newValue;

% Display the updated matrix
% disp(A);
