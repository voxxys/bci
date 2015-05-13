function [fmin,fmax,M,Minv,LDA_coeff] = findparam(data,states,sample_idx_data,chan_names,st1,st2)

chan_names_chanlocs = chan_names;

EEGDummy = load_dataset('D:\bci\EXP_DATA\EXP_LSL32_new\short_32chan_2.set');


chanlocs = EEGDummy.chanlocs;
chan_idx_chanlocs = find_str_idx(lower({chanlocs.labels}), lower(chan_names_chanlocs));

chanlocs_vis = chanlocs(chan_idx_chanlocs);


% lambdas = 0.05:0.1:0.5;
% Fc_highs = 8 %2:3:11 %5:7;
% Bws = 20 %3:3:9 %5:6;

lambdas = 0.05:0.1:0.5;
Fc_highs = 2:2:11;
Bws = 3:2:8;

% sample_idx_data_cur = sample_idx_data(1:10:end);
sample_idx_data_f_aggr = zeros(size(sample_idx_data(1:10:end)));

Fs = 1000;
numpat = 5;

res_te = zeros(size(Fc_highs,2),size(Bws,2),size(lambdas,2));
                
for fh = 1:size(Fc_highs,2);
    
    Fc_high = Fc_highs(fh);
    disp(Fc_high);
    
    for fl = 1:size(Bws,2)
        Bw = Bws(fl);
        
        Fc_low = Fc_high+Bw;
        [z_high,p_high,k_high] = butter(3, Fc_high/(Fs/2), 'high');
        [b_high,a_high] = zp2tf(z_high,p_high,k_high);

        [z_low,p_low,k_low] = butter(3, Fc_low/(Fs/2), 'low');
        [b_low,a_low] = zp2tf(z_low,p_low,k_low);
        
        % filter
        data_cur_h = filtfilt(b_high, a_high, data')'; % data is original untouched data
        data_cur_hl = filtfilt(b_low, a_low, data_cur_h')'; 
        
        data_cur = resample(data_cur_hl',1,10)';
        states_cur = states(1:10:end);
        sample_idx_data_cur = sample_idx_data(1:10:end);
        
        
            for l = 1:size(lambdas,2) 

                lambda = lambdas(l);
                [correct_tr,correct_te,sample_idx_data_f] = crossvallda(data_cur, states_cur, sample_idx_data_cur,st1,st2,lambda,numpat);
                sample_idx_data_f_aggr = sample_idx_data_f_aggr + sample_idx_data_f;
                %res_tr(fh,fl,l) = correct_tr; 
                res_te(fh,fl,l) = correct_te; 
                disp(correct_tr);
                disp(correct_te);
                
            end
            
    end
    
end

[maxval,maxind] = max(res_te(:));
disp(maxval);

[i1,i2,i3,i4] = ind2sub(size(res_te),maxind);

fmin = Fc_highs(i1); % return value of fmin
fmax = Fc_highs(i1) + Bws(i2); % return value of fmax



        Fc_high = fmin;
        Fc_low = fmax;
        [z_high,p_high,k_high] = butter(3, Fc_high/(Fs/2), 'high');
        [b_high,a_high] = zp2tf(z_high,p_high,k_high);

        [z_low,p_low,k_low] = butter(3, Fc_low/(Fs/2), 'low');
        [b_low,a_low] = zp2tf(z_low,p_low,k_low);
        
        % filter
        data_cur_h = filtfilt(b_high, a_high, data')'; % data is original untouched data
        data_cur_hl = filtfilt(b_low, a_low, data_cur_h')'; 
        
        data_cur = resample(data_cur_hl',1,10)';
        states_cur = states(1:10:end);
        
        
        
        sample_idx_data_f_aggr_u = sample_idx_data_f_aggr(sample_idx_data_f_aggr > 0);
   
        score_mean = mean(sample_idx_data_f_aggr_u);
        score_std = std(sample_idx_data_f_aggr_u);
        mask = (score_mean - sample_idx_data_f_aggr < 0.5*score_std);
        idx = find(mask);
        sample_idx_data_f_aggr_i = sample_idx_data_f_aggr(idx);
        sample_idx_data_i = sample_idx_data(idx);

        length(idx);
        
        data_cur = data_cur(:,sample_idx_data_i);
        states_cur = states_cur(sample_idx_data_i);
        
% to find M

        lambda = lambdas(i3);

        data_1 = data_cur(:,states_cur == st1);
        data_2 = data_cur(:,states_cur == st2);

        C1 = data_1 * data_1' / size(data_1,2);
        C2 = data_2 * data_2' / size(data_2,2);

        nchan = size(C1,1);
        C1 = C1 + lambda * trace(C1) * eye(nchan) / size(C1,1);
        C2 = C2 + lambda * trace(C2) * eye(nchan) / size(C2,1);

        [V d] = eig(C1,C2);

        N = numpat;
        M = V(:, [1:N, end-N+1:end])';

        Vinv = inv(V');
        Minv = Vinv(:,[1:N, end-N+1:end]);
       
        

        


% to chose topographies
      


figure;
for i=1:2*N
    subplot(2,N,i);
    topoplot(Minv(:,i),chanlocs_vis);
%     topoplot(Minv(i,:),chanlocs_vis,'electrodes','labelpoint','chaninfo',EEGDummy.chaninfo);
    hold off;
end;

str = inputdlg('Rank the patterns:');
pat_order = str2num(char(str));

M = M(pat_order,:);
Minv = Minv(:,pat_order);



% figure;
% for i=1:2*N
%     subplot(2,N,i);
%     topoplot(Minv(:,i),chanlocs_vis);
% %     topoplot(Minv(i,:),chanlocs_vis,'electrodes','labelpoint','chaninfo',EEGDummy.chaninfo);
%     hold off;
% end;



    
    for ntop = 1:size(M,1)
        
        M_ntop = M(1:ntop,:);

        Y1 = M_ntop * data_1;
        Y2 = M_ntop * data_2;

        y_data = [Y1.^2, Y2.^2];
        y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];
        
        win = 100;     

        for k=1:size(y_data,1)
             y_data(k,:) = conv(y_data(k,:),ones(1,win),'same');
        end;

        [C,err,P,logp,coeff{ntop}] = classify(y_data', y_data', y_states, 'linear');
        A_tr_ntop(ntop) = 1-err;
        

    end

figure;
plot(A_tr_ntop);

str = inputdlg('How many patterns to use?');
pat_num = str2num(char(str));


M = M(1:pat_num,:); %return value of M
Minv = Minv(:,1:pat_num); %return value of Minv

LDA_coeff = coeff{pat_num};



end
