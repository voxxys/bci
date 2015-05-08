function [freqmin,freqmax,lambda,numpats] = findparam(data,states,sample_idx_data,st1,st2)

Fs = 1000;

fh = 1;
% for Fc_high = 2:15
for Fc_high = 7:8
    disp(Fc_high);
    fl = 1;
%     for Bw = 3:8
    for Bw = 3:4
        disp(Bw);
        Fc_low = Fc_high+Bw;
        [z_high,p_high,k_high] = butter(3, Fc_high/(Fs/2), 'high');
        [b_high,a_high] = zp2tf(z_high,p_high,k_high);

        [z_low,p_low,k_low] = butter(3, Fc_low/(Fs/2), 'low');
        [b_low,a_low] = zp2tf(z_low,p_low,k_low);
        
        % filter
        data_cur_h = filtfilt(b_high, a_high,data')'; 
        data_cur_hl = filtfilt(b_low, a_low,data_cur_h')'; 
        n = 1;
%         for numpat = 2:4
%             disp(numpat);
            l = 1;
            for lambda = 0.02:0.02:0.2
%             for lambda = 0.1:0.1:0.3
                
                disp(lambda);
                
                [correct_tr,correct_te] = crossvallda(data, states, sample_idx_data,st1,st2,lambda,numpat);
                res_tr(fh,fl,n,l) = correct_tr; 
                res_te(fh,fl,n,l) = correct_te; 
                disp(correct_tr);
                disp(correct_te);
                l = l + 1;
            end
            n = n + 1;
%         end
        fl = fl + 1;

    end
    fh = fh + 1;

    
end

for i = 1:12
freq{i} = [7,10]
end

save('freq.mat','freq')




end
