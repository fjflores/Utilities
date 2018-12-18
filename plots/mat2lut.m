%Mat2Lut converts a matlab color lookup table into 
%an Osirix format text file that can be used with
%MRIcro or MRIcron
%Each row of the matlab matrix has 3 columns: red green blue
%  for example, 1 1 0 specifies bright yellow [red+green]
%  while 0 0 0.5 specifies a dark blue
%You also need to specify the filenames where you want the
%  new lut files created. 
lut = [1 1 1; 1 0.7 0; 1 0.3 0; 1 0 0];
filename = 'c:\test.lut';
filenamelinear = 'c:\testlinear.lut';

%you do not need to edit anything below this line...

nIndex = 255;
%first - discrete steps....
fid = fopen(filename, 'wt');
fprintf(fid, '* s=byte	index	red	green	blue\n');
len = length(lut);
for i=0:nIndex, %repeat for each index
	q = floor(len* i/(nIndex+1))+1;
	fprintf(fid, 'S\t%g\t%g\t%g\t%g \n',i, round(255*lut(q,1)),round(255*lut(q,2)),round(255*lut(q,3)) );
end; %repeat for each index
fclose(fid);

fid = fopen(filenamelinear, 'wt');
fprintf(fid, '* s=byte	index	red	green	blue\n');
low = 0;
for i=1:(len-1), %repeat for each index
	hi = round((i/(len-1))*255); 
	%red= (linspace(lut(1,i),lut(1,i+1),(hi-low+1)));
	red= (linspace(lut(i,1),lut(i+1,1),(hi-low+1)));
	green= (linspace(lut(i,2),lut(i+1,2),(hi-low+1)));
	blue= (linspace(lut(i,3),lut(i+1,3),(hi-low+1)));
	for outline=1:length(red),
	  fprintf(fid, 'S\t%g\t%g\t%g\t%g \n',outline+low-1, round(255*red(outline)),round(255*green(outline)),round(255*blue(outline)) );

	end;%for each line
	%q = (hi-low+1)
	low = hi+1;
end; %repeat for each index
fclose(fid);