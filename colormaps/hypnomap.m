function cm_data = hypnomap(m)
% HYPNOMAP Categorical colormap with 4 colors.
%   HYPNOMAP returns all 4 colors.
%   HYPNOMAP(M) returns the first M colors.

cm = [
    [0.21568627, 0.49411765, 0.72156863],
    [0.89411765, 0.10196078, 0.10980392],
    [0.30196078, 0.68627451, 0.29019608],
    [0.75294118, 0.75294118, 0.75294118]];

if nargin < 1
    cm_data = cm;
else
    assert(m <= size(cm, 1), 'Only %d colors available.', size(cm, 1))
    cm_data = cm(1:m, :);
end
end
