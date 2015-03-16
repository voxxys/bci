function init(this, bufs_in, stage_desc)


name = this.name;


% Store references to input buffers
this.bufs_in = bufs_in;


%%% 1. Prepare parameters of input processing object

% Parameters of input processing object
params = struct();

params.params_base = struct();
params.params_spec = struct();
params.buf_out_desc = struct();
params.inp_descs = repmat(struct(), 1, length(bufs_in));

% Get input sampling rates from input buffers
for n = 1 : length(bufs_in)                
    params.inp_descs(n).srate_in = bufs_in(n).srate;            
end

% Set default output sampling rate (if needed)
if isfield(stage_desc.params.params_base, 'srate_out')
    params.params_base.srate_out = stage_desc.params.params_base.srate_out;
else
    log_write('[%s] t_trainer_base::init() -> srate_out not specified - will use srate of first input\n', name);
    params.params_base.srate_out = params.inp_descs(1).srate_in;
end

% Set zero length of preceding time window
params.params_base.timewin_prev = 0;

% Set names of input channels to use (if needed)
for n = 1 : length(bufs_in) 
    if isfield(stage_desc.params, 'inp_descs')
        if n <= length(stage_desc.params.inp_descs)
            if ~is_empty_or_nonfield(stage_desc.params.inp_descs(n), 'chan_names_in')
                params.inp_descs(n).chan_names_in = stage_desc.params.inp_descs(n).chan_names_in;
            end
        end
    end
end

% Set output channel names (if needed)
if isfield(stage_desc.params.params_base, 'chan_names_out')
    params.params_base.chan_names_out = stage_desc.params.params_base.chan_names_out;
end

% Set type of output buffer
params.buf_out_desc.type = 'linear';

% Set length of output buffer
params.buf_out_desc.len_t = bufs_in(1).get_buf_len_t();


%%% 2. Create input processing object
obj_name = sprintf('%s_INPPROCOBJ', name);
eval_str = sprintf('this.inp_proc_obj = %s(''%s'');', 't_sigproc_base', obj_name);
eval(eval_str);


%%% 3. Initialize input processing object
params = this.proc_obj.init(params);


%%% 4. Create buffer for combining inputs
buf_total_name = [this.name '.buf'];
buf_total_len = ceil(params.buf_out_desc.len_t * params.params_base.srate_out);
chan_names_out = params.params_base.chan_names_out;
this.buf_total = t_sample_buf(buf_total_name);
this.buf_total.allocate(chan_names_out, buf_total_len, params.buf_out_desc.type, params.params_base.srate_out);


%%% 5. Pass input / output buffers to input processing object
params = this.proc_obj.set_bufs(this.bufs_in, this.buf_total);


end

