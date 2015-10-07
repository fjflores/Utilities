function h = ffplothypno(SleepStage,epoch,plotType)

%PLOTHYPNO plots a hypnogram from the SleepStage structure
%
% USAGE:
% h = ffplothypno(SleepStage,epoch,plotType)
% 
% Helper function. It takes the output from ffimporthypno and plots a
% hypnogram with thicker, color coded horizontal lines, and gray, thin 
% vertical lines (See Tufte "Display of quantitative information"). Also
% uses the "hypColor" colormap, although other colormap schemes could be
% used.
% 
% INPUT:    
%   SleepStage: Structure with fields:
%               'hypno': hypnogram in vector format,
%               with states represented by numbers (e.g. 1 = wake, 2 =
%               nonRem, 3 = Rem, 0 = Doubt). 
%               'states': matrix with as many columns as states, as many
%               rows as epochs scored, and a logical index indicating the
%               state at that epoch.
%               't': time vector.
%               
%   epoch:      2-elements vector with epoch to plot.
% 
%   plotType:   hypnogram type. Can be either 'strip' or 'stair'. Default:
%               'stair'
% 
% OUTPUT:
%   h = handles of the axes object.
%
% See also: ffimporthypno

% (c) 2010 Francisco J. Flores.

% test input arguments
if nargin < 2
    epoch = [];
    plotType = 'stair';
elseif nargin < 3
    plotType = 'stair';
end

hypno = SleepStage.hypno;
states = SleepStage.states;
t = SleepStage.t;
bin = round(t(2)-t(1));

% if epoch exist, then cut the data
if ~isempty(epoch)
    idx = t>=epoch(1) & t<=epoch(2);
    hypno = hypno(idx);
    states = states(idx,:);
    t = t(idx);
end

% inform what bin size is being used
% disp(['Using ' num2str(bin) ' secs bin size'])

% plot hypnogram as a colored strip
if strcmpi(plotType,'strip')
    h = imagesc(t,[],hypno'); axis xy
    load hypColor
    colormap(hypColor)
    set(gca,...
        'yticklabel',{},...
        'fontname','times new roman')
    pbaspect([10 1 1])
    box off
    
elseif strcmpi(plotType,'stair')
    % plot hypnogram as a stair plot, but with dimished, gray vertical lines,
    % and thick, colored horizontal lines
    h = stairs(t,hypno,'color',[.7 .7 .7],'linewidth',.5);
    [m,n] = size(states);
    
    % plot wake lines
    tWake = t(states(:,1));
    for i = 1:length(tWake)
        line([tWake(i) tWake(i)+bin],[1 1],'color',[0 .5 0],'linewidth',3)
    end
    % plot nrem lines
    tNrem = t(states(:,2));
    for i = 1:length(tNrem)
        line([tNrem(i) tNrem(i)+bin],[2 2],'color',[0 0 .8],'linewidth',3)
    end
    
    % plot rem lines
    tRem = t(states(:,3));
    for i = 1:length(tRem)
        line([tRem(i) tRem(i)+bin],[3 3],'color',[.8 0 0],'linewidth',3)
    end
    
    axis tight
    ylim([0 4])
%     xlabel('Time (secs)')
    set(gca,...
        'ytick',[1 2 3],...
        'yticklabel',{'WAKE'; 'NREM'; 'REM'},...
        'fontname','times new roman')
%     pbaspect([3 1 1])
%     set(gcf,'color','w')
    box off
end

