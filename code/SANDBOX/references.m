clear
clc

int_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_6states_2204_imag_2.mat');

ext_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_6states_2204_imag_.mat');

%%

M = generatelaplace();


%%

[data_cur,states_cur,sample_idx] = preprocess(int_data,8,30,200,1);

[data_ext,states_ext,sample_idx_ext] = preprocess(ext_data,8,30,200,1);



%%
% 
% 
% int_data.data.data = M * int_data.data.data;
% ext_data.data.data = M * ext_data.data.data;

%%

data_cur = M * data_cur;
data_ext = M * data_ext;


%%

% ch1020lap = [4, 5, 6, 15, 16, 17, 26, 27, 28];

%%

ch32lap = [4, 5, 6, 9, 10, 11, 12, 15, 16, 17, 20, 21, 22, 23, 26, 27, 28];
%%

data_cur = data_cur(ch32lap,:);
data_ext = data_ext(ch32lap,:);
%%

int_data.data.data = data_cur;
ext_data.data.data = data_ext;

%%

[data_cur,states_cur,sample_idx] = preprocess(int_data,8,30,2.3,1);

[data_ext,states_ext,sample_idx_ext] = preprocess(ext_data,8,30,200,1);


%%
% 
% ch1020 = [1, 2, 3, 4, 5, 6, 7, 14, 15, 16, 17, 18, 25, 26, 27, 28, 29, 30, 32];



%%

% numch = size(data_cur,1);
% 
% M = eye(numch) - 1/numch;
% 
% data_cur = M*data_cur;

%%
% 
% data_ext = M*data_ext;

%%

for i = 1:6
    
    data_state{i} = data_cur(:,states_cur == i);
end

for i = 1:6
    
    data_state_test{i} = data_ext(:,states_cur == i);
end



%%

A_te = zeros(1,6);
A_tr = zeros(1,6);


rbfs2 = 2;
stateset = [1,2,3,4,5,6];

for i = 1:6

    data_1 = data_state{i};
    stateset_i = stateset(stateset ~= i);

    data_2 = horzcat(data_state{stateset_i(1)},data_state{stateset_i(2)},data_state{stateset_i(3)},data_state{stateset_i(4)},data_state{stateset_i(5)});

    data_1_test = data_state_test{i};
    data_2_test = horzcat(data_state_test{stateset_i(1)},data_state_test{stateset_i(2)},data_state_test{stateset_i(3)},data_state_test{stateset_i(4)},data_state_test{stateset_i(5)});

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
    
%     svmStruct = svmtrain(y_data', y_states,'kernel_function','quadratic','kktviolationlevel',0.05);
    svmStruct = svmtrain(y_data', y_states,'kernel_function','rbf', 'rbf_sigma', rbfs2,'kktviolationlevel',0.1);
    species = svmclassify(svmStruct,y_data_test');  
%     A_te_svm(i) = sum(y_states_test == species')/size(y_states_test,2);

    disp(i);
    
    
end


