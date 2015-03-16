function data_out = proc_seq_fsin_spec(this, sample_idx_in, data_in, inp_num)
     

% Number of input samples
nsamples_in = length(sample_idx_in);

% Number of filter bands
nbands = length(this.params.params_spec.freq_bands);

% Number of input and output channels for given input
nchans_in = size(data_in,1);
nchans_out = nbands * nchans_in;

% Allocate memory for output data
data_out = zeros(nchans_out, nsamples_in);

% Perform filtering for each band
chan_id0_cur = 1;
for n = 1 : nbands

    % Frequency limits
    fmin = this.params.params_spec.freq_bands{n}(1);
    fmax = this.params.params_spec.freq_bands{n}(2);

    data_out_cur = data_in;

    % Highpass filter
    if fmin > 0
        a_high = this.bandfilt_coeffs{inp_num,n}.a_high;
        b_high = this.bandfilt_coeffs{inp_num,n}.b_high;
        [data_out_cur, Z] = filter(b_high, a_high, data_out_cur, this.Zlast{inp_num,n,1}, 2);
        this.Zlast{inp_num,n,1} = Z;%Z(:,end);
    end

    % Lowpass filter
    if fmax < Inf
        a_low = this.bandfilt_coeffs{inp_num,n}.a_low;
        b_low = this.bandfilt_coeffs{inp_num,n}.b_low;
        [data_out_cur, Z] = filter(b_low, a_low, data_out_cur, this.Zlast{inp_num,n,2}, 2);
        this.Zlast{inp_num,n,2} = Z;%Z(:,end);
    end

    data_out(chan_id0_cur : chan_id0_cur+nchans_in-1, :) = data_out_cur;
    chan_id0_cur = chan_id0_cur + nchans_in;

end


end

