function init_spec(this)

% Get input buffers by data type (signal / state) + stage name + buffer name
for n = 1 : length(this.params.sig_descs)

    sig_desc = this.params.sig_descs{n};

    % Type of input: signal or state
    data_type = sig_desc.data_type;

    % Name of input stage
    stage_name = sig_desc.stage_name;

    % Name of input buffer
    if isfield(sig_desc, 'buf_name')
        buf_name =sig_desc.buf_name;
    else
        buf_name = [];
    end
    
    % Get input buffer
    this.bufs_in(n) = this.get_exp_buf(data_type, stage_name, buf_name);

end

end
