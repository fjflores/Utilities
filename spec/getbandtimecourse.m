function bandtc = getbandtimecourse( S, t, f, band, dur, base, art )
%GETBANDTIMECOURSE gets the timepoints when a frequency band exists. 
% 
% Usage:
% bandtc = getbandtimecourse( S, t, f, band, dur, base, art )
% 
% Input:
% S, t, f: specctrogram, time, and frequency.
% band: two-element vector with frequency band limits.
% dur: minimal duration of band presence.
% base: boolean, whether to use a baseline.
% art: boolean, whether to identify and remove artifacts.
% 
% Output:
% bandtc: structure with results for band time-course. It has the fields:
%   Pdelta 
%   deltaSm 
%   deltaDurLoc 
%   durLocIdx 
%   deltaCleanIdx 
%   artIdx 
%   medGlob 
%   art 
%   dur 
%   fact

% Get first 10 minutes
if base
    idxBase = t < 900;
    Sbase = S( idxBase, : );

else
    Sbase = S;

end

% Find artifacts first, whenever the total power exceeds 9 times the global
% median.
% Get Delta power
Pdelta = powerperband( Sbase, f, band, 'total' );
deltaProc = movmedian( Pdelta, 17 ); % 10 sec median filter.
[ m, n ] = size( Sbase );
if art == true
    disp( 'Computing artifact locations...' )
    fact = 12;
    Ptotal = powerperband( Sbase, f, [ 0.5 30 ], 'total' );
    medTot = median( Ptotal );
    artIdx = Ptotal > fact * medTot;
    deltaProc( artIdx ) = [ ];

else
    disp( 'Skipping artifact identification...' )
    artIdx = false( m, 1 );
    deltaProc( artIdx ) = [ ];

end


% deltaProc( artIdx ) = [ ];
% med = median( Pdelta );

% Find median for low power periods.
% 1. Compute global median
medGlob = median( deltaProc );

% 2. Iteratively Remove all data points above fact times the global median.
cnt = 1;
test = 10e6;
fact = 2.5;
disp( 'Computing median threshold...' )
while test > 1.3 %Iterate until difference is less than 1 dB (1.3 mV^2).
    fprintf( 'Iteration #%u, ', cnt );
    remIdx = deltaProc > fact * medGlob;
    deltaProc( remIdx ) = [ ];
    fprintf( '%u points left.\n', length( deltaProc ) );
    medNew = median( deltaProc );
    test = medGlob - medNew;
    medGlob = medNew;
    cnt = cnt + 1;

end

% Apply the threshold.
Pdelta = powerperband( S, f, [ 0.5 4 ], 'total' );
deltaSm = movmedian( Pdelta, 17 ); % thirty second median filter.
deltaIdx = deltaSm > fact * medGlob;
% cleanIdx = xor( deltaIdx, artIdx );

% Find duration and peak, and then keep the indices of peaks with more than
% x duration.
fprintf( 'Applying duration threshold...\n' )
durLocs = consecones( deltaIdx );
minDur = floor( dur * ( 1 / mean( diff( t ) ) ) );
runs2keep = find( durLocs >= minDur );
% build new idx vector using durlocs and mindur.
cnt = 1;
newIdx = zeros( 1, length( deltaIdx ) );
while cnt <= length( runs2keep )
    thisChunk = runs2keep( cnt );
    thisDur = durLocs( thisChunk );
    temp = ones( 1, thisDur );
    newIdx( thisChunk : thisChunk + thisDur -1 ) = temp;
    cnt = cnt + 1;

end
deltaCleanIdx = newIdx;

% And then use consecones again to find the indices for delta start.
deltaDurLoc = consecones( newIdx );
durLocIdx = logical( deltaDurLoc );

% Set the output structures
bandtc.Pdelta = Pdelta;
bandtc.deltaSm = deltaSm;
bandtc.deltaDurLoc = deltaDurLoc;
bandtc.durLocIdx = durLocIdx;
bandtc.deltaCleanIdx = deltaCleanIdx;
bandtc.artIdx = artIdx;
bandtc.medGlob = medGlob;
bandtc.art = art;
bandtc.dur = dur;
bandtc.fact = fact;
disp( 'Done!' )