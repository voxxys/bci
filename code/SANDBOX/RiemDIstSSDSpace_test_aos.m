clear all
%exp_data = load('C:\Work\BCI\bci-master\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');
exp_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');

[data, sample_idx_data] = exp_data.data.get_data();
[states, sample_idx_states] = exp_data.states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);

Fs = exp_data.data.srate;
L = size(data,2);
NFFT = 2^nextpow2(L);
clear Cr Dmax
%first scan frequency
for bnd = 1:20
    Fc_low = 2+bnd*2;
    Fc_high = bnd*2;
    data_cur = data;
    [z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
    [b_high,a_high] = zp2tf(z_high,p_high,k_high);
    data_cur = filtfilt(b_high, a_high,data_cur')'; 

    [z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
    [b_low,a_low] = zp2tf(z_low,p_low,k_low);
    data_cur = filtfilt(b_low, a_low,data_cur')'; 

    states_cur = states;
    borders = [1 find(abs(diff(states))==1) length(states)];
    Cz1 = zeros(31);
    Cz2 = zeros(31);
    Nz1 = 0;
    Nz2 = 0;
    for b = 2:length(borders)
        range = borders(b-1):borders(b);
        x = data_cur(:,range);
        st = fix(mean(states(range))+0.01); %?
        Cz1 = Cz1+(x*x'/size(x,2))*(st==2);
        Cz2 = Cz2+(x*x'/size(x,2))*(st==1);
        Nz1 = Nz1+sum(st==1);
        Nz2 = Nz2+sum(st==2);
    end;
    Cz1 = Cz1/Nz1;
    Cz2 = Cz2/Nz2;
    [V{bnd},D] = eig(Cz1 + 0.01*trace(Cz1)/31*eye(size(Cz1)),Cz2+ 0.01*trace(Cz2)/31*eye(31));
    % get envelope for the largest comp
    za = abs(hilbert(V{bnd}(:,end)'*data_cur));
    %compute corr coeff with target
    states_n = states-mean(states);
    states_n = states_n/norm(states_n);
    zan = za-mean(za); zan = zan/norm(zan);
    Cr(bnd) = states_n*zan';
    Cr(bnd)
    bnd
end
figure
plot(Cr)
grid
CrMxInd = input('Enter peak index:')
%[CrMx CrMxInd] = max(Cr)
P = V{CrMxInd}(:,[1:3 end-2:end]);
Fc_low = 2+CrMxInd*2;
Fc_high = CrMxInd*2;
data_cur = data;
[z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
[b_high,a_high] = zp2tf(z_high,p_high,k_high);
data_cur = filtfilt(b_high, a_high,data_cur')'; 
[z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
[b_low,a_low] = zp2tf(z_low,p_low,k_low);
data_cur = filtfilt(b_low, a_low,data_cur')';

states_cur = states;
borders = [1 find(abs(diff(states))==1) length(states)];
clear C SS
k = zeros(1,2);
for b = 2:length(borders)
    range = borders(b-1):borders(b);
    x = P'*data_cur(:,range);
    st = fix(mean(states(range))+0.01);
    st
    k(st)=k(st)+1;
    C{b-1}.C = x*x'/size(x,2);
    C{b-1}.S =st;
    SS(b-1) = st;
end;
[SS1 idx]=sort(SS);
Cs = C(idx);
D = zeros(length(Cs));
De = zeros(length(Cs));
for i = 1:length(Cs)
    for j=1:length(Cs)
       D(i,j) = RiemDist(diag(diag(Cs{i}.C)), diag(diag(Cs{j}.C)));
       d = diag((Cs{i}.C - Cs{j}.C));
        De(i,j) = sum(d(:).^2);
    end;
end;
figure
subplot(1,2,1), imagesc(D)
subplot(1,2,2), imagesc(De)

