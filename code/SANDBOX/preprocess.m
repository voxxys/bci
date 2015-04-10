function [data,states,sample_idx] = preprocess(exp_data,high,low,sds,step)

    data = exp_data.data.data;
    states = exp_data.states.data;
    sample_idx = exp_data.data.sample_idx;

    Fs = exp_data.data.srate;
%     L = size(data_ext,2);
%     NFFT = 2^nextpow2(L);

    Fc_low = low;
    Fc_high = high;

    %Wn =  Fc /(Fs/2)

    [z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
    [b_high,a_high] = zp2tf(z_high,p_high,k_high);
    data = filtfilt(b_high, a_high,data')'; 

    [z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
    [b_low,a_low] = zp2tf(z_low,p_low,k_low);
    data = filtfilt(b_low, a_low,data')'; 
    
    data = data(:,1:step:end);
    states = states(1:step:end);
    sample_idx = sample_idx(1:step:end);
    
    row_mean = mean(data,2);
    row_std = std(data,0,2);

    mask = (abs(data-row_mean(:,ones(1,size(data,2)))) < sds * row_std(:,ones(1,size(data,2))));

    idx = ~sum(~mask,1);

    idx = find(idx);

    disp(size(idx,2)/size(data,2));

    data = data(:,idx);
    states = states(idx);
    sample_idx = sample_idx(idx);


    % data_pwr = sqrt(sum((data_cur.^2),1));
    % 
    %  for n = 1 : 1
    %     Xmean = mean(data_pwr);
    %     Xstd = std(data_pwr);
    %     mask = (abs(data_pwr-Xmean) < sds * Xstd);
    %     mask = prod(double(mask),1);
    %     idx = find(mask);
    %     data_cur = data_cur(:,idx);
    %     states_cur = states_cur(idx);
    %     data_pwr = data_pwr(:,idx);
    %  end

end