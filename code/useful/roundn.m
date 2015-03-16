function y = roundn(x, prec)

q = 10^(-prec);

y = x * q;
y = round(y);
y = y / q;

end

