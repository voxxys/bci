function [Results] = ClassifyTestRiemanFisherN(samples,classes,Params)


if nargin<2
    disp('Wrong number of args, need at least 3, i.e. ClassifyTestFisher(samples,classes)')
    Qout = 0;
    Spec = 0;
    Sens = 0;
    W = 0;
    return;
end;

[Nt_tr, Nch_tr, Ne_tr] =size(samples);

if(nargin==2)
    Params.channels = 1:Nch_tr;
    Params.W = [];    
    Params.ranges_use ={};
    Params.ranges_use{1} = 1:Nt_tr;
end;

ranges_use = Params.ranges_use;
channels  = Params.channels;
    
Nch_tr = length(channels);
ind1 = find(classes==1);
ind0 = find(classes==0);
N0= length(ind0);
N1 = length(ind1);

for i=1:N0
    for r = 1:length(ranges_use)
        Y = samples(ranges_use{r},channels,ind0(i))';
        R0{r}{i} = Y*Y'/length(ranges_use{r});
    end;
end;
clear Y;
for i=1:N1
    for r = 1:length(ranges_use)
        Y = samples(ranges_use{r},channels,ind1(i))';
        R1{r}{i} = Y*Y'/length(ranges_use{r});
    end;
end;

% compute cheap means in the Riemanian space
if(isempty(Params.CM0) || isempty(Params.CM1))
    for r = 1:length(ranges_use)
        CM0{r} = cheap(R0{r}{1:length(R0{r})});
        CM1{r} = cheap(R1{r}{1:length(R1{r})});
    end;
else
    CM0 = Params.CM0;
    CM1 = Params.CM1;
end;
% test
F1 = zeros(2*length(ranges_use),N1);
for r = 1:length(ranges_use)
    for i=1:N1
        F1(2*(r-1)+1,i) = dist(R1{r}{i},CM0{r});
        F1(2*(r-1)+2,i) = dist(R1{r}{i},CM1{r});
    end;
end;

F0 = zeros(2*length(ranges_use),N0);
for r = 1:length(ranges_use)
    for i=1:N0
        F0(2*(r-1)+1,i) = dist(R0{r}{i},CM0{r});
        F0(2*(r-1)+2,i) = dist(R0{r}{i},CM1{r});
    end;
end;


% find weights
if(isempty(Params.W))
    W = FisherDA(F0,F1);
else
    W = Params.W;
end;

Q0 = W'*F0;
Q1 = W'*F1;

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
Results.W = W;
Results.Q1 = Q1;
Results.Q0 = Q0;
Results.CM0 = CM0;
Results.CM1 = CM1;


