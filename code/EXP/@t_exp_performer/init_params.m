function init_params(this, params_outer)
% Initialize parameters of experiment and processing stages


% Get experiment parameters from argument
this.exp_info = params_outer.exp_info;
this.exp_params = params_outer.exp_params;

% Get parameters of stages from argument
this.sigsrc_stage_desc = params_outer.sigsrc_stage_desc;
this.stategen_stage_desc = params_outer.stategen_stage_desc;
this.sigproc_stage_descs = params_outer.sigproc_stage_descs;

% Signal source: set buffer type to linear and buffer length slightly larger than experiment duration (if needed)
len_t = this.exp_params.exp_duration_t * 1.2;
if ~isfield2(this.sigsrc_stage_desc.params, {'buf_out_desc', 'type'})
    this.sigsrc_stage_desc.params.buf_out_desc.type = 'linear';
end
if ~isfield2(this.sigsrc_stage_desc.params, {'buf_out_desc', 'len_t'})
    this.sigsrc_stage_desc.params.buf_out_desc.len_t = len_t;
end

% State generator: set buffer type and length to the same vales as in the signal source
this.stategen_stage_desc.params.buf_out_desc.type = this.sigsrc_stage_desc.params.buf_out_desc.type;
this.stategen_stage_desc.params.buf_out_desc.len_t = this.sigsrc_stage_desc.params.buf_out_desc.len_t;

% Signal processing: set buffer type to linear and buffer length slightly larger than experiment duration (if needed)
for n = 1 : length(this.sigproc_stage_descs)
    if ~isfield2(this.sigproc_stage_descs(n).params, {'buf_out_desc', 'type'})
        this.sigproc_stage_descs(n).params.buf_out_desc.type = 'linear';
    end
    if ~isfield2(this.sigproc_stage_descs(n).params, {'buf_out_desc', 'len_t'})
        this.sigproc_stage_descs(n).params.buf_out_desc.len_t = len_t;
    end
end

% Set name of output channel of state generator
this.stategen_stage_desc.params.params_base.chan_names_out = {'STATE'};


end

