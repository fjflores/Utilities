function multiDat = plotmulticol( sigMat, t, xcoords, ycoords )

% Put channels in physical order
figure

szRows = max( ycoords ) + 1;
szCols = max( xcoords ) + 1;

% make labels
for j = 1 : szRows
    labs{ j } = num2str( j - 1 );
    
end


for i = 1 : szCols
    colIdx = xcoords == i - 1;
    thisCol = sigMat( :, colIdx );
    yCol = ycoords( colIdx ) + 1;
    sortCol = thisCol( :, yCol );
    multiDat( :, :, i ) = sortCol;
    subplot( 1, 4, i )
    plotoffsetsignals( sortCol, 150, t, labs );
    xlim( [ 3 8 ] )
    box off
    
end