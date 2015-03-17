function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP


% Get data & states
[data, sample_idx_data] = buf_data.get_data();
[states, sample_idx_states] = buf_states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);

nsamples = size(data,2);

% Positions of all samples that belong to the one of given classes
pos_vec = find((states == train_params.state1) | (states == train_params.state2));

data = data(:,pos_vec);
states = states(pos_vec);

% Test
%data = data([1,6],:);

% Train LDA
% [C,err,P,logp,coeff] = classify(data', data', states, 'linear');
% fprintf('LDA error: %f\n', err);

data_1 = data(:,states == train_params.state1);
data_2 = data(:,states == train_params.state2);

y_1 = data_1';
y_2 = data_2';

C_1 = y_1' * y_1 / size(y_1',2);
C_2 = y_2' * y_2 / size(y_2',2);

Cm = zeros(size(C_1,1),size(C_1,2),2);

Cm(:,:,1) = C_1;
Cm(:,:,2) = C_2;

params.params_spec.cov_mat = Cm;

params.params_spec.state_labels = [train_params.state1, train_params.state2];

% Visualize prediction
if size(data,1) == 2

    % Split classes
    idx1 = find(states == train_params.state1);
    X1 = data(:,idx1);
    idx2 = find(states == train_params.state2);
    X2 = data(:,idx2);

    % Plot scatter
    figure(400); clf; hold on;
    plot(X1(1,:),X1(2,:),'b.'); plot(X2(1,:),X2(2,:),'r.')
    %plot(X1(1,:),X1(2,:),'b.'); plot(X2(1,:),X2(2,:),'r.')

    % Plot decision boundary
    C=coeff(1,2).const;
    L1=coeff(1,2).linear(1);
    L2=coeff(1,2).linear(2);
    x = [min(data(1,:)) max(data(1,:))];
    y = -(x*L1+C)/L2;
    plot(x,y,'k');

end


data_out = zeros(2, nsamples);


nprev = 10000;


cm_1 = C_1;
cm_2 = C_2;

idx_min = 0;

for n = 1:size(data_out,2)
    dat_chunk = data(:,(max(1,n - nprev)):n);

    data_cm = dat_chunk * dat_chunk' / size(dat_chunk,2);
    rd_1 = abs(RiemDist(data_cm,cm_1)); 
    rd_2 = abs(RiemDist(data_cm,cm_2));
    
    if(rd_1 == min(rd_1,rd_2))
        idx_min = 1;
    else
        idx_min = 2;
    end

%     [riem_min, idx_min] = min(rd_1,rd_2);
    
    data_out(1,n) = rd_2/rd_1;
    data_out(2,n) = params.params_spec.state_labels(idx_min);
end


states_pred = data_out(2,:);
pred_ok = mean(states == states_pred);

log_write('>>>>> Sign test: correct = %f\n', pred_ok);

end