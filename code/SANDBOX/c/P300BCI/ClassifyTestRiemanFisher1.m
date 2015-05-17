function [Results] = ClassifyTestRiemanFisher1(samples,classes,Params)


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
    Params.range_use = 1:Nt_tr;
    Params.range_use ={};
    Params.ranges_use{1} = 1:Nt_tr;
end;

range_use = Params.range_use;
channels  = Params.channels;
    
Nch_tr = length(channels);
ind1 = find(classes==1);
ind0 = find(classes==0);
N0= length(ind0);
N1 = length(ind1);
Nuse_tr = length(range_use);

for i=1:N0
    Y = samples(range_use,channels,ind0(i))';
    R0{i} = Y*Y'/length(range_use);
end;
clear Y;
for i=1:N1
    Y = samples(range_use,channels,ind1(i))';
    R1{i} = Y*Y'/length(range_use);
end;

% compute cheap means in the Riemanian space
if(isempty(Params.CM0) || isempty(Params.CM1))
    CM0 = cheap(R0{1:length(R0)});
    CM1 = cheap(R1{1:length(R1)});
else
    CM0 = Params.CM0;
    CM1 = Params.CM1;
end;
% test
F1 = zeros(2,N1);
for i=1:N1
    F1(1,i) = dist(R1{i},CM0);
    F1(2,i) = dist(R1{i},CM1);
end;

F0 = zeros(2,N0);
for i=1:N0
    F0(1,i) = dist(R0{i},CM0);
    F0(2,i) = dist(R0{i},CM1);
end;

% find weights
if(length(Params.W)~=length(channels))
    W = FisherDA(F0,F1);
else
    W = Params.W;
end;

Q0 = W'*F0;
Q1 = W'*F1;

k=1;
for ThFact = 0.1:0.1:2
    th = ThFact*0;
    Results.sens(k) = length(find(Q1>=th))/length(Q1);
    Results.spec(k) = length(find(Q0<th))/length(Q0);
    k = k+1;
end;
Results.W = W;
Results.Q1 = Q1;
Results.Q0 = Q0;
Results.CM0 = CM0;
Results.CM1 = CM1;

th = 0;
Results.sens0 = length(find(Q1<th))/length(Q1);
Results.spec0 = length(find(Q0>=th))/length(Q0);


