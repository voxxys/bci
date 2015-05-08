function [freqmin,freqmax,lambda,numpats] = findparam(data,states,sample_idx_data,st1,st2)


Fs = 200;
h = 1;
l= 1;

Fchs = 5:15;
Bws = 3:8;
lambdas = 0.1:0.1:0.3;


fh = 1;
for Fc_high = Fchs
% for Fc_high = 7:8
    disp(Fc_high);
    fl = 1;
%     for Bw = 3:8
    for Bw = Bws
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
%             for lambda = 0.02:0.02:0.2
            for lambda = lambdas
                
                disp(lambda);
                
                [correct_tr,correct_te] = crossvallda(data_cur_hl, states, sample_idx_data,st1,st2,lambda);
                res_tr(fh,fl,l) = correct_tr; 
                res_te(fh,fl,l) = correct_te; 
%                 disp(correct_tr);
                disp(mean(correct_te));
                l = l + 1;
            end
            n = n + 1;
%         end
        fl = fl + 1;

    end
    fh = fh + 1;

    
end



Fc_high = Fchs(i);
Bw = Bws(j);
lambda = lambdas(k);

[correct_tr,correct_te, M, Minv] = crossvallda(data_cur_hl, states, sample_idx_data,st1,st2,lambda);


%        
nfilt = size(M,1);

figure; clf;
set(gcf, 'units', 'normalized', 'outerposition', [0 0.05 1 0.95]);





nx = 5;
ny = 2;


for m = 1 : nfilt

    V = Minv(:,m);

    subplot(ny,nx,m);
    topoplot(V, chanlocs_vis);

end


order = inputdlg('Patterns ranking:');
order_num = str2num(char(order));

Minv = Minv(:,order_num);

figure();
for m = 1 : nfilt

    V = Minv(:,1:m);
    V_plot = Minv(:,m);
    subplot(ny,nx,m);
    topoplot(V_plot, chanlocs_vis);
    
    M = V(:, [1:m, end-m+1:end])';
%     title(sprintf('%s  %s(%i)', strrep(this.name,'_','\_'), train_params.vis_type, m));

        Y1 = M * data_1;
        Y2 = M * data_2;

        Y1_test = M * data_1_test;
        Y2_test = M * data_2_test;


        y_data = [Y1.^2, Y2.^2];
        y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];

        y_data_test = [Y1_test.^2, Y2_test.^2];
        y_states_test = [ones(1,size(Y1_test,2)), 2*ones(1,size(Y2_test,2))];


        win = 500;%wins(s);        

        for k=1:size(y_data,1)
             y_data(k,:) = conv(y_data(k,:),ones(1,win),'same');
        end;

        for k=1:size(y_data_test,1)
             y_data_test(k,:) = conv(y_data_test(k,:),ones(1,win),'same');
        end;


        [C,err,P,logp,coeff] = classify(y_data_test', y_data', y_states, 'linear');
        A_tr(m) = 1-err;
        A_te(m) = sum(y_states_test == C')/size(y_states_test,2);
 
        
        
end



for t = 1:12
freq{t} = [7,10]
end

save('freq.mat','freq')




end
