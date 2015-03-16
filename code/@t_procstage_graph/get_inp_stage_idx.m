function get_inp_stage_idx(this)
            
for n = 1 : length(this.stageconn_descs)

    for m = 1 : length(this.stageconn_descs(n).inp_stage_names)                    

        inp_stage_name = this.stageconn_descs(n).inp_stage_names{m};                    

        if strcmp(inp_stage_name, '[INPUT]')    % outer input stage
            inp_stage_id = 0;
        else                                    % inner stage
            inp_stage_id = find(strcmp(inp_stage_name, {this.stageconn_descs.stage_name}));                        
        end

        % Stage with given name not found
        if isempty(inp_stage_id)
            log_write('[%s] t_procstage_graph::get_inp_stage_idx() -> input stage %s for stage %s not found\n',...
                this.name, inp_stage_name, this.stageconn_descs(n).stage_name);
            assert(1==0);
        end                    

        this.stageconn_descs(n).inp_stage_idx(m) = inp_stage_id;

    end   

end

end