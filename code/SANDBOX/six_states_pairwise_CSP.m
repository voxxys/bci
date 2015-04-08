clear
clc

load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_2603_first_real_T20.mat')

st1 = 5;
st2 = 6;

% for s = 1:10

sdss = 2.2:0.2:4;
wins = 50:50:500;
data_cur = data.data;
states_cur = states.data;
sample_idx = data.sample_idx;


Fs = 1000;
L = size(data_cur,2);
NFFT = 2^nextpow2(L);

Fc_low = 20;
Fc_high = 11;

%Wn =  Fc /(Fs/2)

[z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
[b_high,a_high] = zp2tf(z_high,p_high,k_high);
data_cur = filtfilt(b_high, a_high,data_cur')'; 

[z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
[b_low,a_low] = zp2tf(z_low,p_low,k_low);
data_cur = filtfilt(b_low, a_low,data_cur')'; 


data_cur = data_cur(:,1:2:end);
states_cur = states_cur(1:2:end);
sample_idx = sample_idx(1:2:end);

sds = 2.5;


row_mean = mean(data_cur,2);
row_std = std(data_cur,0,2);

mask = (abs(data_cur-row_mean(:,ones(1,size(data_cur,2)))) < sds * row_std(:,ones(1,size(data_cur,2))));

idx = ~sum(~mask,1);

idx = find(idx);
data_cur = data_cur(:,idx);
states_cur = states_cur(idx);
sample_idx = sample_idx(idx);

% 
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

for i = 1:6
    data_state{i} = data_cur(:,states_cur == i);
end


state_changes = find(diff(states_cur));
kfold_delims = [state_changes, floor(state_changes(1)/2), state_changes(1:(end-1))+floor(diff(state_changes)/2)];
kfold_delims = sort(kfold_delims);

states_kfold_delims = states_cur(kfold_delims);

kfold_delims = [0,kfold_delims];

for i = 1:24
   part_idx = (kfold_delims(i)+1):kfold_delims(i+1);
   data_part{i} = data_cur(:,part_idx);
   states_part{i} = states_cur(part_idx);
   sample_idx_part{i} = sample_idx(part_idx);
end

parts_1 = find(states_kfold_delims == st1);
parts_2 = find(states_kfold_delims == st2);

sets = {parts_1, parts_2};
[x, y] = ndgrid(sets{:});
cartProd = [x(:) y(:)];

nums = [parts_1, parts_2];

for i = 1:size(cartProd,1)
    on = setdiff(nums,cartProd(i,:));
    
    train_idx = horzcat(sample_idx_part{on});   
    test_idx = horzcat(sample_idx_part{cartProd(i,:)});
    
    train_mask = ismember(sample_idx,train_idx);
    test_mask = ismember(sample_idx,test_idx);
    
    data_train = data_cur(:,train_mask);
    states_train = states_cur(train_mask);
   
    data_test = data_cur(:,test_mask);
    states_test = states_cur(test_mask);
    
         
    data_1 = data_train(:,states_train == st1);
    data_2 = data_train(:,states_train == st2);
    
    data_1_test = data_test(:,states_test == st1);
    data_2_test = data_test(:,states_test == st2);
    
    C1 = data_1 * data_1' / size(data_1,2);
    C2 = data_2 * data_2' / size(data_2,2);

    nchan = size(C1,1);
    C1 = C1 + 0.05 * trace(C1) * eye(nchan) / size(C1,1);
    C2 = C2 + 0.05 * trace(C2) * eye(nchan) / size(C2,1);

        [V d] = eig(C1,C2);
        
        M = V(:,[1:4, (end-3):end])';

        Y1 = M * data_1;
        Y2 = M * data_2;
        
        Y1_test = M * data_1_test;
        Y2_test = M * data_2_test;
%         
%     
%         figure;
%         hold on;
%         plot(Y1(1,:), Y1(end,:), 'b.');
%         plot(Y2(1,:), Y2(end,:), 'r.');
%         legend(['State ', num2str(i)],['State ', num2str(j)]);
%         xlabel('CSP\_1');
%         ylabel('CSP\_end');
%         title([num2str(i), ', ', num2str(j)]);
% 
%         
%         figure;
%         hold on;
%         plot(Y1_test(1,:), Y1_test(end,:), 'b.');
%         plot(Y2_test(1,:), Y2_test(end,:), 'r.');
%         legend(['State ', num2str(i)],['State ', num2str(j)]);
%         xlabel('CSP\_1');
%         ylabel('CSP\_end');
%         title([num2str(i), ', ', num2str(j)]);
        
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
        A_tr(i) = 1-err;
        A_te(i) = sum(y_states_test == C')/size(y_states_test,2);
        
        disp(i);
        
        A_te(i)
        
        svmfit = svmtrain(y_data', y_states,'kernel_function','rbf','rbf_sigma',10);%,'kktviolationlevel',0.05);
        species = svmclassify(svmfit,y_data_test');
        A_te_svm(i) = sum(y_states_test == species')/size(y_states_test,2);
        A_te_svm(i)
    
end

% figure;
% plot(A_tr);
% 
% figure;
% plot(A_te);

% end

%%

figure
imagesc(A_tr)
colorbar

figure
imagesc(A_te)
colorbar




%%
for i = 1:6
    for j = 1:6
        disp(i);
        disp(j);

        
        data_1 = data_state{i};
        data_2 = data_state{j};
        C1 = data_1 * data_1' / size(data_1,2);
        C2 = data_2 * data_2' / size(data_2,2);

        nchan = size(C1,1);
        C1 = C1 + 0.05 * trace(C1) * eye(nchan) / size(C1,1);
        C2 = C2 + 0.05 * trace(C2) * eye(nchan) / size(C2,1);

        [V d] = eig(C1,C2);
        
        M = V(:,[1:4, end-3:end])';

        Y1 = M * data_1;
        Y2 = M * data_2;
       
%         figure;
%         hold on;
%         plot(Y1(1,:), Y1(end,:), 'b.');
%         plot(Y2(1,:), Y2(end,:), 'r.');
%         legend(['State ', num2str(i)],['State ', num2str(j)]);
%         xlabel('CSP\_1');
%         ylabel('CSP\_end');
%         title([num2str(i), ', ', num2str(j)]);
        
        y_data = [Y1.^2, Y2.^2];
        y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];
        
        for k=1:size(y_data,1)
             y_data(k,:) = conv(y_data(k,:),ones(1,50),'same');
        end;
         
        [C,err,P,logp,coeff] = classify(y_data', y_data', y_states, 'linear');
        A(i,j) = 1-err;
        fprintf('LDA error: %f\n', err);

%         D = sum(bsxfun(@times, y_data, coeff(1,2).linear)) + coeff(1,2).const;
%         states_pred = (D < 0) + 1;
%         pred_ok = mean(y_states == states_pred);
% 
%         fprintf('Sign test: correct = %f\n', pred_ok);
    end
end

figure
imagesc(A)
colorbar
title('pairwise accuracy')
