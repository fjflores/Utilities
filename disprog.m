function disprog( i, n, steps )
%DISPROG Display progression of a loop.
%	DISPROG(i,N,steps) displays the progression of a loop.
%
%	i     : loop variable
%	n     : final value of i
%	STEPS : number of displayed steps.
%
%	Example:
%	 N=16; for i=1:N, disprog(i,N,5); end;

persistent start

if i == 1
    start = tic;
    
end

if i == n
    fprintf( ' 100%% complete in %.2f seconds.\n', toc( start ) );
    clear start;
    
elseif floor( i * steps / n ) ~= floor( ( i - 1 ) * steps / n )
    fprintf(' %g%%', floor( i * steps / n ) * ceil( 100 / steps ) );
    
end


