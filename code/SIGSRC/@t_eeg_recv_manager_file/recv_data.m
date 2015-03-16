function nsamples_recv = recv_data(this, buf_eeg, buf_mark)
% Reads EEG samples & markers from EEG structure
% buf_eeg and buf_markers  are t_sample_buf objects
% Size of buffers: buf_eeg(nchans_eeg,nsamples_max)
% Size of buffers: buf_mark(nchans_mark,nsamples_max)
% nsamples_recv - number of samples read
% nsamples_recv_total <- nsamples_recv_total + nsamples_recv


% Get current time
tcur = toc(this.timer);

% Get size of data to output
if strcmp(this.params.params_spec.mode, 'block')
    nsamples_recv = this.params.out_block_sz;        % fixed size
elseif strcmp(this.params.params_spec.mode, 'realtime')                
    dt = (tcur - this.last_req_time);   % * this.params.time_mult;  -- commented because multiplier is included in srate now
    srate = this.params.params_base.srate_out;
    nsamples_recv = floor(dt * srate);              % use srate
else
    log_write('[%s] t_eeg_recv_manager_file::recv_data() -> invalid ''mode'' parameter (%s) - ERROR\n', name, this.params.params_spec.mode);
    assert(0==1);
end

% Check if there is no data to output
if nsamples_recv == 0
%if nsamples_recv < 100
    return;
end

% If some data will be sent to output - current time becomes the time of last data request
if nsamples_recv
    this.last_req_time = tcur;
end

EEG = this.EEG;

% Number of samples in dataset
nsamples_total = size(EEG.data,2);

% Check if we need to output more data than we have in dataset
if nsamples_recv > nsamples_total
    log_write('[%s] t_eeg_recv_manager_file::recv_data() -> we have to output more data than we have in dataset - ERROR\n', name);
    assert(0==1);
end

pos_first = this.dataset_pos_cur;
pos_last = this.dataset_pos_cur + nsamples_recv - 1;

% Latencies and types of events from dataset
ev_lats = [EEG.event.latency];
isnum = all(cellfun(@(s)isnumeric(s),{EEG.event.type}));
if isnum
    ev_types = [EEG.event.type];
else
    ev_types = cellfun(@(s)str2num(s),{EEG.event.type});
end
assert(length(ev_lats) == length(ev_types));

% Here we will store EEG & marker data to output
data = zeros(size(EEG.data,1), nsamples_recv);
mark_data = NaN * ones(1, nsamples_recv);

% Get chunck of data to output
% (if we pass over the end of dataset - concatenate 2 chuncks: from the end and from the beginning of dataset)
% Also get indices of events that fall into corresponding time range
if pos_last < nsamples_total

    data = EEG.data(:, pos_first:pos_last);

    ev_idx = find((ev_lats >= pos_first) & (ev_lats <= pos_last));
    ev_lats_cur = ev_lats(ev_idx);
    ev_lats_cur_rel = ev_lats_cur - pos_first + 1;
    ev_types_cur = ev_types(ev_idx);
    mark_data(ev_lats_cur_rel) = ev_types_cur;

else                

    sz1 = nsamples_total - pos_first + 1;
    sz2 = nsamples_recv - sz1;

    for n = [1, 2]

        if n == 1
            pos_first = pos_first;
            pos_last = nsamples_total;
            out_pos_first = 1;
            sz = sz1;
        else
            pos_first = 1;
            pos_last = sz2;
            out_pos_first = sz1 + 1;
            sz = sz2;
        end

        data(:, out_pos_first : out_pos_first+sz-1) = EEG.data(:, pos_first:pos_last);

        ev_idx = find((ev_lats >= pos_first) & (ev_lats <= pos_last));
        ev_lats_cur = ev_lats(ev_idx);
        ev_lats_cur_rel = ev_lats_cur - pos_first + out_pos_first;
        ev_types_cur = ev_types(ev_idx);
        mark_data(ev_lats_cur_rel) = ev_types_cur;

    end

end

% Update current position in a dataset
this.dataset_pos_cur = pos_last + 1;
if this.dataset_pos_cur > nsamples_total
    this.dataset_pos_cur = 1;
end

% Assign indices to recieved samples
sample_idx_new = this.nsamples_recv_total + [1 : nsamples_recv];

% Add recieved data & markers to memory buffers
buf_eeg.append(sample_idx_new, data); 
buf_mark.append(sample_idx_new, mark_data);

% Update number of recieved samples
this.nsamples_recv_total = this.nsamples_recv_total + nsamples_recv;


end
