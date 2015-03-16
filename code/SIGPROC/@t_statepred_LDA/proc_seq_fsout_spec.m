function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)


nchan = size(data_in,1);
nsamples = size(data_in,2);

data_out = zeros(2,nsamples);

% Input channel difference
%D = data_in(obj.chan_idx_used(2),:) - data_in(obj.chan_idx_used(1),:);

D = sum(bsxfun(@times, data_in, this.params.params_spec.LDA_coeffs(1,2).linear)) + this.params.params_spec.LDA_coeffs(1,2).const;
D = -D;

% Hard prediction
idx = (D > 0) + 1;
data_out(1,:) = this.params.params_spec.state_labels(idx);

% Smooth prediction
data_out(2,:) = 1 ./ (1 + exp(-D/1));


end