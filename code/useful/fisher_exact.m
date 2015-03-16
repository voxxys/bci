function pval = fisher_exact(C)

assert(size(C,1)==2);
assert(size(C,2)==2);

a = C(1,1);
b = C(1,2);
c = C(2,1);
d = C(2,2);

% Row and column totals
ab = a + b;
cd = c + d;
ac = a + c;
bd = b + d;

% Table total
N = a + b + c + d;

% Min. of all row / column totals
mintotal = min([ab cd ac bd]);

% Min. total is for 2-nd row - flip rows
if mintotal == cd       
    t=a; a=c; c=t;
    t=b; b=d; d=t;
    t=ab; ab=cd; cd=t;
end
% Min.total is for 2-nd column - flip columns
if mintotal == bd       
    t=a; a=b; b=t;
    t=c; c=d; d=t;
    t=ac; ac=bd; bd=t;
end

a_vals = [0 : mintotal]; 

% Calculate hypergeom. pdf for each table with the same totals
for k = 1 : length(a_vals)

    a1 = a_vals(k);    
    p(k) = hygepdf(a1, N, ab, ac);
    %fprintf('%i\t%.04f\n', a1, p(k));
   
end

% Calculate sum of all probabilities that are less or equal
% than the probability of a given table
k0 = find(a_vals==a);
idx = find(p <= p(k0));
pval = sum(p(idx));

%fprintf('%f\n', sum(p));

end

