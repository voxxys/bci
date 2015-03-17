function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP
% train_params.lambda - regularization coefficient for covariance matrices


% Get data & states
[data, sample_idx_data] = buf_data.get_data();
[states, sample_idx_states] = buf_states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);


%     nsamples_in = length(sample_idx_data);
%     disp(nsamples_in);
%     assert(0==1);

data_cur = data;

chan_names = buf_data.chan_names;

% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%     'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};

chosen = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};


% chosen = {'FC5','FC1','FC2','FC6','T7','C3','C4','T8','TP9','CP5','CP1','CP2','CP6','TP10', 'P7','P3','P4','P8','O1', 'Oz', 'O2'};%'FT9','FT10'};
%chosen = {'C3','C4','T8','TP9','CP5','CP1','CP2','CP6','TP10'}%,'P7','P3','P4','P8','FT9','FT10'};


chosen_left = {'FC1','FC5','CP5','TP9','CP1','T7','C3','P7','P3','O1'};
    
chosen_right = {'FC2','FC6','CP6','TP10','CP2','T8','C4','P8','P4','O2'};

mask_channels = zeros(1,length(chosen));
for i = 1:length(chosen)
    mask_channels(i) = find(strcmp(chan_names, chosen(i)));
    
end

mask_left = zeros(1,length(chosen_left));
for i = 1:length(chosen_left)
    mask_left(i) = find(strcmp(chosen, chosen_left(i)));
    
end

mask_right = zeros(1,length(chosen_right));
for i = 1:length(chosen_right)
    mask_right(i) = find(strcmp(chosen, chosen_right(i)));
    
end

data_cur = data_cur(mask_channels,:);

% for fft
Fs = buf_data.srate;
L = size(data,2);
NFFT = 2^nextpow2(L);



% Remove outliers
Xmean = mean(data_cur(:));
Xstd = std(data_cur(:));
mask = (abs(data_cur-Xmean) < 3 * Xstd);
mask = prod(double(mask),1);
idx = mask;
idx = logical(idx);
data_cur = data_cur(:,idx);
states_cur = states(idx);


data_cur_1 = data_cur(mask_left,:);

data_1 = data_cur_1(:,states_cur == 1);
data_2 = data_cur_1(:,states_cur == 2);

C_1 = data_1 * data_1' / size(data_1,2);
C_2 = data_2 * data_2' / size(data_1,2);

[V_lr d_lr] = eig(C_1,C_2);

M_lr = V_lr;

data_cur_lr = M_lr * data_cur_1;

y_cur_lr_1 = data_cur_lr(:,states_cur == 1)';
y_cur_lr_2 = data_cur_lr(:,states_cur == 2)';

for i = 1:2
    
    figure();
    freq_range = 1:0.01:30;
    spectrogram(y_cur_lr_1(:,i),1000,500,freq_range,Fs,'yaxis');
%         xlim([0 300]);
%         Xlim = get(gca, 'xlim');
%         set(gca, 'XTick', linspace(Xlim(1), Xlim(2), 16));
%         set(gca, 'XTicklabel', 0:20:300);
    figure();
    spectrogram(y_cur_lr_2(:,i),1000,500,freq_range,Fs,'yaxis');
%         xlim([0 300]);
%         Xlim = get(gca, 'xlim');
%         set(gca, 'XTick', linspace(Xlim(1), Xlim(2), 16));
%         set(gca, 'XTicklabel', 0:20:300);
    figure();
end



% idx1 = find(states_cur == train_params.state1);
% idx2 = find(states_cur == train_params.state2);
% 



data_st_left = data_cur(:,states_cur == 1);

data_left = data_cur(mask_left,:);

data_right = data_cur(mask_right,:);



y = data_cur';
y_left = data_left';
y_right = data_right';

xdft = fft(y,NFFT)/L;

xdft_left = fft(y_left,NFFT)/L;
xdft_right = fft(y_right,NFFT)/L;

