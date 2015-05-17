function [correct_tr,correct_te,correct_tr_sh,correct_te_sh,sample_idx_f] = crossvallda(data_cur, states_cur, sample_idx,st1,st2,lambda,numpat,win)

        
    % classification accuracy for samples aggregator 
    sample_idx_f = zeros(size(sample_idx));
    

    sds = 2.3; % hardcoded, margin for removal of outliers in the current training sample
    
    
    % % % % % create the full set of testing/training parts combinations
    % % % % % for cv
    
    % find state change locations
    state_changes = find(diff(states_cur));
    kfold_delims = state_changes; 
    states_kfold_delims = states_cur(kfold_delims);
    kfold_delims = [0,kfold_delims];
    
    % find indices of samples in each part
    sample_idx_part = cell(1,size(kfold_delims,2)-1);
    for i = 1:(size(kfold_delims,2)-1)
       part_idx = (kfold_delims(i)+1):kfold_delims(i+1);
       sample_idx_part{i} = sample_idx(part_idx);
    end
    
    % find parts corresponding to the two current states
    parts_1 = find(states_kfold_delims == st1);
    parts_2 = find(states_kfold_delims == st2);

    % create the set
    sets = {parts_1, parts_2};
    [x, y] = ndgrid(sets{:});
    parts_for_testing = [x(:) y(:)]; % set of parts fot testing
    nums = [parts_1, parts_2]; % vector of all parts

    
    % iterate over parts for testing
    for i = 1:size(parts_for_testing,1)
        
        % training on all parts except the parts for testing
        
        parts_for_training = setdiff(nums,parts_for_testing(i,:));

        train_idx = horzcat(sample_idx_part{parts_for_training});   
        test_idx = horzcat(sample_idx_part{parts_for_testing(i,:)});

        train_mask = ismember(sample_idx,train_idx);
        test_mask = ismember(sample_idx,test_idx);

        data_train = data_cur(:,train_mask);
        states_train = states_cur(train_mask);
        
        % removing outliers
        
        row_mean = mean(data_train,2);
        row_std = std(data_train,0,2);

        mask = (abs(data_train-row_mean(:,ones(1,size(data_train,2)))) < sds * row_std(:,ones(1,size(data_train,2))));

        idxs = ~sum(~mask,1);

        idxs = find(idxs);

    %     disp(size(idx,2)/size(data,2)); % how much data is left?

        data_train = data_train(:,idxs);
        states_train = states_train(idxs);
 
        
        % testing data goes as it is
        data_test = data_cur(:,test_mask);
        states_test = states_cur(test_mask);
        
        
        % find indices for both states in training and testing data to use
        % ClassifyPair function

        indTr1 = find(states_train == st1);
        indTr2 = find(states_train == st2);
        indTst1 = find(states_test == st1);
        indTst2 = find(states_test == st2);
        
        ResVsReg = ClassifyPair(data_train, indTr1,indTr2,lambda,win,numpat);
        ResultTest = TestPair(data_test, indTst1,indTst2,ResVsReg,win,numpat);
        
        % save accuracy to later average over parts for testing
        tr_acc(i) = ResVsReg.Acc;
        te_acc(i) = ResultTest.Acc;
        
 
% % % % % % % % % % % % % % % old classifier % % % % % % % % % % % % % % %         
%
% 
%         data_1 = data_train(:,states_train == st1);
%         data_2 = data_train(:,states_train == st2);
% 
%         data_1_test = data_test(:,states_test == st1);
%         data_2_test = data_test(:,states_test == st2);
%         
%         
%         C1 = data_1 * data_1' / size(data_1,2);
%         C2 = data_2 * data_2' / size(data_2,2);
% 
%         nchan = size(C1,1);
%         C1 = C1 + lambda * trace(C1) * eye(nchan) / size(C1,1);
%         C2 = C2 + lambda * trace(C2) * eye(nchan) / size(C2,1);
% 
%         [V d] = eig(C1,C2);
% 
%         N = numpat;
%         M = V(:, [1:N, end-N+1:end])';
% 
%         Y1 = M * data_1;
%         Y2 = M * data_2;
% 
%         Y1_test = M * data_1_test;
%         Y2_test = M * data_2_test;
% 
% 
%         y_data = [Y1.^2, Y2.^2];
%         y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];
% 
%         y_data_test = [Y1_test.^2, Y2_test.^2];
%         y_states_test = [ones(1,size(Y1_test,2)), 2*ones(1,size(Y2_test,2))];
% 
%         for k=1:size(y_data,1)
%              y_data(k,:) = conv(y_data(k,:),ones(1,win),'same')/win;
%         end;
% 
%         for k=1:size(y_data_test,1)
%              y_data_test(k,:) = conv(y_data_test(k,:),ones(1,win),'same')/win;
%         end;
% 
% 
%         [C,err,P,logp,coeff] = classify(y_data_test', y_data', y_states, 'linear');
%         A_tr(i) = 1-err;
%         A_te(i) = sum(y_states_test == C')/size(y_states_test,2);
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
               
    end
    
    % add accuracy over each fragment to the corresponding indices in sample_idx_data_f
    for i = 1:size(parts_for_testing,1)
        test_idx = horzcat(sample_idx_part{parts_for_testing(i,:)});
        test_idx_s_d = ismember(sample_idx,test_idx);
        sample_idx_f(test_idx_s_d) = sample_idx_f(test_idx_s_d)+te_acc(i); % +A_te(i);    
    end
    
    % dummy values still returned for consistency
    correct_tr = 0; %mean(A_tr);
    correct_te = 0; %mean(A_te);
    
    % return shrinkage accuracy values
    correct_tr_sh = mean(tr_acc);
    correct_te_sh = mean(te_acc);

end