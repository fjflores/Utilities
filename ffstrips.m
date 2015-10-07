function ffstrips( sig, Fs, scale )
%FFSTRIPS  Strip plot for LFP signals.
%
% Usage:
% ffstrips( sig, Fs, scale )
% 
% ffstrips plots as many figures as necessary to plot 60 segments of signal
% sig. Each segment is fixed to 10 seconds long. and optimized for printing
% in a letter page. Total time per page is 10 min.
% 
% Input:
%  sig: 1D column vector with signal to plot.
%  Fs:  sampling frequency (in Hz).
%  scale: scale of strip plot. Default is 4.

% check user input
if nargin < 2
    error( 'Need the first 2 arguments. JK.' )
    
elseif nargin == 2
    scale = 4;
    
end

% set defaults for strip plot
lengthSeg = 10;

% find the number of "pages" (figures) needed to plot the signal
win = [ 300 300 ];
segments = makesegments( sig, Fs, win );
[ nPoints, nPages ] = size( segments );

% plot pages
for thisPage = 1 : nPages
    figure( thisPage )
    tempSig = locdetrend( segments( :, thisPage ), Fs, [ 2 0.1 ] );
    strips( tempSig, lengthSeg, Fs, scale )
    
    % set axes properties
    box off
    grid off
    
    hLine = get( gca, 'Children' );
    set( hLine,...
        'Color', 'k',...
        'LineWidth', 0.2 )
    
end



