function scaledMat = minmaxscaling( origMat )

minVals = min( origMat );
maxVals = max( origMat );
scaledMat = ( origMat - minVals ) ./ ( maxVals - minVals );