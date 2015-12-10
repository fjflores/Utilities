function cutSig = procustesbed( signal, nTotal )
%PROCUSTESBED cuts a signal if long, and pads with nan's if short.
%
% Usage:
% shortSig = procustesbed( signal, ntotal )
%
% Input:
% signal: column vector with signal to cut.
% nTotal: Total length, in samples, of the desired signal.
%
% Output:
% cutSig: longer or shorter signal.

if length( signal ) < nTotal
%     disp(' in shorter case')
    deltaLength = nTotal - length( signal );
%     disp( [ '  delta = ' num2str( deltaLength ) ] )
    seg = nan( deltaLength, 1 );
    signal = [ signal; seg ];
    cutSig = signal;
%     disp( [ '  final length: ' num2str( length(signal) ) ] )
    
elseif length( signal ) > nTotal
%     disp(' in longer')
    deltaLength = length( signal ) - nTotal;
%     disp( [ '  delta = ' num2str( deltaLength ) ] )
    signal( end - deltaLength + 1 : end ) = [ ];
    cutSig  = signal;
%     disp( [ '  final length: ' num2str( length(signal) ) ] )
    
else
    disp( 'Signal length exactly matches desired length' )
    cutSig = signal;
    return
    
end

end
