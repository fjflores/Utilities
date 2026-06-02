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
%   'Colors'   - Nx3 RGB matrix with one row per plotted state. Rows
%       are assigned to states in sorted state-number order, so row 1
%       colors the smallest active state, row 2 the next, etc. -- works
%       correctly even when state numbers are non-contiguous (e.g. 2,3,5,6).

arguments
    stateLabels
    t = []
    opts.PlotLines (1,1) logical = true
    opts.StateNames = []
    opts.SingleRow (1,1) logical = false
    opts.States = []
    opts.Colors = []
end

plotLines  = opts.PlotLines;
stateNames = opts.StateNames;
singleRow  = opts.SingleRow;
states2use = opts.States;
customCmap = opts.Colors;

% Check input.
% Check if vector or matrix. convert to matrix if vector
if isvector( stateLabels ) && ~singleRow
    % stateLabels is a vector. Build a matrix.
    ethoMat = buildethomat( stateLabels );
    [ nPoints, nStates ] = size( ethoMat );
    % buildethomat stores the state number as the cell value and removes
    % all-zero columns, so the column indices no longer match state numbers.
    % Record the actual state number for each column before normalizing.
    colStateNums = max( ethoMat, [], 1 );
    % Normalize to binary and convert inactive cells to NaN.
    ethoMat( ethoMat > 0 ) = 1;
    ethoMat( ethoMat == 0 ) = NaN;

elseif singleRow
    % singleRow is true.
    ethoMat = stateLabels;
    nPoints = numel( ethoMat );
    nStates = numel( unique( ethoMat( : ) ) );
    colStateNums = [];

else
    % stateLabels is already a matrix. Column index == state number.
    stateLabels( stateLabels > 0 ) = 1;
    ethoMat = stateLabels;
    [ nPoints, nStates ] = size( ethoMat );
    % Makes zeros nans to get transparency in plot.
    ethoMat( ethoMat == 0 ) = NaN;
    colStateNums = 1 : nStates;

end


if isempty( t )
    t = 1 : nPoints;

end

% Keep only selected states, NaN-out the rest.
% Match against colStateNums so state numbers are compared correctly even
% when buildethomat has removed zero columns (non-contiguous state numbers).
if ~isempty( states2use ) && ~singleRow
    for s = 1 : nStates
        if ~ismember( colStateNums( s ), states2use )
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
    uniqState = unique( ethoMat( : ) );
    uniqState( isnan( uniqState ) ) = [];
    nActive = numel( uniqState );

    if ~isempty( customCmap ) && size( customCmap, 1 ) ~= nActive
        error( 'plotethogram:colorMapSize', ...
            'Colors must have %d rows (one per unique state).', nActive );
    end

    for iState = 1 : nActive
        labelVec( ethoMat == uniqState( iState ) ) = iState;

    end

    % Pad for pcolor.
    pcolEtho = [ labelVec'; labelVec' ];
    pcolEtho( :, end + 1 ) = NaN;
    yEdges = [ 1 2 ];
    pcolor( t2plot, yEdges, pcolEtho );
    shading flat
    caxis( [ 1 nActive ] )
    hold on
    axis xy
    box off
    set( gca, 'YTick', 1.5, 'YTickLabels', {''}, 'TickDir', 'out' )
    ylim( [ 1 2 ] )
    if ~isempty( customCmap )
        colormap( gca, customCmap );
    end

else
    % Stacked mode: each state on its own y-row.
    %
    % Compact to only active (non-all-NaN) columns so non-contiguous state
    % numbers plot without y-axis gaps. Track actual state numbers for labels.
    activeCols      = find( any( ~isnan( ethoMat ), 1 ) );
    activeStateNums = colStateNums( activeCols );
    nPlotted        = numel( activeCols );
    ethoMat         = ethoMat( :, activeCols );

    % If a custom colormap is provided, encode each compacted column with
    % its rank (1,2,3,...) so each state gets a distinct colormap row.
    if ~isempty( customCmap )
        if size( customCmap, 1 ) ~= nPlotted
            error( 'plotethogram:colorMapSize', ...
                'Colors must have %d rows (one per plotted state).', nPlotted );
        end
        for iCol = 1 : nPlotted
            mask = ( ethoMat( :, iCol ) == 1 );
            ethoMat( mask, iCol ) = iCol;
        end
    end

    cmapMax = nPlotted;

    % Add fake columns and rows because of stupid pcolor.
    dummy    = cat( 2, ethoMat, cmapMax * ones( nPoints, 1 ) );
    pcolEtho = cat( 1, dummy,   cmapMax * ones( 1, nPlotted + 1 ) );

    states2plot = 1 : nPlotted + 1;
    pcolor( t2plot, states2plot, pcolEtho' );
    shading flat
    caxis( [ 1 cmapMax ] )
    hold on
    axis xy
    box off
    set( gca, ...
        'YTick',   ( 1 : nPlotted ) + 0.5, ...
        'TickDir', 'out' )
    ylim( [ 1 nPlotted + 1 ] )

    if isempty( stateNames )
        set( gca, 'YTickLabels', activeStateNums )

    else
        set( gca, 'YTickLabels', stateNames )

    end

    if plotLines
        for i = 1 : nPlotted
            plot( [ 0 t( end ) ], double( i ) + zeros( 1, 2 ), ...
                'Color', [ 0.8 0.8 0.8 ], 'Linewidth', 0.1 )

        end

    end

    if ~isempty( customCmap )
        colormap( gca, customCmap );
    end

end
