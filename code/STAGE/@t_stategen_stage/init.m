function init(this, obj_type, params)


stage_name = this.stage_name;


this.params = params;
this.obj_type = obj_type;


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

% Get type of output buffer (if needed)
if ~isfield(params.buf_out_desc, 'type')
    log_write('[%s] t_sigproc_stage::init() -> buf_out_type not specified - ERROR\n', stage_name);
    assert(0==1);
end

% Get length of output buffer (if needed)
if ~isfield(params.buf_out_desc, 'len_t')
    log_write('[%s] t_sigproc_stage::init() -> buf_out_len_t not specified - ERROR\n', stage_name);
    assert(0==1);
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

% Store parameters
this.params = params;

this.ready = 1;


end
