function Results =  ClassifyTestShrinkage(samples,classes,Params)

[Nt_tr, Nch_tr, Ne_tr] =size(samples);

if(nargin==2)
    Params.channels = 1:Nch_tr;
    Params.W = [];    Params.range_use = 1:Nt_tr;
end;

range_use = Params.ranges_use{1};
channels  = Params.channels;
    
Nch_tr = length(channels);
ind1 = find(classes==1);
ind0 = find(classes==0);
N0= length(ind0);
N1 = length(ind1);
Nuse_tr = length(range_use);
X0 = zeros(Nch_tr*length(range_use),N0);
X1 = zeros(Nch_tr*length(range_use),N1);
for i=1:N0
    tmp = samples(range_use,channels,ind0(i))';
    X0(:,i) = tmp(:);
end;

for i=1:N1
    tmp = samples(range_use,channels,ind1(i))';
    X1(:,i) = tmp(:);
end;

if(isempty(Params.W))
    X = [X0 X1]';
    Y = [ones(1,N0) 2*ones(1,N1)]';
    obj = train_shrinkage(X,Y);
    W = obj.W;
else
    W = Params.W;
end;

Q0 = W'*X0;
Q1 = W'*X1;
th1 = mean(Q1);
th0 = mean(Q0);
% compute 20 points of ROC curve
dth = (th1-th0)/19;
k=1;
for k=1:20
    th = th0+dth*(k-1);
    Results.sens(k) = length(find(Q1<=th))/length(Q1);
    Results.spec(k) = length(find(Q0>th))/length(Q0);
end;
th = 0.5*(th0+th1);
Results.sens0 = length(find(Q1<=th))/length(Q1);
Results.spec0 = length(find(Q0>th))/length(Q0);
Results.W   = W;
Results.Q0  = Q0;
Results.Q1   = Q1;


return  
