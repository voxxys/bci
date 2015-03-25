close all;
clear all;
% Load experiment results
%Q = load('exp_result_8.mat');
%Q = load('exp_result_9.mat');
Q = load('exp_result_10.mat');

% Signal
X = Q.data.data(:,1:Q.data.sz_used);                % channels x samples
sample_idx = Q.data.sample_idx(1:Q.data.sz_used);

% Channel names
chan_names = Q.data.chan_names;

% Sampling rate
srate = Q.data.srate;

% True states
states = Q.states.data(:,1:Q.states.sz_used);
assert(all(sample_idx == Q.states.sample_idx(1:Q.states.sz_used)) == 1);
X = resample(X',1,2)';
states = states(1:2:end);
srate = srate/2;

z0 = sum(abs(X(1:2,:)),1);
ind = find(z0>5.0*median(z0));

z = X(:,ind);
Cz = z*z';
[u s v] = svd(Cz);
P = eye(size(Cz))-u(:,[1:4])*u(:,[1:4])';
Xp = P*X;

[b0,a0] = butter(5,[5,25]/(0.5*srate));
Xpf = filtfilt(b0,a0,Xp')';
i = 1;
clear C1 SSD1 F1 V1;
f0_ind = 1;
for f0 = 8:0.5:20
    p(1,:) = [f0-1.5,f0-0.5];
    p(3,:) = [f0+0.5,f0+1.5];
    p(2,:) = [f0-0.5,f0+0.5];
    for f = 1:3
        [b{i}(f,:),a{i}(f,:)] = butter(5,p(f,:)/(0.5*srate));
        x = filtfilt(b{i}(f,:),a{i}(f,:),double(Xpf'))';
        ind = find(states==1);
        ind = ind(fix(length(ind)/2):end);
        C1{f} = x(:,ind)*x(:,ind)'/size(x(:,ind),2);
        C1{f} = C1{f}+ 0.05*trace(C1{f})/size(C1{f},1)*eye(size(C1{f}));
    end;
    [v e] = eig(C1{2},0.5*(C1{1}+C1{3}));
    [mxv, mxi] = max(diag(e)); 
    SSD1(i) = mxv;
    V1(:,i) = v(:,mxi);
    F1(i) = f0;
    i = i+1
end;
col = ['r','g','b','k'];
% index of an interesting peak
K = 4;
VK = V1(:,K);
figure
% iterate to focus more on the pattern
for ii = 1:3
    x0 = filtfilt(b{K}(2,:),a{K}(2,:),double(VK'*Xpf))';
    x0abs = abs(hilbert(x0));
    subplot(2,1,1)
    plot(x0abs,col(ii));
    hold on
    subplot(2,1,2);
    plot(VK, col(ii));
    hold on
    pause
    ind = find(x0abs>1.5*mean(x0abs));
    for f = 1:3
        x = filtfilt(b{K}(f,:),a{K}(f,:),double(Xpf'))';
        C1{f} = x(:,ind)*x(:,ind)'/size(x(:,ind),2);
        C1{f} = C1{f}+ 0.05*trace(C1{f})/size(C1{f},1)*eye(size(C1{f}));
    end;
    [v e] = eig(C1{2},0.5*(C1{1}+C1{3}));
    [mxv, mxi] = max(diag(e)); 
    SSDK = mxv;
    VK = v(:,mxi);
end;

x0 = filtfilt(b{K}(2,:),a{K}(2,:),double(VK'*Xpf))';
x0abs = abs(hilbert(x0));
%Then, based on thresholding x0abs we can segment the timeseries into blocks
% with persistent spatial and frequency structure.

