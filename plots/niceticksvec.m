function ticksVec = niceticksvec( lims, maxTicks )

% choose up to this many ticks
ymin = lims( 1 );
ymax = lims( 2 );

if ymax <= ymin
    % degenerate range
    ticksVec = unique([ymin ymax]);

else
    % ideal (raw) step to produce maxTicks
    rawStep = (ymax - ymin) / (maxTicks - 1);

    % handle very small ranges
    if rawStep <= 0
        ticksVec = unique([ymin ymax]);

    else
        % choose a "nice" step: 1,2,5,10 times a power of ten
        mag = 10 ^ floor(log10(rawStep));
        cand = mag * [1 2 5 10];
        
        % Try each candidate and pick the one closest to maxTicks
        bestStep = cand(1);
        bestNumTicks = 0;
        bestDiff = inf;
        
        for i = 1:length(cand)
            step = cand(i);
            firstTick = ceil(ymin / step) * step;
            lastTick = floor(ymax / step) * step;
            numTicks = length(firstTick:step:lastTick);
            
            % Prefer candidates that don't exceed maxTicks, but get close
            diff = abs(numTicks - maxTicks);
            if numTicks <= maxTicks && (diff < bestDiff || bestNumTicks > maxTicks)
                bestStep = step;
                bestNumTicks = numTicks;
                bestDiff = diff;
            elseif bestNumTicks > maxTicks && numTicks < bestNumTicks
                % If all exceed maxTicks, pick the smallest excess
                bestStep = step;
                bestNumTicks = numTicks;
                bestDiff = diff;
            end
        end

        % build ticks on the chosen step
        step = bestStep;
        firstTick = ceil(ymin / step) * step;
        lastTick = floor(ymax / step) * step;
        ticksVec = firstTick:step:lastTick;

        % ensure we always have at least the endpoints (and <= maxTicks)
        if isempty(ticksVec)
            ticksVec = linspace(ymin, ymax, min(maxTicks, 2));
        end

    end

end