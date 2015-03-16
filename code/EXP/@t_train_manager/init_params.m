function init_params(this, params_outer)
% Initialize parameters of train manager and processing stages


% Get parameters from argument
this.train_info = params_outer.train_info;
%this.exp_params = params_outer.exp_params;

% Get parameters of stages from argument
%this.sigsrc_stage_desc = params_outer.sigsrc_stage_desc;
%this.stategen_stage_desc = params_outer.stategen_stage_desc;
this.sigproc_stage_descs = params_outer.sigproc_stage_descs;


% Set some parameters of state generator
%{
this.stategen_stage.params.buf_out_desc.type = this.sigsrc_stage.params.buf_out_desc.type;          % output buffer type
this.stategen_stage.params.buf_out_desc.len_t = this.sigsrc_stage.params.buf_out_desc.len_t;        % output buffer length
this.stategen_stage.params.params_base.chan_names_out = {'STATE'};
%}


end

