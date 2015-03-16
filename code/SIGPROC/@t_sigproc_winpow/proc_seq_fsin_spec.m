function data_out = proc_seq_fsin_spec(this, sample_idx_in, data_in, inp_num)


% Number of samples to average over
nprev = this.params.inp_descs(inp_num).nsamples_prev;

nchan = size(data_in,1);
nsamples = size(data_in,2);

% Amplitude -> power
data_in = data_in.^2;            

data_out = zeros(nchan, nsamples + nprev);

% Averaging kernel
K = ones(1,nprev+1);

% Apply averaging kernel

for n = 1 : nchan
    data_out(n,:) = conv(data_in(n,:), K);
end

% Trim right side of convolved signal
data_out = data_out(:,1:nsamples);


end