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
    deltaLength = nTotal - length( signal );
    seg = nan( deltaLength, 1 );
    signal = [ signal; seg ];
    cutSig = signal;
    
elseif length( signal ) > nTotal
    deltaLength = length( signal ) - nTotal;
    signal( end - deltaLength + 1 : end ) = [ ];
    cutSig  = signal;
    
else
    cutSig = signal;
    return
    
end

end
