function do_work(this)            
% Perform processing


% Object must be initiaized
assert(this.ready == 1);

% Input / output buffers must be set
assert(isempty(this.bufs_in) == 0);
assert(isempty(this.buf_out) == 0);


num_inp = length(this.params.inp_descs);


%%%% I. Get available data and calculate array of sample indices after down- and upsampling (for each input)

data_in_all = {};
sample_idx_in_all = {};
inp_procpos_vecs_all = {};

% Array of upsampling coefficients of inputs
k_up_vec = zeros(1,num_inp);

% Total number of samples after down- and upsampling for each input
nsamples_US_vec = zeros(1,num_inp);

for inp_num = 1 : num_inp
    
    inp_desc_cur = this.params.inp_descs(inp_num);
    
    % Number of preceding samples that are necessary to process some sample
    nprev = inp_desc_cur.nsamples_prev;

    % Get non-processed data from input buffer + some preceding samples if needed
    [data_in, sample_idx_in] = this.bufs_in(inp_num).get_data(this.sample_id_last + 1, Inf, nprev);
    
    % Nothing to process
    if length(sample_idx_in) == 0
        return;
    end
    
    % Discard unused channels
    chan_idx_used = this.params.inp_descs(inp_num).chan_idx_in;
    data_in = data_in(chan_idx_used, :);
    
    % Coefficients of downsampling / upsampling
    k_down = inp_desc_cur.k_downsamp;
    k_up = inp_desc_cur.k_upsamp;
    
    k_up_vec(inp_num) = k_up;

    % Position of first non-processed sample in the input data
    inp_pos_0 = nprev + 1;

    % Number of non-processed input samples
    nsamples_new_in = length(sample_idx_in(inp_pos_0:end));

    % Number of non-processed input samples after downsampling
    nsamples_new_DS = floor(double(nsamples_new_in) / k_down);

    % Positions of input samples that correspond to downsampled data
    inp_procpos_vec = inp_pos_0 - 1 + k_down * [1 : nsamples_new_DS];
    if isempty(inp_procpos_vec)
        return;
    end
    
    % Downsample sequence of sample indices
    sample_idx_DS = sample_idx_in(inp_procpos_vec);
    
    % Upsample sequence of sample indices
    if k_up == 1
        sample_idx_US{inp_num} = sample_idx_DS;
    else
        sample_idx_US{inp_num} = kron(sample_idx_DS, ones(1,k_up));
    end
 
    % Max. sample index after down- and upsampling
    nsamples_US_vec(inp_num) = length(sample_idx_US{inp_num});
    
    % Store initial data for further processing
    data_in_all{inp_num} = data_in;
    sample_idx_in_all{inp_num} = sample_idx_in;
    inp_procpos_vecs_all{inp_num} = inp_procpos_vec;
    
end


%%%% II. Find common part of data portions obtained from all inputs

% Least common multiple (LCM) of upsampling coefficients
k_up_lcm = veclcm(k_up_vec);

% Min. number of obtained samples (after down- and upsampling) over all inputs
nsamples_US_min = min(nsamples_US_vec);

% Trim number of samples so it is divisible by LCM of upsampling coefficients
nsamples_US_min = k_up_lcm * floor(nsamples_US_min / k_up_lcm);

if nsamples_US_min == 0
    return;
end

% Positions in sample_idx_US{} elements that must be equal
idx_checkpos_vec = [k_up_lcm : k_up_lcm : nsamples_US_min];

% Max. common sample index
sample_id_common_max = [];

% Common sample indices
sample_idx_common = [];

% Find common down- and upsampled sample idx and check that they are the same among inputs
for inp_num = 1 : num_inp
   
    sample_idx_US_cur = sample_idx_US{inp_num};
    sample_idx_common_cur = sample_idx_US_cur(idx_checkpos_vec);
    
    % Fill array of sample indices that must be same among inputs
    % and find maximum of them
    if isempty(sample_idx_common)
        sample_idx_common = sample_idx_common_cur;
        sample_id_common_max = max(sample_idx_common);
    end
    
    % Check equality of sample indices for current input to the stored ones
    %if ~same(sample_idx_common_cur, sample_idx_common)
    is_ok = 1;
    if length(sample_idx_common_cur) == length(sample_idx_common)
        if ~all(sample_idx_common_cur == sample_idx_common)
            is_ok = 0;
        end
    else
        is_ok = 0;
    end
    if ~is_ok
        log_write('[%s] t_sigproc_base::do_work() -> input sample indices mismatch - ERROR\n', this.name);
        log_write('inp < %i: %s\n', inp_num, sprintf('%i ', sample_idx_common));
        log_write('inp = %i: %s\n', inp_num, sprintf('%i ', sample_idx_common_cur));
        assert(1==0);        
    end

    % Trim input sample indices and data
    idx = find(sample_idx_in_all{inp_num} <= sample_id_common_max);
    sample_idx_in_all{inp_num} = sample_idx_in_all{inp_num}(idx);
    data_in_all{inp_num} = data_in_all{inp_num}(:,idx);
    
    % Trim vector of sample positions that correspond to downsampled data
    nsamples_used = length(sample_idx_in_all{inp_num});
    idx = find(inp_procpos_vecs_all{inp_num} <= nsamples_used);
    inp_procpos_vecs_all{inp_num} = inp_procpos_vecs_all{inp_num}(idx);
    
