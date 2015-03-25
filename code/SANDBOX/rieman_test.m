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
% 
% Xmean = mean(data_cur(:));
% Xstd = std(data_cur(:));
% mask = (abs(data_cur-Xmean) < 3 * Xstd);
% mask = prod(double(mask),1);
% idx = mask;
% idx = logical(idx);
% data_cur = data_cur(:,idx);
% states_cur = states(idx);

states_cur = states;

data_1 = data_cur(:,states_cur == 1);
data_2 = data_cur(:,states_cur == 2);

C_1 = data_1 * data_1' / size(data_1,2);
C_2 = data_2 * data_2' / size(data_1,2);

R = 5000;
states_riem = zeros(size(states_cur));
for t = (R+1):size(data_cur,2)
    
    dat_chunk = data_cur(:,(t-R):t);

    data_cm = dat_chunk * dat_chunk' / size(dat_chunk,2);
    rd_1 = abs(RiemDist(data_cm,C_1)); 
    rd_2 = abs(RiemDist(data_cm,C_2));
    
    if(rd_1 == min(rd_1,rd_2))
        idx_min = 1;
    else
        idx_min = 2;
    end
    
    states_riem(t) = idx_min;
    
    disp(t);
    
end

pred_ok = mean(states_cur((R+1):end) == states_riem((R+1):end));

