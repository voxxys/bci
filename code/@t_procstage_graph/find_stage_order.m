function find_stage_order(this)
           
nstages = length(this.stageconn_descs);

% 1 if stage already included in the order list
ready_flags = zeros(1, nstages);

% List of stage indices in the usage order
this.stage_order = [];

while ~all(ready_flags == 1)

    stage_found = 0;

    for n = 1 : nstages

        % Stage already in list
        if ready_flags(n)
            continue;
        end

        % Indices of input stages
        inp_stage_idx = this.stageconn_descs(n).inp_stage_idx;

        % Remove zero indices (corresponding to outer inputs) from array
        idx = find(inp_stage_idx == 0);
        inp_stage_idx(idx) = [];

        % All inputs of this stage are already in list or it requires no inputs - add stage to list
        if isempty(inp_stage_idx) || all(ready_flags(inp_stage_idx) == 1)
            this.stage_order = [this.stage_order, n];
            ready_flags(n) = 1;
            stage_found = 1;
            break;
        end

    end

    if ~stage_found
        % No stages were added at this iteration
        log_write('[%s] t_procstage_graph::find_stage_order() -> cannot deduce stage order\n', this.name);
        assert(1==0);
    end

end

end