function lia = isodd( x )
% ISODD true for odd numbers.

% check user input. All input must be natural numbers, that is , integers,
% but not necessarily of integer type.
test = rem( x, 1 );
if sum( test ) > 0
    error( { 'Input must be natural numbers',...
        '(but not necessarily integer type)' } )
    
end

lia = bitget( abs( x ), 1 );
lia = logical( lia );