end


%%%% III. Process data

% Sample indices and data for each input after down- and upsampling
sample_idx_US_all = {};
data_US_all = {};

% Here we accumulate number of processed input channels
nchan_US_total = 0;

for inp_num = 1 : num_inp

    inp_desc_cur = this.params.inp_descs(inp_num);
    
    % Number of preceding samples that are necessary to process some sample
    nprev = inp_desc_cur.nsamples_prev;
    
    data_in = data_in_all{inp_num};
    sample_idx_in = sample_idx_in_all{inp_num};
    inp_procpos_vec = inp_procpos_vecs_all{inp_num};
    
    %%%%%  1. Process data with original sampling rate as a whole (e.g. temporal filtering)
    % (Number of channels can change here)
    data_in = this.proc_seq_fsin_spec(sample_idx_in, data_in, inp_num);       % preserve sampling rate and number of samples
    assert(size(data_in,2) == length(sample_idx_in));

    %%%%%  2. Downsample data
    
    % Downsample sequence of sample indices
    sample_idx_DS = sample_idx_in(inp_procpos_vec);
    
    if strcmp(this.params.params_base.downsamp_type, 'thin')

        %%%%%  2a. Downsample data (thinning)
        data_DS = data_in(:,inp_procpos_vec);

    elseif strcmp(this.params.params_base.downsamp_type, 'interp')

        %%%%%  2b. Downsample data: interpolate sample with (k_down-1) preceding samples, then thinning
        % TODO: data_in = this.inerp(data_in, k_down)
        data_DS = data_in(:,inp_procpos_vec);
        assert(0==1);   % not implemented

    elseif strcmp(this.params.params_base.downsamp_type, 'special')

        %%%%%  2c. Downsample data by processing chunks of input data one by one (e.g. window fourier transformation)
        % Each chunk contains (nprev+1) input samples and corresponds to single output sample
        % (Number of channels can change here)
        data_DS = [];
        for n = 1 : nsamples_DS_0
            pos = inp_procpos_vec(n);
            range = [pos-nprev : pos];
            x = this.proc_samp_fsin_spec(sample_idx_in(range), data_in(:,range), inp_num);
            if isempty(data_DS)
                data_DS = zeros(size(x,1), nsamples_DS_0)
            end
            data_DS(:,n) = x;
        end

    end
    
    %%%%%  3. Upsample data

    k_up = inp_desc_cur.k_upsamp;
    upsamp_type = this.params.params_base.upsamp_type;
    
    % Upsample sequence of sample indices
    sample_idx_US = kron(sample_idx_DS, ones(1,k_up));

    % Upsample data
    if k_up == 1
        data_US = data_DS;
    else
        if strcmp(upsamp_type, 'repeat')
            data_US = kron(data_DS, ones(1,k_up));
        elseif strcmp(upsamp_type, 'interp')
            assert(0==1);   % not implemented
        end
    end
    
    % Number of output channels for current input
    nchan_cur = size(data_US,1);
    
    % Update total number of channels in downsampled data
    nchan_US_total = nchan_US_total + nchan_cur;
    
    sample_idx_US_all{inp_num} = sample_idx_US;
    data_US_all{inp_num} = data_US;
    
end

% Use indices of samples for input with maximal sampling rate for output
srate_vec = [this.params.inp_descs.srate_in];
[~, inp_num_used] = max(srate_vec);
sample_idx_US_common = sample_idx_US_all{inp_num_used};

% Allocate array to combine data from all channels
data_US_total = zeros(nchan_US_total, length(sample_idx_US_common));

chan_num_cur = 1;
for inp_num = 1 : num_inp
    
    data_US = data_US_all{inp_num};
    nchan_cur = size(data_US,1);
    
    % Copy data for this input to the total buffer
    data_US_total(chan_num_cur : chan_num_cur + nchan_cur - 1, :) = data_US;
    
    chan_num_cur = chan_num_cur + nchan_cur;
    
end

%%%%%  4. Process down- and upsampled data (e.g. spatial filtering)
% (Number of channels can change here)
data_US_total = this.proc_seq_fsout_spec(sample_idx_US_common, data_US_total);

% Number of output channels must correspond to output channel names
if (size(data_US_total,1) ~= length(this.params.params_base.chan_names_out))
    fff=1;
end
assert(size(data_US_total,1) == length(this.params.params_base.chan_names_out));

% Write data to output buffer
this.buf_out.append(sample_idx_US_common, data_US_total);


% Update index of last processed input sample
this.sample_id_last = sample_idx_US_common(end);


end


