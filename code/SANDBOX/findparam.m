function [fmin,fmax,M,Minv,LDA_coeff,W12_final,Q12_final] = findparam(data,states,sample_idx_data,chan_names,st1,st2)

chan_names_chanlocs = chan_names;

EEGDummy = load_dataset('D:\bci\EXP_DATA\EXP_LSL32_new\short_32chan_2.set');


chanlocs = EEGDummy.chanlocs;
chan_idx_chanlocs = find_str_idx(lower({chanlocs.labels}), lower(chan_names_chanlocs));

chanlocs_vis = chanlocs(chan_idx_chanlocs);


% lambdas = 0.05:0.1:0.5;
% Fc_highs = 8 %2:3:11 %5:7;
% Bws = 20 %3:3:9 %5:6;

lambdas = 0.1:0.2:0.5;
Fc_highs = 2:2:15;
Bws = 3:3:9;

% sample_idx_data_cur = sample_idx_data(1:10:end);
sample_idx_data_f_aggr = zeros(size(sample_idx_data(1:10:end)));

Fs = 1000;
numpat = 3;
win = 300;
order = 5;

a_ma = 1;
b_ma = ones(1,win);

res_te = zeros(size(Fc_highs,2),size(Bws,2),size(lambdas,2));
res_te_sh = zeros(size(Fc_highs,2),size(Bws,2),size(lambdas,2));
                
