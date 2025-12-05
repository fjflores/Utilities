function ticksVec = niceticksvec( lims, rawStep )
% NICETICKSVEC generate a vector of "nice" tick values within given limits
% using a target rawStep (spacing) instead of maxTicks.
%
% Usage:
%   ticksVec = niceticksvec( lims, rawStep )
%
% Inputs:
%   lims: 2-element vector specifying [min, max] limits
%   rawStep: desired tick spacing (positive scalar)
%
% Output:
%   ticksVec: vector of tick values
%
% Notes:
%   The function picks a "nice" step near rawStep from {1,2,5,10} * 10^k
%   (searching one decade below and above the decade of rawStep), then
%   returns ticks that fall within the provided limits.

ymin = lims(1);
ymax = lims(2);

% handle degenerate ranges
if ymax <= ymin
    ticksVec = unique([ymin ymax]);
    return;
end

% validate rawStep
if ~(isnumeric(rawStep) && isscalar(rawStep) && rawStep > 0)
    error('niceticksvec:InvalidRawStep', 'rawStep must be a positive scalar.');
end

% quick guard: if desired step larger than range, return endpoints
rangeVal = ymax - ymin;
if rawStep >= rangeVal
    ticksVec = unique([ymin ymax]);
    return;
end

% build candidate steps across neighboring decades
baseExp = floor(log10(rawStep));
exps = (baseExp-1):(baseExp+1);
cands = [];
for e = exps
    cands = [cands, (10^e) * [1 2 5 10]]; %#ok<AGROW>
end
cands = unique(sort(cands));

% pick candidate closest to rawStep (absolute difference)
[~, idx] = min(abs(cands - rawStep));
bestStep = cands(idx);

% compute first/last ticks that lie within limits (use small tolerance)
tol = bestStep * 1e-12;
firstTick = ceil((ymin - tol) / bestStep) * bestStep;
lastTick  = floor((ymax + tol) / bestStep) * bestStep;

if lastTick < firstTick
    % no interior ticks: return endpoints
    ticksVec = unique([ymin ymax]);
    return;
end

% generate tick vector and round to sensible precision to avoid float noise
ticksVec = firstTick : bestStep : lastTick;

% round ticks to sensible number of decimals based on step magnitude
decimals = max(0, -floor(log10(bestStep)) + 6); % keep some safety digits
ticksVec = round(ticksVec, decimals);

% ensure endpoints are included if they fall on nice step (or add them if needed)
if ticksVec(1) > ymin + tol
    ticksVec = unique([ymin, ticksVec]);
end
if ticksVec(end) < ymax - tol
    ticksVec = unique([ticksVec, ymax]);
end

end