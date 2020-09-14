function cleanData = ffrmlinesc( data, Fs, detr )

% FFRMLINESC    removes 60 hz line using chronux.
% 
% Usage:
% cleanData = ffrmlinesc( data, Fs )
% cleanData = ffrmlinesc( data, Fs, detr )
% 
% Description:
% cleanData = ffrmlinesc(data,params) will remove the 60 Hz line from data,
% based on the specified params. The function is 
% optimized for data recorded unsing neuralynx, with Fs = 2713 Hz. Will
% have to play with other parameters for signals with different sampling
% rates. right now, there is ~180 cycles of the 60 Hz per 3 second epoch.
% 
% Input:
% data: 1-D vector with electrophysiological data.
% Fs: sampling frequency.
% detr: boolean flag. If true, then detrend epochs. Defalut: false.
% 
% Output:
% cleanData: data with 60 Hz removed.

% issue warning about data length
warning( 'This function cuts the original data. Check your timestamps' )

if nargin < 3
    detr = false;
    
elseif nargin == 3 && ~islogical( detr )
    error( 'detr must be logical' )
    
end

% set optimal parameters for 60 Hz removal
params = struct(...
    'tapers', [ 2 3 ],...
    'fpass', [ 30 200 ],...
    'Fs', Fs,...
    'pad', 1);

epochDur = 3; % set to three seconds epochs.

dataMat = makesegments( data, Fs, [ 3 3 ] );
if detr == true
      dataMat = detrend( dataMat );
end

f0 = [ 60 120 180 ]; % frequency to remove.
cleanData = rmlinesc( dataMat, params, 0.01, 'n', f0 );
cleanData = cleanData( : );



    