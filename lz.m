function C = lz( S )
% LZ computes the Lempel-Ziv complexity of a binary or text sequence.
% 
% Usage:
% C = lz( S )
% 
% Input:
% S: text or binary sequence
% 
% Ouptut:
% C: complexity value
% 
% Reference:
% https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv_complexity
% Code translated to MATLAB by BARD.

n = length( S );
i = 0;
C = 1;
u = 1;
v = 1;
vMax = v;

while u + v <= n
    if S(i + v) == S(u + v)
        v = v + 1;

    else
        vMax = max(v, vMax);
        i = i + 1;

        if i == u
            C = C + 1;
            u = u + vMax;
            v = 1;
            i = 0;
            vMax = v;

        else
            v = 1;

        end

    end

end

if v ~= 1
    C = C + 1;

end