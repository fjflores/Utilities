function out = ternary(cond, a, b)
% TERNARY  Return a if cond is true, otherwise b.
% Usage:
%   y = ternary(condition, valIfTrue, valIfFalse)
%   y = ternary(condition, @() exprIfTrue, @() exprIfFalse)  % lazy eval
%
% - cond can be scalar logical or logical array.
% - a and b may be scalars, arrays (matching cond size), or function handles (no-arg).
%
    if nargin < 3
        error('ternary requires three arguments: cond, a, b');
    end

    % Evaluate function handles lazily (no-arg); keep as values otherwise
    if isa(a, 'function_handle')
        aVal = a();
    else
        aVal = a;
    end
    if isa(b, 'function_handle')
        bVal = b();
    else
        bVal = b;
    end

    if isscalar(cond)
        out = aVal;
        if ~cond
            out = bVal;
        end
        return
    end

    % cond is an array: broadcast scalars if needed, then select elements
    if isscalar(aVal)
        aVal = repmat(aVal, size(cond));
    end
    if isscalar(bVal)
        bVal = repmat(bVal, size(cond));
    end

    out = aVal;
    out(~cond) = bVal(~cond);
end