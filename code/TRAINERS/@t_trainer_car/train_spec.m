function params = train_spec(this, buf_data, buf_states, params, train_params)

[data, sample_idx_data] = buf_data.get_data();

numch = size(data,1);

M_car = eye(numch) - 1/numch;

params.params_spec.M = M_car;


end