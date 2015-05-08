function [correct_tr,correct_te] = crossvallda(data, states, sample_idx_data,st1,st2,lambda,numpat)

    sample_idx = sample_idx_data;
    states_cur = states;
    data_cur = data;
    
    
    sds = 2.3;
    
    
    state_changes = find(diff(states_cur));

    kfold_delims = state_changes;
    
    states_kfold_delims = states_cur(kfold_delims);

    kfold_delims = [0,kfold_delims];

    for i = 1:(size(kfold_delims,2)-1)
       part_idx = (kfold_delims(i)+1):kfold_delims(i+1);
       sample_idx_part{i} = sample_idx(part_idx);
    end
    
    parts_1 = find(states_kfold_delims == st1);
    parts_2 = find(states_kfold_delims == st2);

    sets = {parts_1, parts_2};
    [x, y] = ndgrid(sets{:});
    parts_for_testing = [x(:) y(:)];

    nums = [parts_1, parts_2];

    
    for i = 1:size(parts_for_testing,1)
        
        parts_for_training = setdiff(nums,parts_for_testing(i,:));

        train_idx = horzcat(sample_idx_part{parts_for_training});   
        test_idx = horzcat(sample_idx_part{parts_for_testing(i,:)});

        train_mask = ismember(sample_idx,train_idx);
        test_mask = ismember(sample_idx,test_idx);

        data_train = data_cur(:,train_mask);
        states_train = states_cur(train_mask);
        
        
        
        
        row_mean = mean(data_train,2);
        row_std = std(data_train,0,2);

        mask = (abs(data_train-row_mean(:,ones(1,size(data_train,2)))) < sds * row_std(:,ones(1,size(data_train,2))));

        idxs = ~sum(~mask,1);

        idxs = find(idxs);

    %     disp(size(idx,2)/size(data,2));

        data_train = data_train(:,idxs);
        states_train = states_train(idxs);
  
    
    
    

        data_test = data_cur(:,test_mask);
        states_test = states_cur(test_mask);


        data_1 = data_train(:,states_train == st1);
        data_2 = data_train(:,states_train == st2);

        data_1_test = data_test(:,states_test == st1);
        data_2_test = data_test(:,states_test == st2);

        
        C1 = data_1 * data_1' / size(data_1,2);
        C2 = data_2 * data_2' / size(data_2,2);

        nchan = size(C1,1);
        C1 = C1 + lambda * trace(C1) * eye(nchan) / size(C1,1);
        C2 = C2 + lambda * trace(C2) * eye(nchan) / size(C2,1);

        [V d] = eig(C1,C2);

        N = numpat;
        M = V(:, [1:N, end-N+1:end])';
        
        
        

       
nfilt = size(M,1);

figure; clf;
set(gcf, 'units', 'normalized', 'outerposition', [0 0.05 1 0.95]);

% Visualize filters or patterns
for m = 1 : nfilt

    % What to visualize
    if vis_patterns
        V = Minv(:,m);
    else
        V = M(m,:);
    end

    % Channel locations
    chan_idx_chanlocs = find_str_idx(lower({chanlocs.labels}), lower(train_params.chan_names_chanlocs));
    chanlocs_vis = chanlocs(chan_idx_chanlocs);

    % Visualization
    subplot(ny,nx,m);
    topoplot(V, chanlocs_vis);
    title(sprintf('%s  %s(%i)', strrep(this.name,'_','\_'), train_params.vis_type, m));

end

        Y1 = M * data_1;
        Y2 = M * data_2;

        Y1_test = M * data_1_test;
        Y2_test = M * data_2_test;


        y_data = [Y1.^2, Y2.^2];
        y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];

        y_data_test = [Y1_test.^2, Y2_test.^2];
        y_states_test = [ones(1,size(Y1_test,2)), 2*ones(1,size(Y2_test,2))];


                
        y_data_1_var = var(y_data(:,y_states == 1),[],2);
        y_data_2_var = var(y_data(:,y_states == 2),[],2);
        
        
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

        
    end
    
    correct_tr = mean(A_tr);
    correct_te = mean(A_te);


end