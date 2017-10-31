function ans = aliasof(inp)

ans = evalin('caller',inp);