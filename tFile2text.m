% tFile2text.m
% This script will extract the timestamps contained in MClust .t files and
% save the timestamps in a text file

function tFile2text(clusterID,tFilePath)

[timestamp , numSpikes] = readMclustTfile(tFilePath);

fout = [clusterID '.txt'];
fid = fopen(fout,'wt');
fprintf(fid, '%9.0f\n', timestamp);
fclose('all');