for fh = 1:size(Fc_highs,2);
    
    Fc_high = Fc_highs(fh);
    disp(Fc_high);
    
    for fl = 1:size(Bws,2)
        Bw = Bws(fl);
        
        Fc_low = Fc_high+Bw;
        [z_high,p_high,k_high] = butter(order, Fc_high/(Fs/2), 'high');
        [b_high,a_high] = zp2tf(z_high,p_high,k_high);

        [z_low,p_low,k_low] = butter(order, Fc_low/(Fs/2), 'low');
        [b_low,a_low] = zp2tf(z_low,p_low,k_low);
        
        % filter
        data_cur_h = filter(b_high, a_high, data,[],2); % data is original untouched data
        data_cur_hl = filter(b_low, a_low, data_cur_h,[],2); 
        
        
        data_cur = resample(data_cur_hl',1,10)';
        states_cur = states(1:10:end);
        sample_idx_data_cur = sample_idx_data(1:10:end);
        
        
            for l = 1:size(lambdas,2) 

                lambda = lambdas(l);
                [correct_tr,correct_te,correct_tr_sh,correct_te_sh,sample_idx_data_f] = crossvallda(data_cur, states_cur, sample_idx_data_cur,st1,st2,lambda,numpat,win);
                sample_idx_data_f_aggr = sample_idx_data_f_aggr + sample_idx_data_f;
                %res_tr(fh,fl,l) = correct_tr; 
                res_te(fh,fl,l) = correct_te;
                res_te_sh(fh,fl,l) = correct_te_sh;
                disp(correct_tr);
                disp(correct_te);
                disp(correct_te_sh);
                
            end
            
    end
    
end

% best params for classify

[maxval,maxind] = max(res_te(:));
disp(maxval);

[i1,i2,i3,i4] = ind2sub(size(res_te),maxind);


% best params for shrinkage

[maxval,maxind] = max(res_te_sh(:));
disp(maxval);

[i1sh,i2sh,i3sh,i4sh] = ind2sub(size(res_te_sh),maxind);



fmin = Fc_highs(i1sh); % return value of fmin for shrinkage
fmax = Fc_highs(i1sh) + Bws(i2sh); % return value of fmax for shrinkage


% constructing the full shrinkage classifier based on the whole data

% filtering

Fc_high = fmin;
Fc_low = fmax;
[z_high,p_high,k_high] = butter(order, Fc_high/(Fs/2), 'high');
[b_high,a_high] = zp2tf(z_high,p_high,k_high);

[z_low,p_low,k_low] = butter(order, Fc_low/(Fs/2), 'low');
[b_low,a_low] = zp2tf(z_low,p_low,k_low);

% data_cur_h = filtfilt(b_high, a_high, data')'; % data is original untouched data
% data_cur_hl = filtfilt(b_low, a_low, data_cur_h')'; 

data_cur_h = filter(b_high, a_high, data,[],2); % data is original untouched data
data_cur_hl = filter(b_low, a_low, data_cur_h,[],2); 

% resampling

data_cur = resample(data_cur_hl',1,10)';
states_cur = states(1:10:end);

% training the classifier
indTr1 = find(states_cur == st1);
indTr2 = find(states_cur == st2);

Res = ClassifyPair(data_cur, indTr1,indTr2,lambda,300,2);
% ResultTest = TestPair(data_test, indTst1,indTst2,ResVsReg, 300,3);




% % % % % % % % old classifier % % % % % % % % % % 

% fmin = Fc_highs(i1); % return value of fmin
% fmax = Fc_highs(i1) + Bws(i2); % return value of fmax
% 
% Fc_high = fmin;
% Fc_low = fmax;
% [z_high,p_high,k_high] = butter(3, Fc_high/(Fs/2), 'high');
% [b_high,a_high] = zp2tf(z_high,p_high,k_high);
% 
% [z_low,p_low,k_low] = butter(3, Fc_low/(Fs/2), 'low');
% [b_low,a_low] = zp2tf(z_low,p_low,k_low);
% 
% % filter
% data_cur_h = filtfilt(b_high, a_high, data')'; % data is original untouched data
% data_cur_hl = filtfilt(b_low, a_low, data_cur_h')'; 
% 
% data_cur = resample(data_cur_hl',1,10)';
% states_cur = states(1:10:end);

% % % % % % % % % % % % % % % % % % % % % % % % % % 
        
        
% % % % % % % % draft of bad data exclusion feature % % % % % % % % % % 

        
%         sample_idx_data_f_aggr_u = sample_idx_data_f_aggr(sample_idx_data_f_aggr > 0);
%    
%         score_mean = mean(sample_idx_data_f_aggr_u);
%         score_std = std(sample_idx_data_f_aggr_u);
%         mask = (score_mean - sample_idx_data_f_aggr < 1.5*score_std);
%         idx = find(mask);
%         sample_idx_data_f_aggr_i = sample_idx_data_f_aggr(idx);
%         sample_idx_data_i = sample_idx_data(idx);
% 
%         length(idx);
%         
%         data_cur = data_cur(:,sample_idx_data_i);
%         states_cur = states_cur(sample_idx_data_i);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



        
% % % % % % CSP % % % % % % same for classify and shrinkage % % %

lambda = lambdas(i3sh); % exept of lambda here

data_1 = data_cur(:,states_cur == st1);
data_2 = data_cur(:,states_cur == st2);

C1 = data_1 * data_1' / size(data_1,2);
C2 = data_2 * data_2' / size(data_2,2);

nchan = size(C1,1);
C1 = C1 + lambda * trace(C1) * eye(nchan) / size(C1,1);
C2 = C2 + lambda * trace(C2) * eye(nchan) / size(C2,1);

[V d] = eig(C1,C2);

N = numpat; % numpat = 5 is hardcoded now

M = V(:, [1:N, end-N+1:end])';

Vinv = inv(V');
Minv = Vinv(:,[1:N, end-N+1:end]);
       
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %        

        
% % % % % % topographies ranking (should be optional) % % % % % % 

figure;
for i=1:2*N
    subplot(2,N,i);
    topoplot(Minv(:,i),chanlocs_vis);
%     topoplot(Minv(i,:),chanlocs_vis,'electrodes','labelpoint','chaninfo',EEGDummy.chaninfo);
    hold off;
end;

% str = inputdlg('Rank the patterns:');
% pat_order = str2num(char(str));
% 
% M = M(pat_order,:);
% Minv = Minv(:,pat_order);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% accuracy vs number of topographies in predefined order %
% also building classifiers %
    

A_tr_acc_sh = zeros(1,size(M,1));

for ntop = size(M,1):size(M,1)  %1:size(M,1) %%%%%%!!!!!!!!!!!!!!!!

    M_ntop = M(1:ntop,:);

    Y1 = M_ntop * data_1;
    Y2 = M_ntop * data_2;

    y_data = [Y1.^2, Y2.^2];
    y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];

      
    y_data = filter(b_ma, a_ma, y_data, [], 2);
% 
%     [C,err,P,logp,coeff{ntop}] = classify(y_data', y_data', y_states, 'linear');
%     A_tr_ntop(ntop) = 1-err;



% % % % % shrinkage classifier % % % % % 

    obj = train_shrinkage(y_data',y_states');
    W12 = obj.W;
    Q12 = W12'*y_data;
  
    ResultFinal{ntop}.W12 = W12;
%     ResultFinal{ntop}.M12 = M12;
%     ResultFinal{ntop}.G12 = G12;
    ResultFinal{ntop}.Q12 = Q12;
    ResultFinal{ntop}.Target = y_states;
    ResultFinal{ntop}.Input  = y_data;
           
    Target = (2-y_states);
    ResultFinal{ntop}.Acc = sum( (Q12>0) == Target )/length(y_states);
    
    A_tr_acc_sh(ntop) = ResultFinal{ntop}.Acc;
    
% % % % % % % % % % % % % % % % % % % % %
    

end

% figure;
% plot(A_tr_acc_sh);
% 
% str = inputdlg('How many patterns to use?');
% chosen_ntop = str2num(char(str));
% 
% M = M(1:chosen_ntop,:); %return value of M
% Minv = Minv(:,1:chosen_ntop); %return value of Minv

% LDA_coeff = coeff{pat_num};
LDA_coeff = 0; % dummy for consistency

chosen_ntop = size(M,1); %%%%%%!!!!!!!!!!!!!!!!

W12_final = ResultFinal{chosen_ntop}.W12; % return value of W12_final

Y_all = M * data_cur;



Y_all = Y_all.^2;

Y_all = filter(b_ma, a_ma, Y_all, [], 2);
    
    
Q12_final = W12_final'*Y_all; % return value of Q12_final
    
% Q12_final = ResultFinal{chosen_ntop}.Q12; % return value of Q12_final



end
