function [ hAx, pat, time ] = plotpath( statePath, sTimes, numStates, yAxLoc )

colMap = brewermap( 9, 'Pastel1' );
% stateCols = colMap( numStates, : );
% elseif numStates == 1
%     defaults = [ 0.5 0.5 0.5 ];
%     
% elseif numStates == 2
%     defaults = [ 
%         0.0000    0.4470    0.7410;...
%         0.8500    0.3250    0.0980 ];
%         
% elseif numStates == 3
%     defaults = [ 
%         0.0000    0.4470    0.7410;...
%         0.8500    0.3250    0.0980;...
%         0.9290    0.6940    0.1250];
% elseif numStates == 4
%     defaults = [ 
%         0.4940    0.1840    0.5560;...
%         0.0000    0.4470    0.7410;...
%         0.8500    0.3250    0.0980;...
%         0.9290    0.6940    0.1250];
% else
%     defaults = [ 
%         0.4940    0.1840    0.5560;...
%         0.0000    0.4470    0.7410;...
%         0.8500    0.3250    0.0980;...
%         0.9290    0.6940    0.1250;...
%         0.4660    0.6740    0.1880;...
%         0.3010    0.7450    0.9330;...
%         0.6350    0.0780    0.1840;...
%         0.4940    0.1840    0.5560;...
%         0         0.4470    0.7410];
% end

dt = sTimes( 2 ) - sTimes( 1 );
numstates = max( statePath );
time = zeros( 4, length( sTimes ) );
time( 1, : ) = sTimes;
time( 2, : ) = sTimes;
time( 3, : ) = sTimes + dt;
time( 4, : ) = sTimes + dt;


pat =  zeros( 4, length( sTimes ) );
pat( 1, : ) = statePath - 0.5;
pat( 2, : ) = statePath + 0.5;
pat( 3, : ) = statePath + 0.5;
pat( 4, : ) = statePath - 0.5;
% 
% if strcmp( yAxLoc, 'right' )
%     yyaxis right
%     yAxTick = [ ];
%     
% end

for stateIdx = 1 : numStates
    ind = ( statePath == stateIdx );
    patch(...
        time( :, ind ),...
        pat( :, ind ),...
        colMap( stateIdx, : ),...
        'EdgeColor', 'none' );
    hold on
    
end

yticks( 1 : numstates )
ylim( [ 0.5, numstates + 0.5 ] )
set(...
    gca,...
    'TickLength', [ 0 0 ] )
hAx = gca;

end
