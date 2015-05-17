range = 1:50;
k=1;
clear C d;
while(range(end)<500)
    C{k} = X(:,range)*X(:,range)';
    if(k>5)
        M = cheap(C{k-5:k});
        v = [];
        for s = 0:5
            v(s+1) = dist(M,C{k-s});
            d(k) = sum(v);
        end;
    end;
    k = k+1;
    range = range+10;
end;


