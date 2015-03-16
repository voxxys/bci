function init(this, obj_type, params, bufs_in)


stage_name = this.stage_name;


this.obj_type = obj_type;
this.params = params;
this.bufs_in = bufs_in;


%%% 1. Prepare parameters

if ~isfield(params, 'params_base')
    params.params_base = struct();
end

if ~isfield(params, 'params_spec')
    params.params_spec = struct();
end

if ~isfield(params, 'buf_out_desc')
    params.buf_out_desc = struct();
end

if ~isfield(params, 'inp_descs')
    params.inp_descs = repmat(struct(), 1, length(bufs_in));
end
ndescs = length(params.inp_descs);
nbufs = length(bufs_in);
if ndescs < nbufs
    s = params.inp_descs(1);
    fldnames = fieldnames(s);
    for n = 1 : length(fldnames)
        s = setfield(s, fldnames{n}, []);
    end
    params.inp_descs(ndescs + 1 : nbufs) = s;
end

% Get input sampling rates from input buffers
for n = 1 : length(bufs_in)                
    params.inp_descs(n).srate_in = bufs_in(n).srate;            
end

% Set default output sampling rate (if needed)
if ~isfield(params.params_base, 'srate_out')
    log_write('[%s] t_sigproc_stage::init() -> srate_out not specified - will use srate of first input\n', stage_name);
    params.params_base.srate_out = params.inp_descs(1).srate_in;
end

% Set default length of preceding time window (if needed)
if ~isfield(params.params_base, 'timewin_prev')
    log_write('[%s] t_sigproc_stage::init() -> timewin_prev not specified - will use 0\n', stage_name);
    params.params_base.timewin_prev = 0;
end

% Get names of input channels to use (if needed)
for n = 1 : length(bufs_in) 
    if is_empty_or_nonfield(params.inp_descs(n), 'chan_names_in')
        log_write('[%s] t_sigproc_stage::init() -> inp_descs(%i).chan_names_in not specified - will use all channels\n', stage_name, n);
        params.inp_descs(n).chan_names_in = bufs_in(n).chan_names;
    end
end

% Get type of output buffer (if needed)
if ~isfield(params.buf_out_desc, 'type')
    log_write('[%s] t_sigproc_stage::init() -> buf_out_type not specified - will use type of 1-st input buffer\n', stage_name);
    params.buf_out_desc.type = bufs_in(n).buf_type;
end

% Get length of output buffer (if needed)
if ~isfield(params.buf_out_desc, 'len_t')
    log_write('[%s] t_sigproc_stage::init() -> buf_out_len_t not specified - will use length of 1-st input buffer\n', stage_name);
    params.buf_out_desc.len_t = bufs_in(1).get_buf_len_t();
end

%%% 2. Create processing object
obj_name = sprintf('%s_OBJ', stage_name);
eval_str = sprintf('this.proc_obj = %s(''%s'');', this.obj_type, obj_name);
eval(eval_str);

%%% 3. Initialize processing object
params = this.proc_obj.init(params);

%%% 4. Create output buffer
buf_out_name = [this.stage_name '.buf'];
buf_out_len = ceil(params.buf_out_desc.len_t * params.params_base.srate_out);
chan_names_out = params.params_base.chan_names_out;
this.buf_out = t_sample_buf(buf_out_name);
this.buf_out.allocate(chan_names_out, buf_out_len, params.buf_out_desc.type, params.params_base.srate_out);

%%% 5. Pass input / output buffers to processing object
params = this.proc_obj.set_bufs(this.bufs_in, this.buf_out);

% Store parameters
this.params = params;

this.ready = 1;

end

