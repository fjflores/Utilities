function changeticklabel(h,newTime,zeroPoint)

% CHANGETICKLABEL real timestamp in sec to relative in min
% INPUT: h: handles of the axes object to change
%        newTime: vector of time in minutes to display in min
%        zeroPoint: point zero to which time will be relative in secs
% EXAMPLE: changeticklabel(h,[-15 0 15],3000) will make the newTime vector
% be centered around the original 3000 sec timestamp

aSec = newTime*60;
set(h,'xtick',aSec+zeroPoint) % 4790 is the injection timestamp
set(h,'xticklabel',num2cell((aSec+zeroPoint)-zeroPoint));
set(h,'xticklabel',num2cell(((aSec+zeroPoint)-zeroPoint)/60));