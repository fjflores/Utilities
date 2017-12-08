function plothypno(sleepStage,epoch,plotType)
%PLOTHYPNO plots a hypnogram using the output of IMPORTHYPNO
% PLOTHYPNO(SLEEPSTAGE,EPOCH,PLOTTYPE)
% plot hypnogram with thicker horizontal lines, and gray, thin vertical
% lines, from the output of IMPORTHYPNO 
% INPUT:    sleepStage: output from importhypno.
%           epoch: 2-elements vector with epoch to plot.
%           plotType: hypnogram type. Can be either 'strip' or 'stair'. Default:
%           'stair'
%           bin: bin size used to epoch the states. Default 10.
%
% (c) Francisco J. Flores 02-Jul-2010

% test input arguments
if nargin < 2
    epoch = [];
    plotType = 'stair';
elseif nargin < 3
    plotType = 'stair';
end

hypno = sleepStage.hypno;
states = sleepStage.states;
t = sleepStage.t;
bin = round(t(2)-t(1));

% if epoch exist, then cut the data
if ~isempty(epoch)
    idx = t>=epoch(1) & t<=epoch(2);
    hypno = hypno(idx);
    states = states(idx,:);
    t = t(idx);
end

% inform what bin size is being used
disp(['Using ' num2str(bin) ' secs bin size'])

% plot hypnogram as a colored strip
if strcmpi(plotType,'strip')
    imagesc(t,[],hypno'), axis xy
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
    stairs(t,hypno,'color',[.7 .7 .7],'linewidth',.5);
    
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

