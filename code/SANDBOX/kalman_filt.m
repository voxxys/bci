clear all
clc

%exp_data = load('C:\Work\BCI\bci-master\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');
%exp_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');
load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_2603_first_real_T20.mat')

% [data, sample_idx_data] = exp_data.data.get_data();
% [states, sample_idx_states] = exp_data.states.get_data();
% assert(all(sample_idx_data == sample_idx_states) == 1);

data_cur = data.data;
states_cur = states.data;
sample_idx = data.sample_idx;

% buf_data -> exp_data.data  

Fs = 1000;
L = size(data_cur,2);
NFFT = 2^nextpow2(L);


Fc_low = 20;
Fc_high = 11;

%Wn =  Fc /(Fs/2)

[z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
[b_high,a_high] = zp2tf(z_high,p_high,k_high);
data_cur = filtfilt(b_high, a_high,data_cur')'; 

[z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
[b_low,a_low] = zp2tf(z_low,p_low,k_low);
data_cur = filtfilt(b_low, a_low,data_cur')'; 

data_cur = data_cur(:,1:2:end);
states_cur = states_cur(1:2:end);
sample_idx = sample_idx(1:2:end);


% % 

sds = 2.2;

row_mean = mean(data_cur,2);
row_std = std(data_cur,0,2);

mask = (abs(data_cur-row_mean(:,ones(1,size(data_cur,2)))) < sds * row_std(:,ones(1,size(data_cur,2))));

idx = ~sum(~mask,1);

idx = find(idx);
data_cur = data_cur(:,idx);
states_cur = states_cur(idx);
sample_idx = sample_idx(idx);


% 
% Xmean = mean(data_cur(:));
% Xstd = std(data_cur(:));
% mask = (abs(data_cur-Xmean) < 3 * Xstd);
% mask = prod(double(mask),1);
% idx = mask;
% idx = logical(idx);
% data_cur = data_cur(:,idx);
% states_cur = states(idx);
% 

state_changes = find(diff(states_cur));
kfold_delims = [state_changes, floor(state_changes(1)/2), state_changes(1:(end-1))+floor(diff(state_changes)/2)];
kfold_delims = sort(kfold_delims);

states_kfold_delims = states_cur(kfold_delims);

kfold_delims = [0,kfold_delims];

for i = 1:24
   part_idx = (kfold_delims(i)+1):kfold_delims(i+1);
   data_part{i} = data_cur(:,part_idx);
   states_part{i} = states_cur(part_idx);
   sample_idx_part{i} = sample_idx(part_idx);
end



%%
parts_1 = find(states_kfold_delims == 1);
parts_2 = find(states_kfold_delims == 2);
parts_6 = find(states_kfold_delims == 6);

mask_1 = ismember(sample_idx,horzcat(sample_idx_part{parts_1}));
mask_2 = ismember(sample_idx,horzcat(sample_idx_part{parts_2}));
mask_6 = ismember(sample_idx,horzcat(sample_idx_part{parts_6}));

data_1 = data_cur(:,mask_1);
states_1 = states_cur(:,mask_1);

data_2 = data_cur(:,mask_1);
states_2 = states_cur(:,mask_2);

data_6 = data_cur(:,mask_6);
states_6 = states_cur(:,mask_6);


Cz1 = data_1*data_1'/size(data_1,2);
Cz2 = data_2*data_2'/size(data_2,2);
Cz6 = data_6*data_6'/size(data_6,2);

[Vz,Dz] = eig(Cz1 + 0.05*trace(Cz1)/size(Cz1,1)*eye(size(Cz1)),Cz6+ 0.01*trace(Cz6)/size(Cz6,1)*eye(size(Cz6,1)));
iVz = inv(Vz)';
W1 = Vz(:,[1:4, (end-3):end]);
G1 = iVz(:,[1:4, (end-3):end]);

[Vz,Dz] = eig(Cz2 + 0.05*trace(Cz2)/size(Cz2,1)*eye(size(Cz2)),Cz6+ 0.01*trace(Cz6)/size(Cz6,1)*eye(size(Cz6,1)));
iVz = inv(Vz)';
W2 = Vz(:,[1:4, (end-3):end]);
G2 = iVz(:,[1:4, (end-3):end]);

% measurement errors

Rme_1 = (data_cur-G1*W1'* data_cur)*(data_cur-G1*W1'* data_cur)'/size(data_cur,2);
Rme_2 = (data_cur-G2*W2'* data_cur)*(data_cur-G2*W2'* data_cur)'/size(data_cur,2);


%%


AROrder = 1;
Dim = 8;

data_1 = data_cur(:,states_cur == 1);
data_2 = data_cur(:,states_cur == 2);

z_cur_1 = W1' * data_1;
z_cur_2 = W2' * data_2;

% specifying AR models

for ord = 1:AROrder AL{ord} = logical(ones(Dim));end;

z_cur_n_prev_1 = z_cur_1(:,1:AROrder);
z_cur_n_fit_1 = z_cur_1(:,(AROrder+1):end);

% Spec_1 = vgxset('ARsolve',AL);
Spec_1 = vgxset('ARsolve',AL);
[EstSpec_1,EstSE,logL,W] = vgxvarx(Spec_1,z_cur_n_fit_1',[],z_cur_n_prev_1');

z_cur_n_prev_2 = z_cur_2(:,1:AROrder);
z_cur_n_fit_2 = z_cur_2(:,(AROrder+1):end);

% Spec_2 = vgxset('ARsolve',AL);
Spec_2 = vgxset('ARsolve',AL);
[EstSpec_2,EstSE,logL,W] = vgxvarx(Spec_2,z_cur_n_fit_2',[],z_cur_n_prev_2');

%% finding Q_1, Q_2
z_pred_q1 = zeros(size(z_cur_1));
for t = (AROrder+1):size(z_cur_1,2)
    val = zeros(Dim,1);
    for k=1:AROrder
        val = val + EstSpec_1.AR{k}*z_cur_1(:,t-k);
    end;
    z_pred_q1(:,t) = val;
end
z_pred_q2 = zeros(size(z_cur_2));
for t = (AROrder+1):size(z_cur_2,2)
    val = zeros(Dim,1);
    for k=1:AROrder
        val = val + EstSpec_2.AR{k}*z_cur_2(:,t-k);
    end;
    z_pred_q2(:,t) = val;
end

res_error1 = z_pred_q1(:,(AROrder+1):end) - z_cur_1(:,(AROrder+1):end);
res_error2 = z_pred_q2(:,(AROrder+1):end) - z_cur_2(:,(AROrder+1):end);

Q_1 = res_error1*res_error1' / size(z_cur_1(:,(AROrder+1):end),2);
Q_2 = res_error2*res_error2' / size(z_cur_2(:,(AROrder+1):end),2);

%%

data_1 = data_cur(:,states_cur == 1);
data_2 = data_cur(:,states_cur == 2);

R = AROrder;

% A1_P, A2_P

x_t = z_cur_1(:,(R+1):end);

x_lag = z_cur_1(:,R:(end-1));
A1_P = pinv(x_lag')*x_t';

x_t = z_cur_1(:,(R+1):end);
x_lag = z_cur_1(:,R:(end-1));

A2_P = pinv(x_lag')*x_t';

dim = 8;
z_pred_1 = zeros(dim,size(data_cur,2));
z_pred_2 = zeros(dim,size(data_cur,2));

P_1 = Q_1;
P_2 = Q_2;

z_prev_1 = W1' * data_cur;
z_prev_2 = W2' * data_cur;

state_pred = zeros(1,size(data_cur,2));
state_pred_pdf = zeros(1,size(data_cur,2));
state_pred_new = zeros(1,size(data_cur,2));
er1 = zeros(1,size(data_cur,2));
er2 = zeros(1,size(data_cur,2));
er1_sum = zeros(1,size(data_cur,2));
er2_sum = zeros(1,size(data_cur,2));


win = 50;

for t = (R+1):size(data_cur,2)
    
    val = zeros(Dim,1);
    for k=1:AROrder
        val = val + EstSpec_1.AR{k}*z_prev_1(:,t-k);
    end;
    z_pred_1(:,t) = val;
    
    val = zeros(Dim,1);
    for k=1:AROrder
        val = val + EstSpec_2.AR{k}*z_prev_2(:,t-k);
    end;
    z_pred_2(:,t) = val;
    
    P_1 = A1_P * P_1 * A1_P' + Q_1;
    K_1 = P_1*G1'/((G1*P_1*G1')+ Rme_1); 
    
    P_2 = A2_P * P_2 * A2_P' + Q_2; 
    K_2 = P_2*G2'/((G2*P_2*G2')+ Rme_2);
    
    z_pred_1(:,t) = z_pred_1(:,t) + K_1 * (data_cur(:,t) - G1*z_pred_1(:,t));
    z_pred_2(:,t) = z_pred_2(:,t) + K_2 * (data_cur(:,t) - G2*z_pred_2(:,t));


% for state_pred
    er_1(t) = sum((data_cur(:,t) - G1*z_pred_1(:,t)).^2); 
    er_2(t) = sum((data_cur(:,t) - G2*z_pred_2(:,t)).^2);
    er_1_sum(t) = sum(er_1(max(1,t-win):t));
    er_2_sum(t) = sum(er_2(max(1,t-win):t));

%     [A11 B11 r11 U11 V11] = canoncorr(data_cur(:,max(1,t-win):t)',(G1*z_pred_1(:,max(1,t-win):t))');
%     [A12 B12 r12 U12 V12] = canoncorr(data_cur(:,max(1,t-win):t)',(G2*z_pred_2(:,max(1,t-win):t))');
%     
%     er_1(t) = 1 - abs(r11(1)); 
%     er_2(t) = 1 - abs(r12(1));
%     

% for state_pred_pdf
    p_1(t) = mvnpdf(W1' * data_cur(:,t),z_pred_1(:,t),P_1);
    p_2(t) = mvnpdf(W2' * data_cur(:,t),z_pred_2(:,t),P_2);
    pdf_1_sum(t) = sum(p_1(max(1,t-win):t));
    pdf_2_sum(t) = sum(p_2(max(1,t-win):t));
    
    state_pred(t) = (er_2_sum(t) < er_1_sum(t)) + 1;
    
    state_pred_pdf(t) = (pdf_1_sum(t) < pdf_2_sum(t)) + 1;
    
end
