function out = ternary(cond, a, b)
% TERNARY  Return a if cond is true, otherwise b.
% 
% Usage:
%   y = ternary(condition, valIfTrue, valIfFalse)
%   y = ternary(condition, @() exprIfTrue, @() exprIfFalse)  % lazy eval
%
% Inputs:
% cond: condition to be evaluated.
% a and b: may be scalars, arrays (matching cond size), or function handles 
% (no-arg).
%
% Outputs:
% out: selected values based on cond.
%
% Examples:
%   y = ternary(rand < 0.8, true, false);
% 
% Suppose ground_truth is a function that accepts x as input:
%   y = ternary(rand < 0.8, @() ground_truth(x), @() ~ground_truth(x));
% 
% Returns vector selecting from a or b per element of cond:
%   cond = rand(3,1) < 0.5;
%   a = [1;2;3];
%   b = 0;
%   out = ternary(cond, a, b);  

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