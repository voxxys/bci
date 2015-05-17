function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)


nchan = size(data_in,1);
nsamples = size(data_in,2);
state_ids = this.params.params_spec.state_ids;
data_out = zeros(2,nsamples);


net1 = this.params.params_spec.net1;

data_in = data_in(1:2:end,:);

rating = net1(data_in);


[val, ind] = max(rating);

data_out(1,:) = state_ids(ind);
data_out(2,:) = val;


end