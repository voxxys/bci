function stateproc_stage_desc = sigproc_to_stateproc_desc(sigproc_stage_desc)
% Prepare descriptor of state processing stage using parameters of corresponding signal processing stage

stateproc_stage_desc = struct();        

% Name of stage
stateproc_stage_desc.stage_name = sigproc_stage_desc.stage_name;

% Processing object that does nothing but resampling
stateproc_stage_desc.obj_type = 't_sigproc_base';

% Output sampling rate, preceding time window (just to match to signal processing), params of output buffer
stateproc_stage_desc.params.params_base.srate_out = sigproc_stage_desc.params.params_base.srate_out;
stateproc_stage_desc.params.params_base.timewin_prev = sigproc_stage_desc.params.params_base.timewin_prev;
stateproc_stage_desc.params.buf_out_desc.type = sigproc_stage_desc.params.buf_out_desc.type;
stateproc_stage_desc.params.buf_out_desc.len_t = sigproc_stage_desc.params.buf_out_desc.len_t;

% Find input with max. sampling rate
srate_vec_in = [sigproc_stage_desc.params.inp_descs.srate_in];
[~, inp_id_used] = max(srate_vec_in);

% Set signgle input (having max. sampling rate)
stateproc_stage_desc.params.inp_descs(1).inp_stage_name = sigproc_stage_desc.params.inp_descs(inp_id_used).inp_stage_name;
stateproc_stage_desc.params.inp_descs(1).chan_names_in = {'STATE'};

end

