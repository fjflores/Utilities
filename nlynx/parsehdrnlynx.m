function hdrInfo = parsehdrnlynx( hdr )
% PARSENLXHDR(HDR) parses old and new neuralynx header files.
%
% Ussage:
% hdrInfo = parsenlxhdr(hdr)
%
% Input:
% hdr: cell array containing the header from a CSC neuralynx file.
%
% Output:
% hdrInfo: Structure with the most important header information.

% Check if cell
if ~iscell( hdr )
    error('hdr must be a MATLAB cell data class')
    
end

% Check header style
if ~isempty( regexp( hdr{ 5 }, '-Cheetah', 'match' ) )
%     disp( 'Parsing Cheetah 5.4 header style' )
    hdrInfo = parsehdr1( hdr );
    
elseif ~isempty( regexp( hdr{ 10 }, '-Cheetah', 'match' ) )
%     disp( 'Parsing Cheetah 5.6 header style' )
    hdrInfo = parsehdr2( hdr );
    
elseif ~isempty( regexp( hdr{ 12 }, 'Cheetah', 'match' ) )
%     disp( 'Parsing Cheetah 5.7 header style' )
    hdrInfo = parsehdr3( hdr );
    
else
    error('Problem with header version. Check manually')
    
end



