function powerdB = pow2dbnan( powerLinear )
% POW2DBNAN Convert linear power to dB with NaN handling.
%
% Usage:
%   powerdB = pow2db_nan(powerLinear) converts linear power values to dB
%   using 10*log10(x), while gracefully handling NaN values and zeros.
%
% Input:
%   powerLinear - matrix of linear power values (may contain NaNs)
%
% Output:
%   powerdB - power in dB (10*log10). NaNs remain NaN, zeros become -Inf
%
% Examples:
%   pow2dbnan([1 10 100; NaN 0.1 1000])
%   pow2dbnan([0 1; 10 NaN])

% Handle input validation
if ~isnumeric( powerLinear )
    error('pow2dbnan:InvalidInput', 'Input must be numeric');

end

% Pre-allocate output with same size as input
powerdB = nan( size( powerLinear ) );

% Find valid (non-NaN, positive) elements
validIdx = ~isnan( powerLinear) & powerLinear > 0;

% Compute dB only for valid elements
if any( validIdx( : ) )
    powerdB( validIdx ) = 10 * log10( powerLinear( validIdx ) );
end

% Handle special cases
zeroIdx = ~isnan( powerLinear ) & powerLinear == 0;
if any( zeroIdx( : ) )
    powerdB( zeroIdx ) = -Inf;
end

% Negative values remain NaN (invalid for power)
negIdx = ~isnan( powerLinear ) & powerLinear < 0;
if any( negIdx( : ) )
    warning('pow2dbnan:NegativeValues', ...
        'Found %d negative power values, setting to NaN', sum( negIdx( : ) ));
    powerdB( negIdx ) = NaN;

end