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



load('LDA_coeffs.mat');

i = params.numi;

params.params_spec.LDA_coeffs = LDA_coeffs{i};

params.params_spec.state_labels = [train_params.state1, train_params.state2];


% Check sign
D = sum(bsxfun(@times, data, params.params_spec.LDA_coeffs(1,2).linear)) + params.params_spec.LDA_coeffs(1,2).const;
states_pred_idx = (D < 0) + 1;
states_pred = params.params_spec.state_labels(states_pred_idx);
pred_ok = mean(states == states_pred);

log_write('>>>>> Sign test: correct = %f\n', pred_ok);

end