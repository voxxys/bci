close all;
clear all;
cd E:\LocalData\ShishkinBCI
load s504_TnT_samples1;
% settings
channels = [2 8 13 14 15 16 17 18 19 20 24 25 44 45 46 47 48 49 50];
range_use = 80:120;

bFlipTrTst = true;

if(bFlipTrTst)
    samples2 = samples;
    classes2 = classes;
    samples.tst = samples2.tr;
    samples.tr = samples2.tst;
    classes.tst = classes2.tr;
    classes.tr = classes2.tst;
end;

[Nt_tr, Nch_tr, Ne_tr] =size(samples.tr);
%channels = [ 24 13 45 49 17 18 16 ];      %   channels - which channels should be used

%channels = [2, 8,13:50];
Nch_tr = length(channels);
ind1 = find(classes.tr==1);
ind0 = find(classes.tr==0);
N0= length(ind0);
N1 = length(ind1);
Nuse_tr = length(range_use);
X0 = zeros(Nch_tr,Nuse_tr*N0);
X1 = zeros(Nch_tr,Nuse_tr*N1);

range = 1:Nuse_tr;
for i=1:N0
    X0(:,range) = samples.tr(range_use,channels,ind0(i))';
    range = range+Nuse_tr;
end;
range = 1:Nuse_tr;
for i=1:N1
    X1(:,range) = samples.tr(range_use,channels,ind1(i))';
    range = range+Nuse_tr;
end;
W = FisherDA(X0,X1);
range = 1:Nuse_tr;
Q0 = zeros(1,N0);
Q1 = zeros(1,N1);
for i=1:N0
    Q0(i) = W'*X0(:,range)*X0(:,range)'*W;
    R0{i} = X0(:,range)*X0(:,range)'/length(range);
    range = range+Nuse_tr;
end;
range = 1:Nuse_tr;
for i=1:N1
    Q1(i) = W'*X1(:,range)*X1(:,range)'*W;
    R1{i} = X1(:,range)*X1(:,range)'/length(range);
    range = range+Nuse_tr;
end;

figure
plot(Q1,'r');
hold on;
plot(Q0,'b');

CM0 = cheap(R0{1:length(R0)});
CM1 = cheap(R1{1:length(R1)});
%CM0 = explog(R0{1:length(R0)});
%CM1 = (R1{1:length(R1)});

for i=1:N1
    if(dist(R1{i},CM1) < dist(R1{i},CM0))
        Dec1(i) = 1;
    else
        Dec1(i) = 0;
    end; 
end;
sensR = sum(Dec1)/length(Dec1)

for i=1:N0
    if(dist(R0{i},CM0) < dist(R0{i},CM1))
        Dec0(i) = 0;
    else
        Dec0(i) = 1;
    end;
end;
specR =1- sum(Dec0)/length(Dec0)

th = mean(Q0);
sensS = length(find(Q1>=th))/length(Q1)
specS = length(find(Q0<th))/length(Q0)

[Nt_tst, Nch_tst, Ne_tst] =size(samples.tst);
Nch_tst = length(channels);
ind1 = find(classes.tst==1);
ind0 = find(classes.tst==0);
M0= length(ind0);
M1 = length(ind1);

Nuse_tst = length(range_use);
X0 = zeros(Nch_tst,Nuse_tst*M0);
X1 = zeros(Nch_tst,Nuse_tst*M1);

range = 1:Nuse_tst;
for i=1:M0
    X0(:,range) = samples.tst(range_use,channels,ind0(i))';
    range = range+Nuse_tst;
end;
range = 1:Nuse_tst;
for i=1:M1
    X1(:,range) = samples.tst(range_use,channels,ind1(i))';
    range = range+Nuse_tst;
end;
range = 1:Nuse_tst;

G0 = zeros(1,M0);
G1 = zeros(1,M1);
for i=1:M0
    G0(i) = W'*X0(:,range)*X0(:,range)'*W;
    C0{i} = X0(:,range)*X0(:,range)'/length(range);
    range = range+Nuse_tst;
end;
range = 1:Nuse_tst;
for i=1:M1
    G1(i) = W'*X1(:,range)*X1(:,range)'*W;
    C1{i} = X1(:,range)*X1(:,range)'/length(range);
    range = range+Nuse_tst;
end;

figure
plot(G1,'r');
hold on;
plot(G0,'b');

for i=1:M1
    if(dist(C1{i},CM1) < dist(C1{i},CM0))
        Dec1_tst(i) = 1;
    else
        Dec1_tst(i) = 0;
    end; 
end;
sensR_tst = sum(Dec1_tst)/length(Dec1_tst)

for i=1:M0
    if(dist(C0{i},CM0) < dist(C0{i},CM1))
        Dec0_tst(i) = 0;
    else
        Dec0_tst(i) = 1;
    end;
end;

specR_tst =1- sum(Dec0_tst)/length(Dec0_tst)
th = mean(G0);

sensS_tst = length(find(G1>=th))/length(G1)
specS_tst = length(find(G0<th))/length(G0)





