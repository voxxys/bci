function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP
% train_params.lambda - regularization coefficient for covariance matrices

load(sprintf('CSP_mat_%i_%i', train_params.state1, train_params.state2));



[data, sample_idx_data] = buf_data.get_data();
[states, sample_idx_states] = buf_states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);


data_cur = data;


sds = 3.5;

    row_mean = mean(data_cur,2);
    row_std = std(data_cur,0,2);

    mask = (abs(data_cur-row_mean(:,ones(1,size(data_cur,2)))) < sds * row_std(:,ones(1,size(data_cur,2))));

    idx = ~sum(~mask,1);

    idx = find(idx);

    data_cur = data_cur(:,idx);
    states_cur = states(idx);


idx1 = find(states_cur == train_params.state1);
idx2 = find(states_cur == train_params.state2);

% Data used for current filter set
data1_cur = data_cur(:,idx1);
data2_cur = data_cur(:,idx2);


% Store filter matrix for given number of components

params.params_spec.M = M_N;

params.params_spec.Minv = Minv_N;

N = size(M_N,1)/2;

% Names of filters
params.params_spec.filt_names =...
    arrayfun(@(x)sprintf('%s_%i', train_params.filtnames_base, x), [1:2*N], 'UniformOutput', false);

% Visualize filters/patterns
if ~strcmp(train_params.vis_type, 'none')
    this.visualize(data1_cur, data2_cur, params, train_params);
end


end