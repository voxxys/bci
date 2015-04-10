clear
clc

int_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_2603_first_real_T20.mat');


ext_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_2603_first_real_T20_2.mat');
[data_ext,states_ext,sample_idx_ext] = preprocess(ext_data,11,20,10,1);

st1 = 2;
st2 = 6;

sdss = 2.2:0.2:4;
wins = 50:50:500;

sds = 2.5;



% for s = 1:10


    %rb = 0.5:0.5:5;
    s = 2;
    sdss = 2.2:0.2:4;
    % wins = 50:50:500;

    [data_cur,states_cur,sample_idx] = preprocess(int_data,11,20,sdss(s),2);

    state_changes = find(diff(states_cur));
    kfold_delims = [state_changes, floor(state_changes(1)/2), state_changes(1:(end-1))+floor(diff(state_changes)/2)];
    kfold_delims = sort(kfold_delims);

    states_kfold_delims = states_cur(kfold_delims);

    kfold_delims = [0,kfold_delims];

    for i = 1:24
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

        data_test = data_cur(:,test_mask);
        states_test = states_cur(test_mask);


        data_1 = data_train(:,states_train == st1);
        data_2 = data_train(:,states_train == st2);

        data_1_test = data_test(:,states_test == st1);
        data_2_test = data_test(:,states_test == st2);

        
        % % % TODO: test with external data

    %     data_test_ext = 
    %     states_test_ext = 


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

        
        y_data_var = zeros(size(y_data));
        for t = 1:size(y_data,2)
            
            y_data_chunk = y_data(:,max(1,t-win+1):t);
            
            y_data_var(:,t) = var(y_data_chunk,[],2);
        
        end
        
        y_data_test_var = zeros(size(y_data_test));
        for t = 1:size(y_data_test,2)
            
            y_data_test_chunk = y_data(:,max(1,t-win+1):t);
            
            y_data_test_var(:,t) = var(y_data_test_chunk,[],2);
        
        end


        [C,err,P,logp,coeff] = classify(y_data_test', y_data', y_states, 'linear');
        A_tr(i) = 1-err;
        A_te(i) = sum(y_states_test == C')/size(y_states_test,2);

        disp(i);

%         svmfit = svmtrain(y_data', y_states,'kernel_function','rbf','rbf_sigma',10);%,'kktviolationlevel',0.05);
%         species = svmclassify(svmfit,y_data_test');
%         A_te_svm(i) = sum(y_states_test == species')/size(y_states_test,2);
%         A_te_svm(i)

%         svmStruct = svmtrain(y_data', y_states,'kernel_function','quadratic','kktviolationlevel',0.05);
%         svmStruct = svmtrain(y_data', y_states,'kernel_function','rbf', 'rbf_sigma', rbfs2,'kktviolationlevel',0.1);
%         species = svmclassify(svmStruct,y_data_test');  
%         A_te_svm(s,i) = sum(y_states_test == species')/size(y_states_test,2);

    
    end
% end


%%

figure
imagesc(A_tr)
colorbar

figure
imagesc(A_te)
colorbar

%%
res = zeros(1,size(y_data_test,2));
dist1 = zeros(1,size(y_data_test,2));
dist2 = zeros(1,size(y_data_test,2));

for i = 1:size(y_data_test,2)
    
    dist1(i) = sum(abs(y_data_test_var(:,i)-y_data_1_var).^2);
    dist2(i) = sum(abs(y_data_test_var(:,i)-y_data_2_var).^2);
    
    res(i) = (dist1(i) > dist2(i)) + 1;
    
end

%%

da = y_data
[coeff,score] = pca(y_data_test_var');
scatter(score(y_states_test == 1,1),score(y_states_test == 1,2))
hold on
scatter(score(y_states_test == 2,1),score(y_states_test == 2,2),'g')



%%
    svmfit = svmtrain(y_data_var', y_states,'kktviolationlevel',0.05);
    species = svmclassify(svmfit,y_data_test_var');
    A_te_svm(i) = sum(y_states_test == species')/size(y_states_test,2);
    A_te_svm(i)

    svmStruct = svmtrain(y_data', y_states,'kernel_function','quadratic','kktviolationlevel',0.05);
    svmStruct = svmtrain(y_data', y_states,'kernel_function','rbf', 'rbf_sigma', rbfs2,'kktviolationlevel',0.1);
    species = svmclassify(svmStruct,y_data_test');  
    A_te_svm(s,i) = sum(y_states_test == species')/size(y_states_test,2);
