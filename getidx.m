function idx = getidx( ts, epochStart, epochEnd )

idx = find( ts > epochStart & ts < epochEnd );