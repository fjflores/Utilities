function rgb = hex2rgb( hex, scaleFlag )
% HEX2RGB converts hex color triplets to rgb triplets.
%
% Usage:
% rgb = hex2rgb( hex )
%
% Input:
% hex: a matrix of character arrays describing a hexadecimal color triplets.
%       E.g.: 'FF909F'.
% scaleFlag: whether to scale to 0 - 1.
%
% Output:
% rgb: at n x 3 matrix withRGB triplet. E.g. [ 255 144 159 ].

nColors = size( hex, 1 );
rgb = nan( nColors, 3 );
for i = 1 : nColors
    hex2use = upper( hex( i, : ) ); % just in case
    eachHex = regexp( hex2use, '[0-9A-F]{2}', 'match' );
    
    for j = 1 : 3
        if scaleFlag
            rgb( i, j ) = hex2dec( eachHex{ j } ) / 255;

        else
            rgb( i, j ) = hex2dec( eachHex{ j } );

        end

    end

end