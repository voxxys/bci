exp_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_12_03_2.mat');

[data, sample_idx_data] = exp_data.data.get_data();
[states, sample_idx_states] = exp_data.states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);

% buf_data -> exp_data.data  

Fs = exp_data.data.srate;
L = size(data,2);
NFFT = 2^nextpow2(L);


data_cur = data;

Fc_low = 45;
Fc_high = 0.5;

%Wn =  Fc /(Fs/2)

%[b_high, a_high] = butter(3, Fc_high/(Fs/2), 'high');
[z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
[sos_high,g_high] = zp2sos(z_high,p_high,k_high);
% fvtool(sos_high,'Analysis','freq');
hd_high = dfilt.df2sos(sos_high,g_high);

data_cur = (filter(hd_high,data_cur'))'; 

%[b_low, a_low] = butter(3, Fc_low/ (Fs/2), 'low');
[z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
[sos_low,g_low] = zp2sos(z_low,p_low,k_low);
% fvtool(sos_low,'Analysis','freq');
hd_low = dfilt.df2sos(sos_low,g_low);

data_cur = (filter(hd_low,data_cur'))'; 


Xmean = mean(data_cur(:));
Xstd = std(data_cur(:));
mask = (abs(data_cur-Xmean) < 3 * Xstd);
mask = prod(double(mask),1);
idx = mask;
idx = logical(idx);
data_cur = data_cur(:,idx);
states_cur = states(idx);


data_1 = data_cur(:,states_cur == 1);
data_2 = data_cur(:,states_cur == 2);

C_1 = data_1 * data_1' / size(data_1,2);
C_2 = data_2 * data_2' / size(data_1,2);
C_rest = data_cur * data_cur' / size(data_cur,2);

[V_1 d_1] = eig(C_1,C_rest);
Vinv_1 = inv(V_1');
g_1 = [Vinv_1(1,:); Vinv_1(end,:)];

[V_2 d_2] = eig(C_2,C_rest);
Vinv_2 = inv(V_2');
g_2 = [Vinv_2(1,:); Vinv_2(end,:)];


R = 500;
% A_1 = zeros(R,R,length((R+1):1000:size(data_1,2)));
% A_2 = zeros(R,R,length((R+1):1000:size(data_2,2)));

% A_1 = zeros(R,R);
% A_2 = zeros(R,R);

% A_1(:,:,t-R) = pinv(x_lag_1)*x_t_1;

% for t = (R+1):1000:size(data_1,2)
t = size(data_1,2);
    x_t_1 = data_1(:,(t-R+1):t);
    x_lag_1 = data_1(:,(t-R):(t-1));
%     A_1(:,:,t-R) = pinv(x_lag_1)*x_t_1;
    A_1 = pinv(x_lag_1)*x_t_1;

    Q_1 = cov(x_t_1 - x_lag_1*A_1);
% end

% for t = (R+1):1000:size(data_2,2)
t = size(data_2,2);
    x_t_2 = data_2(:,(t-R+1):t);
    x_lag_2 = data_2(:,(t-R):(t-1));
%     A_2(:,:,t-R) = pinv(x_lag_2)*x_t_2;
    A_2 = pinv(x_lag_1)*x_t_1;
    
    Q_2 = cov(x_t_2 - x_lag_2*A_2);
% end

% A_1_mean = mean(A_1,3);
% A_2_mean = mean(A_2,3);
% 
% RiemDist(A_1_mean,A_2_mean);

%%
P_1 = Q_1;
C_1 = g_1;

P_2 = Q_2;
C_2 = g_2;

data_pred_1 = zeros(size(g_1 * data_cur));
data_pred_2 = zeros(size(g_1 * data_cur));

for t = (R+1):size(data_cur,2)
    
% % % % %     

    data_chunk = data_cur(:,(t-R):t);

    data_pred_1(:,t) = g_1 * (sum(A_1 * data_chunk',1))';

    P_1 = A_1 * P_1 * A_1' + Q_1;

    K_1 = P_1*C_1'/(C_1*P_1*C_1'); % + R_1

    data_pred_1(:,t) = data_pred_1(:,t) + K * (g_1 * data_real(:,t) - data_pred_1(:,t));
    
    P_1 =  (eye(size(data_cur,1))-K*C_1)*P_1;

% % % % %     
    
    data_pred_2(:,t) = g_2 * (sum(A_2 * data_chunk',1))';

    P_2 = A_2 * P_2 * A_2' + Q_2;

    K_2 = P_2*C_2'/(C_2*P_2*C_2'); % + R_1

    data_pred_2(:,t) = data_pred_2(:,t) + K * (g_2 * data_real(:,t) - data_pred_2(:,t));
    
    P_2 =  (eye(size(data_cur,1))-K*C_2)*P_2;
    
    
end





