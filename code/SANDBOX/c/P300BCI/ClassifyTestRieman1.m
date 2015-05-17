function [Results] = ClassifyTestRieman1(samples,classes,Params)


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
    Params.W = [];    Params.range_use = 1:Nt_tr;
end;

range_use = Params.range_use;
channels  = Params.channels;
    
Nch_tr = length(channels);
ind1 = find(classes==1);
ind0 = find(classes==0);
N0= length(ind0);
N1 = length(ind1);
Nuse_tr = length(range_use);
X0 = zeros(Nch_tr,Nuse_tr*N0);
X1 = zeros(Nch_tr,Nuse_tr*N1);
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
B1 = zeros(1,N1);
for i=1:N1
    B1(i) = double(dist(R1{i},CM1) < dist(R1{i},CM0));
end;
sens0 = sum(B1)/length(B1);

B0 = zeros(1,N0);
for i=1:N0
    B0(i) = double(dist(R0{i},CM0) < dist(R0{i},CM1));
end;

spec0 =sum(B0)/length(B0);

Results.CM0 = CM0;
Results.CM1 = CM1;
Results.sens0 = sens0;
Results.spec0 = spec0;
Results.B0 = B0;
Results.B1 = B1;

return;




