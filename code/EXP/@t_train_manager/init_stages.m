function init_stages(this)


% Get length of experimental data (in seconds)
len_t = this.expresult.data.sz_used / this.expresult.data.srate;
len_t = len_t * 1.2;    % will allocate slightly more


% Create objects
this.sigsrc_stage = t_sigsrc_stage('SIGNAL_SOURCE');
this.stategen_stage = t_stategen_stage('STATE_GENERATOR');
this.sigproc_graph = t_procstage_graph('SIGPROC_GRAPH');
this.stateproc_graph = t_procstage_graph('STATEPROC_GRAPH');


% Set signal source parameters
this.sigsrc_stage_desc.obj_type = 't_eeg_recv_manager_buf';
this.sigsrc_stage_desc.params.params_spec.buf = this.expresult.data;
this.sigsrc_stage_desc.params.buf_out_desc.type = 'linear';
this.sigsrc_stage_desc.params.buf_out_desc.len_t = len_t;

% Set state generator parameters
this.stategen_stage_desc.obj_type = 't_state_generator_buf';
this.stategen_stage_desc.params.params_spec.buf = this.expresult.states;
this.stategen_stage_desc.params.params_base.state_descs(1).label = 0;
this.stategen_stage_desc.params.params_base.state_descs(1).name = 'NULL';
this.stategen_stage_desc.params.params_base.state_id_def = 1;
this.stategen_stage_desc.params.params_base.chan_names_out = {'STATE'};
this.stategen_stage_desc.params.buf_out_desc.type = 'linear';
this.stategen_stage_desc.params.buf_out_desc.len_t = len_t;


% Initialize signal source
this.sigsrc_stage.init(this.sigsrc_stage_desc.obj_type, this.sigsrc_stage_desc.params);
this.sigsrc_stage.print_params();


% Set output srate of state generator (it was obtained during sigsrc_stage.init())
this.stategen_stage_desc.params.params_base.srate_out = this.sigsrc_stage.params.params_base.srate_out;

% Initialize state generator
this.stategen_stage.init(this.stategen_stage_desc.obj_type, this.stategen_stage_desc.params);
this.stategen_stage.print_params();

% Set signal source as the input of state generator
this.stategen_stage.set_sigsrc_stage(this.sigsrc_stage);


% Set signal source as the input of signal processing graph
this.sigproc_graph.set_outer_inp_stage(this.sigsrc_stage, 'buf_eeg');

% Initialize signal processing graph (just find indices of stages and processing order)
this.sigproc_graph.init(this.sigproc_stage_descs);      % use only stage names from sigproc_stage_descs


% Set state generator as the input of state processing graph
this.stateproc_graph.set_outer_inp_stage(this.stategen_stage, 'buf_out');

% Initialize state processing graph (just find indices of stages and processing order)
this.stateproc_graph.init(this.sigproc_stage_descs);    % use only stage names from sigproc_stage_descs


end

