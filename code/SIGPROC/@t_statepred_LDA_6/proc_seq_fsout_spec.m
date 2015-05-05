function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)


nchan = size(data_in,1);
nsamples = size(data_in,2);

data_out = zeros(5,nsamples);

% Input channel difference
%D = data_in(obj.chan_idx_used(2),:) - data_in(obj.chan_idx_used(1),:);

for i = 1:5
    coeffs = this.params.params_spec.LDA_6_coeffs{i};
    D{i} = sum(bsxfun(@times, data_in, coeffs(1,2).linear)) + coeffs(1,2).const;
    D{i} = -D{i};
    data_out(i,:) = 1 ./ (1 + exp(-D{i}/1));
    data_out(i,:) = data_out(i,:) + 1;
end
% Smooth prediction



end