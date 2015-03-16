function init_stageconn_descs(this, stage_descs)


stageconn_descs = struct([]);

for n = 1 : length(stage_descs)

    % Set name of stage
    stageconn_descs(n).stage_name = stage_descs(n).stage_name;

    if ~isfield(stage_descs(n).params, 'inp_descs')
        log_write('[%i] t_procstage_graph::init_stageconn_descs() -> stage %i (%s) has no inputs\n',...
            this.name, n, stage_descs(n).stage_name);
        assert(1==0);
    end

    % Set names of input stages and activity flags
    for m = 1 : length(stage_descs(n).params.inp_descs)
        stageconn_descs(n).inp_stage_names{m} = stage_descs(n).params.inp_descs(m).inp_stage_name;
        stageconn_descs(n).inp_stage_active_flags(m) = 1;
    end

end

this.stageconn_descs = stageconn_descs;


end