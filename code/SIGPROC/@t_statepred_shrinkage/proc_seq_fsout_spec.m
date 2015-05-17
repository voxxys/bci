function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)


nchan = size(data_in,1);
nsamples = size(data_in,2);

data_out = zeros(2,nsamples);


W12 = this.params.params_spec.W12;


Q12 = W12'*data_in;


data_out(1,:) = Q12;


end