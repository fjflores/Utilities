% protoype script to plot specgrams one by one. These need to be edited in
% illustrator after the fact.

files = dir('*Spec*');
for iFiles = 1:length(files)
    name = files(iFiles).name;
    load(name)
    figHandle = figure(1);
    set(figHandle,'color','w')
    imagesc(t,f,10*log10(S)'), axis xy
    pbaspect([2 1 1]), box off
    
    % set plot title using regular expressions
    undScore = regexp(name,'_');
    if numel(undScore) > 1
        undScore = undScore(1);
    end
    title(['Channel ' name(1:undScore-1)],...
        'fontname','times new roman')
    
    xlabel('Time (secs)','fontname','times new roman')
    ylabel('Power (mV^2/Hz)','fontname','times new roman')
    set(gca,...
        'fontname','times new roman')
    pause
end