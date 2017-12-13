function nlynx = readnlynx( fileName, epoch, dec )

% READNLYNX      reads neuralynx channels.
%
% Syntax:
% nlynx = readnlynx( fileName )
% nlynx = readnlynx( fileName, epoch )
% nlynx = readnlynx( fileName, epoch, dec )
%
% Description:
% nlynx = readnlynx(fileName) returns a strucuture with all the data
% contained in the neuralynx channel, wether a csc, nst or ntt.
%
% nlynx = readnlynx(fileName,epoch) where epoch is a two element vector,
% returns the data from epoch(1) to epoch(2). the units of epoch are
% seconds.
%
% nlynx = readnlynx(fileName,epoch,dec) where dec is an integer scalar, 
% decimates the signal by the dec factor.
% 
% Examples:
% nlynx = readnlynx('CSC15.ncs') returns all the data from file CSC15,
% without downsampling.
% 
% nlynx = readnlynx('CSC15.ncs',[0 20]) returns the data for the first 20
% seconds of recording, without downsampling.
% 
% nlynx = readnlynx('CSC15.ncs',[],10) returns all the data, downsampled by
% a factor of 10.
%
% Dependencies:
% parsenlynxhdr.m
% interpts.m
% Nlx2MatCSC.m and mex files.


% Convert epoch to microseconds.
epoch = epoch * 1e6;

[~, ~, ext] = fileparts( fileName );
switch ext
    case '.ncs'
        nlynx = readlfpnlx( fileName, epoch, dec );
        
    case '.nst'
        % read stereotrode file
        
    case '.ntt'
        % read tetrode file
        
        
    case '.nse'
        % Read single electrode file
        parm4 = 1;
        ts = Nlx2MatSpike( fileName, [1 0 0 0 0], 0, parm4, [ ] );
        nlynx = struct(...
            'ts', ts./1000000 );
        
    otherwise
        error('Wrong file extension')
end

