function v = veclcm(x)
% Find least common multiple of vector elements
% (It is slow so don't use it for large vectors)

v = 1;

for n = 1 : length(x)   
    v = lcm(v, x(n));    
end

end

