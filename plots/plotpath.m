function [ax,pat,time] = plotpath(statepath,stimes,numStates)

if numStates == 3
    defaults = [ 
        0.0000    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250];
elseif numStates == 4
    defaults = [ 
        0.4940    0.1840    0.5560;...
        0.0000    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250];
else
    defaults = [ 
        0.4940    0.1840    0.5560;...
        0.0000    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250;...
        0.4660    0.6740    0.1880;...
        0.3010    0.7450    0.9330;...
        0.6350    0.0780    0.1840;...
        0.4940    0.1840    0.5560;...
        0         0.4470    0.7410];
end

dt = stimes(2)-stimes(1);
numstates = max(statepath);
time = zeros(4,length(stimes));
time(1,:) = stimes;
time(2,:) = stimes;
time(3,:) = stimes+dt;
time(4,:) = stimes+dt;


pat =  zeros(4,length(stimes));
pat(1,:) = statepath-.5;
pat(2,:) = statepath+0.5;
pat(3,:) = statepath+0.5;
pat(4,:) = statepath-.5;


for i = 1:numstates
    
    ind = (statepath == i);
    patch(time(:,ind),pat(:,ind),defaults(i,:),'EdgeColor','none');
    hold on
end
yticks(1:numstates)
ylim([0.5,numstates+0.5])
set(gca,'TickLength',[0 0])
ax = gca;
end
