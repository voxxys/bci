clear all
%exp_data = load('C:\Work\BCI\bci-master\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');
exp_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');

[data, sample_idx_data] = exp_data.data.get_data();
[states, sample_idx_states] = exp_data.states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);


% buf_data -> exp_data.data  

Fs = exp_data.data.srate;
L = size(data,2);
NFFT = 2^nextpow2(L);


data_cur = data;
states_cur = states;

Fc_low = 45;
Fc_high = 0.5;

%Wn =  Fc /(Fs/2)

[z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
[b_high,a_high] = zp2tf(z_high,p_high,k_high);
data_cur = filtfilt(b_high, a_high,data_cur')'; 

[z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
[b_low,a_low] = zp2tf(z_low,p_low,k_low);
data_cur = filtfilt(b_low, a_low,data_cur')'; 

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

data_cur_save = data_cur;

%%

ind1 = find(states==1);
ind2 = find(states==2);

Cz1 = data_cur(:,ind1)*data_cur(:,ind1)'/length(ind1);
Cz2 = data_cur(:,ind2)*data_cur(:,ind2)'/length(ind2);

[Vz,Dz] = eig(Cz1 + 0.01*trace(Cz1)/size(Cz1,1)*eye(size(Cz1)),Cz2+ 0.01*trace(Cz2)/size(Cz2,1)*eye(size(Cz2,1)));
iVz = inv(Vz)';
W1 = Vz(:,1:3);
G1 = iVz(:,1:3);

[Vz,Dz] = eig(Cz2 + 0.01*trace(Cz2)/size(Cz2,1)*eye(size(Cz2)),Cz1+ 0.01*trace(Cz1)/size(Cz1,1)*eye(size(Cz1,1)));
iVz = inv(Vz)';
W2 = Vz(:,1:3);
G2 = iVz(:,1:3);

% measurement errors

Rme_1 = (data_cur-G1*W1'* data_cur)*(data_cur-G1*W1'* data_cur)'/size(data_cur,2);
Rme_2 = (data_cur-G2*W2'* data_cur)*(data_cur-G2*W2'* data_cur)'/size(data_cur,2);


%%

AROrder = 5;
Dim = 3;

data_1 = data_cur(:,ind1);
data_2 = data_cur(:,ind2);

z_cur_1 = W1' * data_1;
z_cur_2 = W2' * data_2;

% specifying AR models

for ord = 1:AROrder AL{ord} = logical(ones(Dim));end;

z_cur_n_prev_1 = z_cur_1(:,1:AROrder);
z_cur_n_fit_1 = z_cur_1(:,(AROrder+1):end);

Spec_1 = vgxset('ARsolve',AL);
[EstSpec_1,EstSE,logL,W] = vgxvarx(Spec_1,z_cur_n_fit_1',[],z_cur_n_prev_1');


z_cur_n_prev_2 = z_cur_2(:,1:AROrder);
z_cur_n_fit_2 = z_cur_2(:,(AROrder+1):end);

Spec_2 = vgxset('ARsolve',AL);
[EstSpec_2,EstSE,logL,W] = vgxvarx(Spec_2,z_cur_n_fit_2',[],z_cur_n_prev_2');

%% finding Q_1, Q_2

z_pred_q = zeros(size(z_cur_1));
for t = (AROrder+1):size(z_cur_1,2)
    z_prev_q = z_cur_1(:,(t-AROrder):(t-1));
    [Forecast,ForecastCov] = vgxpred(EstSpec_1,1,[],z_prev_q');
    z_pred_q(:,t) = Forecast';
    t
end
%Q_1 = cov(z_pred_q(:,(AROrder+1):end),z_cur_1(:,(AROrder+1):end));

Q_1 = z_pred_q(:,(AROrder+1):end) * z_cur_1(:,(AROrder+1):end)' / size(z_cur_1(:,(AROrder+1):end),2);


z_pred_q = zeros(size(z_cur_2));
for t = (AROrder+1):size(z_cur_2,2)
    z_prev_q = z_cur_2(:,(t-AROrder):(t-1));
    [Forecast,ForecastCov] = vgxpred(EstSpec_2,1,[],z_prev_q');
    z_pred_q(:,t) = Forecast';
    t
end
%Q_1 = cov(z_pred_q(:,(AROrder+1):end),z_cur_1(:,(AROrder+1):end));

Q_2 = z_pred_q(:,(AROrder+1):end) * z_cur_2(:,(AROrder+1):end)' / size(z_cur_2(:,(AROrder+1):end),2);


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

dim = 3;
z_pred_1 = zeros(dim,size(data_cur,2));
z_pred_2 = zeros(dim,size(data_cur,2));

P_1 = Q_1;
P_2 = Q_2;

% z_pred_init = zeros(dim,size(data_cur,2));

state_pred = zeros(1,size(data_cur,2));



for t = (R+1):80000%size(data_cur,2)
% t=R+1;
    data_prev = data_cur(:,(t-R):(t-1));
    
    z_prev_1 = W1' * data_prev;
    z_prev_2 = W2' * data_prev;
    
    [Forecast_1,ForecastCov] = vgxpred(EstSpec_1,1,[],z_prev_1');
    [Forecast_2,ForecastCov] = vgxpred(EstSpec_2,1,[],z_prev_2');
    
    z_pred_1(:,t) = Forecast_1';
    z_pred_2(:,t) = Forecast_2';
    
%     z_pred_init(:,t) = Forecast';
    
    P_1 = A1_P * P_1 * A1_P' + Q_1;
    K_1 = P_1*G1'/((G1*P_1*G1')+ Rme_1); 
    
    P_2 = A2_P * P_2 * A2_P' + Q_2; 
    K_2 = P_2*G2'/((G2*P_2*G2')+ Rme_2); 
    
    z_pred_1(:,t) = z_pred_1(:,t) + K_1 * (data_cur(:,t) - G1*z_pred_1(:,t));
    z_pred_2(:,t) = z_pred_2(:,t) + K_2 * (data_cur(:,t) - G2*z_pred_2(:,t));

    t
        
    er_1 = sum((data_cur(:,t) - G1*z_pred_1(:,t)).^2); 
    er_2 = sum((data_cur(:,t) - G2*z_pred_2(:,t)).^2);
    
    state_pred(t) = (er_2 < er_1) + 1;
end
