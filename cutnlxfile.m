function cutnlxfile( fn, epoch )

% cut and saves a nlx file, continuous or spike, to the desired length
%
% INPUT:    fileName: complete name of the file to cut.
%           epoch: epoch to cut in microseconds (usually form neuraviewer)

if nargin < 2
    error('Need an epoch input.')
end

% get the file extension: tt, st or cs
[ ~, fileName, ext ] = fileparts( fn ); 

switch ext
    case strcmpi  (ext, 'ncs' )
        % do the continuous format
        if ~isempty( epoch )
            param4 = 1; % extract all if no peoch provided
        end
        [ts,scNum,cellNum,params,data,hdr] = nlx2matCSC_v4(...
            fn,...
            [1 1 1 1 1],...
            1,...
            param4,...
            epoch);
        
        % this will save the continuos files...
        % - write a new CSC file
        % - it will not append
        % - extract all the records from MATLAB
        % - mode array requires a 1 if extracting all from MATLAB
        param5 = length(timeStamps);
        app = inputdlg( 'Enter string to append' );
        file2save = [ fileName char(app)];
        mat2NlxCSC( file2Save, 0, 1, 1, param5, [1 1 1 1 1 1],...
            ts, scNum, cellNum, params, data, hdr );
%         save(file2save,'epoch')
        
    case strcmpi( ext, 'nst' )
        % do the stereotrode format
        % first it is necessary to read the Stereotrode Nlx file
        % the following will extract everything
        [timeStamps,ScNubers,cellNumbers,params,dataPoints,hdr] = nlx2matSpike_v4(...
            'ST1.nst',...
            [1 1 1 1 1],...
            1,...
            4,...
            [epoch(1) epoch(2)]);
        % this will save the stereotode files...
        % - write a new ST9_epoch file
        % - it will not append
        % - extract all the records from MATLAB
        % - mode array requires a 1 if extracting all from MATLAB
        param5 = length(timeStamps);
        mat2NlxST('ST11_epoch.nst',0,1,1,param5,[1 1 1 1 1 1],...
            timeStamps,ScNubers,cellNumbers,params,dataPoints,hdr);
        save('ST11_epoch','epoch')
        
    case strcmpi(ext,'ntt')
        % do the tetrode format
        % first it is necessary to read the Stereotrode Nlx file
        % the following will extract everything
        [timeStamps,ScNubers,cellNumbers,params,dataPoints,hdr] = nlx2matSpike_v4(...
            'TT1.nst',...
            [1 1 1 1 1],...
            1,...
            4,...
            [epoch(1) epoch(2)]);
        % this will save the stereotode files...
        % - write a new ST9_epoch file
        % - it will not append
        % - extract all the records from MATLAB
        % - mode array requires a 1 if extracting all from MATLAB
        strAppend = inputdlg( 'Enter string to append' );
        file2save = [ fileName char( strAppend )];
        param5 = length( timeStamps );
        mat2NlxTT( file2save, 0, 1, 1, param5,[1 1 1 1 1 1],...
            timeStamps,ScNubers,cellNumbers,params,dataPoints,hdr);
%         save('TT11_epoch','epoch')
        
    case strcmpi( ext, 'nse' )
        % do the tetrode format
        % first it is necessary to read the Stereotrode Nlx file
        % the following will extract everything
        [ timeStamps, ScNubers, cellNumbers, params, dataPoints, hdr ] = nlx2matSpike_v4(...
            'TT1.nst',...
            [1 1 1 1 1],...
            1,...
            4,...
            [ epoch( 1 ) epoch( 2 ) ]);
        % this will save the single electrode files...
        % - write a new ST9_epoch file
        % - it will not append
        % - extract all the records from MATLAB
        % - mode array requires a 1 if extracting all from MATLAB
        param5 = length( timeStamps );
        strAppend = inputdlg( 'Enter string to append' );
        file2save = [ fileName char( strAppend ) ];
        mat2NlxSE( file2save, 0, 1, 1, param5, [ 1 1 1 1 1 1 ],...
            timeStamps, ScNubers, cellNumbers, params, dataPoints, hdr );
        
end

% define start and end time. This epoch will start 1 sec before and end 1
% sec after. This is to be sure that all the necessary is included
% epoch = [17732300000 36482100000];




