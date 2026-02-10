function plotethogram( stateLabels, t, opts )
% PLOTETHOGRAM plots an ethogram for any number of states
% 
% Usage:
% plotethogram( states, t, 'PlotLines', true, 'StateNames', {...} )
% 
% Input:
% stateLabels: matrix with state labels in timepoints x # of states
%   format, or a vector of state labels.
% t: timestamps vector. Optional.
% Name-Value pairs:
%   'PlotLines'  - boolean flag to plot horizontal lines. Default: true.
%   'StateNames' - cell array of state names for y-axis labels.
%   'SingleRow'  - boolean flag. If true, plots all states on a single
%       row using color to distinguish states. Default: false (stacked).
%   'States'     - vector of state numbers to plot, e.g. [2 3]. States
%       not in this list are set to NaN. Default: [] (all states).

arguments
    stateLabels
    t = []
    opts.PlotLines (1,1) logical = true
    opts.StateNames = []
    opts.SingleRow (1,1) logical = false
    opts.States = []
end

% Check input.
% Check if vector or matrix. convert to matrix if vector
if isrow( stateLabels ) || iscolumn( stateLabels )
    % stateLabels is not a matrix. Build one.
    ethoMat = buildethomat( stateLabels );
    
else
    % stateLabels is a matrix.
    ethoMat = stateLabels;
    
end
[ nPoints, nStates ] = size( ethoMat );

if isempty( t )
    t = 1 : nPoints;
    
end

plotLines  = opts.PlotLines;
stateNames = opts.StateNames;
singleRow  = opts.SingleRow;
states2use = opts.States;

% Makes zeros nans to get transparency in plot.
ethoMat( ethoMat == 0 ) = NaN;

% Keep only selected states, NaN-out the rest.
if ~isempty( states2use )
    for s = 1 : nStates
        if ~ismember( s, states2use )
            ethoMat( :, s ) = NaN;
            
        end
        
    end
    
end

t2plot = t;
t2plot( end + 1 ) = t2plot( end ) + mean( diff( t2plot ) );

if singleRow
    % Plot all states on a single row. Reconstruct label vector from
    % ethoMat so each timepoint gets its state number as the color value.
    labelVec = nan( nPoints, 1 );
    for s = 1 : nStates
        labelVec( ethoMat( :, s ) == s ) = s;
        
    end
    
    % Pad for pcolor.
    pcolEtho = [ labelVec'; labelVec' ];
    pcolEtho( :, end + 1 ) = NaN;
    yEdges = [ 1 2 ];
    pcolor( t2plot, yEdges, pcolEtho );
    shading flat
    caxis( [ 1 nStates ] )
    hold on
    axis xy
    box off
    set( gca, 'YTick', 1.5, 'YTickLabels', {''}, 'TickDir', 'out' )
    ylim( [ 1 2 ] )
    
else
    % Stacked mode: each state on its own y-row.
    % Add fake columns and rows because of stupid pcolor.
    dummy = cat( 2, ethoMat, nStates * ones( nPoints, 1 ) );
    pcolEtho = cat( 1, dummy, nStates * ones( 1, nStates + 1 ) );
    
    states2plot = 1 : nStates + 1;
    pcolor( t2plot, states2plot, pcolEtho' );
    shading flat
    caxis( [ 1 nStates ] )
    hold on
    axis xy
    box off
    set( gca,...
        'YTick', ( 1 : nStates ) + 0.5,...
        'TickDir', 'out' )
    if ~isempty( states2use )
        ylim( [ 1 numel( states2use ) + 1 ] )

    end
    
    if isempty( stateNames )
        set( gca, 'YTickLabels', 1 : nStates )
        
    else
        set( gca, 'YTickLabels', stateNames )
        
    end
    
    if plotLines
        for i = 1 : nStates
            plot( [ 0 t( end ) ], double( i ) + zeros( 1, 2 ),...
                'Color', [ 0.8 0.8 0.8 ], 'Linewidth', 0.1 )
            
        end
        
    end
    
end