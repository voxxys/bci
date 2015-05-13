function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP
% train_params.lambda - regularization coefficient for covariance matrices

load('M_eog.mat');
params.params_spec.M = M_eog;

params.params_spec.filt_names = [];


end