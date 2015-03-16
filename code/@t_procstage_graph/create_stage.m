function stage_desc = create_stage(this, stage_num, stage_desc)


% Create stage object
stage = t_sigproc_stage(stage_desc.stage_name);

% Cheat: mark inputs not found in stage_desc as inactive
stageconn_desc = this.stageconn_descs(stage_num);
for n = 1 : length(stageconn_desc.inp_stage_names)
    stage_name_cur = stageconn_desc.inp_stage_names{n};
    stage_names_all = {stage_desc.params.inp_descs.inp_stage_name};
    if ~any(strcmp(stage_name_cur, stage_names_all))
        this.stageconn_descs(stage_num).inp_stage_active_flags(n) = 0;
    end
end

% Get list of input buffers of given stage
bufs_in = this.get_stage_inp_bufs(stage_num);

% Initialize processing stage
stage.init(stage_desc.obj_type, stage_desc.params, bufs_in);

stage_desc.params = stage.params;

% Print stage parameters
stage.print_params();

this.stages(stage_num) = stage;
this.stage_descs(stage_num) = stage_desc;


end