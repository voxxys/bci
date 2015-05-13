

[maxval,maxind] = max(res_te(:));
[i1,i2,i3,i4] = ind2sub(size(res_te),maxind);


fmin{i} = Fc_highs(i1);
fmax{i} = Fc_highs(i1) + Bws(i2);