f = Fs/2*linspace(0,1,NFFT/2+1);
% 
% for i = 1:length(chosen_left)
% 
% 
%     xdft_l = xdft_left(:,i);
%     disp('xdft_l');
%     disp(size(xdft_l));
% 
%     xdft_r = xdft_right(:,i);
%     figure();
%     dif = 2*abs(xdft_l(1:NFFT/2+1))-2*abs(xdft_r(1:NFFT/2+1));
%     plot(f,dif,'g');
%     xlim([0 50]);
% %     figure();
% %     plot(f,2*abs(xdft_r(1:NFFT/2+1)),'r');
% %     xlim([0 50]);
%     title([chosen_left(i),' - ',chosen_right(i)]);
% 
%     [b_high, a_high] = butter(5, 30/(2600), 'low');
%     dif_filt = filter(b_high, a_high, dif);
%     hold on;
%     plot(f,dif_filt,'m');
% 
%     
% end

% for i = 1:length(chosen_left)
%     figure();
%     freq_range = 1:0.01:30;
%     spectrogram(y_left(:,i),1000,500,freq_range,Fs,'yaxis');
%         xlim([0 300]);
%         Xlim = get(gca, 'xlim');
%         set(gca, 'XTick', linspace(Xlim(1), Xlim(2), 16));
%         set(gca, 'XTicklabel', 0:20:300);
%     figure();
%     spectrogram(y_right(:,i),1000,500,freq_range,Fs,'yaxis');
%         xlim([0 300]);
%         Xlim = get(gca, 'xlim');
%         set(gca, 'XTick', linspace(Xlim(1), Xlim(2), 16));
%         set(gca, 'XTicklabel', 0:20:300);
% 
%    
% end


res = 0.5;

freqband = 6:res:14;
d_1 = zeros(1,length(freqband));
d_2 = zeros(1,length(freqband));
d_3 = zeros(1,length(freqband));

step_f = 1;

for id = 1:length(freqband);

  
    freq = freqband(id);
    
    
    f0 = freq;
        p(1,:) = [f0-1.5,f0-0.5];
        p(3,:) = [f0+0.5,f0+1.5];
        p(2,:) = [f0-0.5,f0+0.5];
    
    for f = 1:3
        [b(f,:),a(f,:)] = butter(3,p(f,:)/(0.5*Fs));
        y_filt = filtfilt(b(f,:),a(f,:),y);
        C{f} = y_filt' * y_filt / size(y_filt',2);
        C{f} = C{f} + train_params.lambda * trace(C{f}) * eye(size(C{f})) / size(C{f},1);
    end;

%     disp(C{1});
%     disp(C{2});
%     disp(C{3});
    
    [V d] = eig(C{2},0.5*(C{1}+C{3}));
       
    
%     d = fdesign.bandpass('n,Fst1,Fp1,Fp2,Fst2',100,freq-2*step_f,freq-step_f,freq+step_f,freq+2*step_f,Fs);
%     hd = design(d);
% %    fvtool(hd);
% 
%     d2 = fdesign.bandpass('n,Fst1,Fp1,Fp2,Fst2',100,freq-3*step_f,freq-2*step_f,freq+2*step_f,freq+3*step_f,Fs);
%     hd2 = design(d2);
% %    fvtool(hd2);

%     y_filt = filter(hd,y);
%     y_filt2 = filter(hd2,y) - y_filt;
%     
%     data1_cur = y_filt';
%     data2_cur = y_filt2';
% 
%     C1 = data1_cur * data1_cur' / size(data1_cur,2);
%     C2 = data2_cur * data2_cur' / size(data2_cur,2);

%     nchan = size(C1,1);
%    C1 = C1 + train_params.lambda * trace(C1) * eye(nchan) / size(C1,1);
%    C2 = C2 + train_params.lambda * trace(C2) * eye(nchan) / size(C2,1);

%     [V d] = eig(C2,C1);

    d = diag(d);
%     plot(d);
%     hold on;
    
    d_1(id) = d(end);
    d_2(id) = d(1);

    d_3(id) = d(1)/d(end);
    
end
    
figure();
plot(freqband,d_1,'g');
hold on;
plot(freqband,d_2,'m');

plot(freqband,d_3,'r');

f_chosen = inputdlg('Choose the frequency');

params.params_spec.freq_bands{1} = [f_chosen{1} - step_f, f_chosen{1} + step_f];

% 

end