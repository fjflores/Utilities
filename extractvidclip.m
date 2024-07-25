function extractvidclip( vidPath, evTs, varargin )
% EXTRACTVIDCLIP extracts a clip of a video based on the timestamps (sec)
% of the start and end of the event of interest.
%
% Usage:
% extractvidclip( vidDir, v2read, evTs )
% extractvidclip( vidDir, v2read, evTs, Name, Value )
%
% Input:
% vidPath: full path (including extension) of video to extract clip from.
% evTs: timestamp(s) of the start and end of the event(s) of interest 
% (seconds) in [ ev1Start ev1End; ev2Start ev2End; ...] format.
% Name-Value pairs:
%   'Pad': desired padding of time around event (e.g., [ 10 30 ] would
%   start the clip 10 seconds before the event start and end it 30 seconds
%   after event end.
%   'FPS': frames per second of video.
%   'SaveDir': directory to save clip into (if different from parent
%   video).
%   'EvMsg': string to append to parent video file name (e.g., 'seiz' will
%   append 'seiz1' to clip file name for the first event).
%   'SaveFlag': whether or not to save clip.
%
% Output: 
% Saves (if SaveFlag true) or displays (if SaveFlag false) video clip.

% Extract parent video directory and file name.
[ vidDir, vidName, vidExt ] = fileparts( vidPath );

% Set defaults.
padding = [ 10 10 ];
fps = 30;
saveDir = vidDir;
evMsg = 'ev';
saveFlag = true;

% Parse  name-value pairs
names = varargin( 1 : 2 : end );
values = varargin( 2 : 2 : end );
for k = 1 : numel( names )
    switch lower( names{ k } )
        case { "pad", "padding" }
            padding = values{ k };
            
        case "fps"
            fps = values{ k };
            
        case "savedir"
            saveDir = values{ k };
            
        case { "evmsg", "eventmsg", "eventmessage" }
            evMsg = values{ k };
            
        case "saveflag"
            saveFlag = values{ k };
            
        otherwise
            error( '''%s'' is not a valid Name for Name, Value pairs.',...
                names{ k } )
            
    end
    
end

% Load full video.
fullVid = VideoReader( vidPath );

% Iterate over each event.
nEvs = size( evTs, 1 );
for evIdx = 1 : nEvs
    % Get timestamps for start and end of clip.
    tEvStart = evTs( evIdx, 1 );
    tEvEnd = evTs( evIdx, 2 );
    tClipStart = tEvStart - padding( 1 );
    tClipEnd = tEvEnd + padding( 2 );
    
    % Get times to display.
    nFrames = floor( ( tClipEnd - tClipStart ) * fps );
    t2disp = ( tClipStart : 1 / fps : tClipEnd - 1 / fps ) - tEvStart;
    
    thisEvMsg = sprintf( '%s%i', evMsg, evIdx );
    v2save = [ vidName, '_', thisEvMsg, vidExt ];
    outVideo = VideoWriter( fullfile( saveDir, v2save ), 'Motion JPEG AVI');
    outVideo.FrameRate = fps;
    
    fullVid.CurrentTime = tClipStart;
    open( outVideo )
    for i = 1 : nFrames
        frame = readFrame( fullVid );
        
        thisTDisp = t2disp( i );
        fTime = sprintf( '%.1f', thisTDisp );
        
        if thisTDisp < 0 || thisTDisp > ( tEvEnd - tEvStart )
            boxColor = 'y';
            
        else
            boxColor = 'g';
            
        end
        
        frameWText = insertText(...
            frame, [ 630 20 ], fTime,...
            'FontSize', 28,...
            'TextColor', 'r',...
            'BoxColor', boxColor );
        
        if saveFlag
            writeVideo( outVideo, frameWText );
            
        else
            imshow( frameWText ); % Display the frame
            drawnow; % Update the display
            
        end
        
    end
    
    close( outVideo )
    
end

if saveFlag
    fprintf( 'Video clip(s) saved successfully!\n' )
    
else
    fprintf( 'Video clip(s) extracted successfully!\n' )
    
end


end

