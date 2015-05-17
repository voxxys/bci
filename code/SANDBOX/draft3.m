%generate secondary feature set

D = size(RESULT{1,2}.M12,1);
rangeQQY = 1:D;
ij = 1;
for si=1:length(STATES)
    for sj=1:length(STATES)
 
        if(si==sj) continue; end;
        
        Fc_high = RESULT{si,sj}.Fc_high;
        Fc_low  = RESULT{si,sj}.Fc_low;
        [z_high,p_high,k_high] = butter(3, Fc_high/(Fs/2), 'high');
        [b_high,a_high] = zp2tf(z_high,p_high,k_high);
        [z_low,p_low,k_low] = butter(3, Fc_low/(Fs/2), 'low');
        [b_low,a_low] = zp2tf(z_low,p_low,k_low);

        % filter
        data_cur_h = filtfilt(b_high, a_high,data_cur0')'; 
        data_cur_hl = filtfilt(b_low, a_low,data_cur_h')'; 

        data_cur = data_cur_hl(:,1:2:end);
        states_cur = states_cur0(:,1:2:end);
        M = RESULT{si,sj}.M12;
        W = RESULT{si,sj}.W12;
        Y = M*data_cur;
        for k=1:size(Y,1)
           Yc(k,:) = conv(Y(k,:).^2,ones(1,300),'same');
        end;
        QQ(ij,:) = W'*Yc;
        QQY(rangeQQY,:) = Yc;
        rangeQQY = rangeQQY+D;
        ij = ij+1;
    end;
end;

