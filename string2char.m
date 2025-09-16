function c = string2char(s)
% STRING2CHAR Convert a MATLAB string scalar to a character array (char).
%   c = string2char(s)
%   - If s is a string scalar -> returns char(s)
%   - If s is already char -> returns s
%   - Otherwise throws an error
%
% Examples:
%   string2char("dex")   -> 'dex'
%   string2char('dex')   -> 'dex'

if isstring(s)

    if isscalar(s)
        c = char(s);

    else
        error('Input must be a string scalar.');

    end

elseif ischar(s)
    c = s;

else
    error('Input must be a string or char array.');

end