function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP


% Get data & states
[data, sample_idx_data] = buf_data.get_data();
[states, sample_idx_states] = buf_states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);

% Positions of all samples that belong to the one of given classes
pos_vec = find((states == train_params.state1) | (states == train_params.state2));

data = data(:,pos_vec);
states = states(pos_vec);

% Test
%data = data([1,6],:);

% Train LDA
[C,err,P,logp,coeff] = classify(data', data', states, 'linear');
fprintf('LDA error: %f\n', err);

params.params_spec.LDA_coeffs = coeff;
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

% Check sign
D = sum(bsxfun(@times, data, params.params_spec.LDA_coeffs(1,2).linear)) + params.params_spec.LDA_coeffs(1,2).const;
states_pred = (D < 0) + 1;
pred_ok = mean(states == states_pred);

log_write('>>>>> Sign test: correct = %f\n', pred_ok);

end