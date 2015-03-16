function buf = get_exp_buf(this, data_type, stage_name, buf_name)

init_var('buf_name', '[]');

% Name of input buffer
if isempty(buf_name)
    if strcmp(stage_name, '[INPUT]') & strcmp(data_type, 'SIGNAL')
        buf_name = 'buf_eeg';
    else
        buf_name = 'buf_out';
    end
end

% Get input stage
if strcmp(data_type, 'SIGNAL')
    if strcmp(stage_name, '[INPUT]')
        stage = this.exp.sigsrc_stage;                        
    else
        stage = this.exp.sigproc_graph.stage_by_name(stage_name);
    end
elseif strcmp(data_type, 'STATE')
    if strcmp(stage_name, '[INPUT]')
        stage = this.exp.stategen_stage;                        
    else
        stage = this.exp.stateproc_graph.stage_by_name(stage_name);
    end
end

% Get input buffer
buf = getfield(stage, buf_name);

end