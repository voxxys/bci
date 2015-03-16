function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP
% train_params.lambda - regularization coefficient for covariance matrices


% Get data & states
[data, sample_idx_data] = buf_data.get_data();
[states, sample_idx_states] = buf_states.get_data();
assert(all(sample_idx_data == sample_idx_states) == 1);

data_cur = data;





% Remove outliers
for n = 1 : 2
    Xmean = mean(data_cur(:));
    Xstd = std(data_cur(:));
    mask = (abs(data_cur-Xmean) < 3 * Xstd);
    mask = prod(double(mask),1);
    idx = find(mask);
    data_cur = data_cur(:,idx);
    states_cur = states(idx);
end

  
idx1 = find(states_cur == train_params.state1);
idx2 = find(states_cur == train_params.state2);

% Data used for current filter set
data1_cur = data_cur(:,idx1);
data2_cur = data_cur(:,idx2);

% Covariance matrices
C1 = data1_cur * data1_cur' / length(idx1);
C2 = data2_cur * data2_cur' / length(idx2);

% Regularization
nchan = size(C1,1);
C1 = C1 + train_params.lambda * trace(C1) * eye(nchan) / size(C1,1);
C2 = C2 + train_params.lambda * trace(C2) * eye(nchan) / size(C2,1);

% CSP
[V d] = eig(C2,C1);
d = diag(d);

% Store filter matrix for given number of components
N = train_params.nCSP;
params.params_spec.M = V(:, [1:N, end-N+1:end])';

% Store pattern matrix for given number of components
Vinv = inv(V');
params.params_spec.Minv = Vinv(:,[1:N, end-N+1:end]);

% Names of filters
params.params_spec.filt_names =...
    arrayfun(@(x)sprintf('%s_%i', train_params.filtnames_base, x), [1:2*N], 'UniformOutput', false);

% Visualize filters/patterns
if ~strcmp(train_params.vis_type, 'none')
    this.visualize(data1_cur, data2_cur, params, train_params);
end


end