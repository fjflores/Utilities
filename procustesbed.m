function adjSig = procustesbed( signal, nTotal, modo )
%PROCUSTESBED cuts a signal if long, and pads with nan's if short.
%
% Usage:
% shortSig = procustesbed( signal, ntotal ) cuts a signal to a length of 
% nTotal if longer, or pads the signal with NaN's to nTotal if shorter.
%
% Input:
% signal: column vector with signal to cut.
% nTotal: Total length, in samples, of the desired signal.
% modo: if signal is shorter, pad with NaNs if "nan" or with 0's if "zero";
%
% Output:
% cutSig: longer or shorter signal.

if length( signal ) < nTotal
    deltaLength = nTotal - length( signal );
    switch modo
        case 'nan'
            disp( 'Adding nan''s.' )
            seg = nan( deltaLength, 1 );
    
        case 'zero'
            disp( 'Adding zeros.' )
            seg = zeros( deltaLength, 1 );
            
    end
    signal = [ signal; seg ];
    adjSig = signal;
    
elseif length( signal ) > nTotal
    deltaLength = length( signal ) - nTotal;
    signal( end - deltaLength + 1 : end ) = [ ];
    adjSig  = signal;
    
else
    adjSig = signal;
    return
    
end

end
