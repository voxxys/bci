function init(this, stage_desc, bufs_in_data, bufs_in_states)


%%%% Create and initialize signal processing stage

% Create stage object
obj_name = sprintf('%s.SIGPROC_STAGE', this.name);
this.sigproc_stage = t_sigproc_stage(obj_name);

% Prepare stage parameters: just a resampler
% srate_out and chan_names in are taken from stage_desc if they were previously loaded from settings
% chan_names_out are not initialized, because they can only be known after stage initialization (i.e. also after training)
params = struct();
if isfield2(stage_desc.params, {'params_base', 'srate_out'})
    params.params_base.srate_out = stage_desc.params.params_base.srate_out;
end
for n = 1 : length(stage_desc.params.inp_descs)
    params.inp_descs().inp_stage_name = stage_desc.params.inp_descs(n).inp_stage_name;
    if isfield(stage_desc.params.inp_descs(n), 'chan_names_in')
        params.inp_descs(n).chan_names_in = stage_desc.params.inp_descs(n).chan_names_in;
    end
end
%params.params_base.timewin_prev = 0;
%params.buf_out_desc.type = 'linear';
%params.buf_out_desc.len_t = bufs_in_data(1).get_buf_len_t();

% Initialize signal processing stage
this.sigproc_stage.init('t_sigproc_base', params, bufs_in_data);


%%%% Create and initialize state processing stage

% Create stage object
obj_name = sprintf('%s.STATEPROC_STAGE', this.name);
this.stateproc_stage = t_sigproc_stage(obj_name);

% Prepare stage parameters: just a resampler, leave only 1 input having max. srate
params.params_base.chan_names_out = {'STATE'};
srate_in_vec = [bufs_in_data.srate];
[~, inp_id] = min(srate_in_vec);
params.inp_descs(1) = params.inp_descs(inp_id);
params.inp_descs(1).chan_names_in = {'STATE'};
params.inp_descs(2:end) = [];

% Initialize state processing stage
this.stateproc_stage.init('t_sigproc_base', params, bufs_in_states(inp_id));


end

