function init_stages(this)


% Create objects
this.sigsrc_stage = t_sigsrc_stage('SIGNAL_SOURCE');
this.stategen_stage = t_stategen_stage('STATE_GENERATOR');
this.sigproc_graph = t_procstage_graph('SIGPROC_GRAPH');
this.stateproc_graph = t_procstage_graph('STATEPROC_GRAPH');


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


% Initialize each stage of signal processing graph
for n = 1 : length(this.sigproc_graph.stage_order)       
    stage_num = this.sigproc_graph.stage_order(n);
    this.sigproc_graph.create_stage(stage_num, this.sigproc_stage_descs(stage_num));        
end


% Initialize each stage of state processing graph
for n = 1 : length(this.sigproc_graph.stage_order)
    
    stage_num = this.sigproc_graph.stage_order(n);
   
    % Create state processing stage descriptor
    % from the corresponding signal processing stage descriptor
    sigproc_stage_desc = this.sigproc_graph.stage_descs(stage_num);
    stage_desc = sigproc_to_stateproc_desc(sigproc_stage_desc);
    
    stage_num = this.stateproc_graph.stage_order(n);
    this.stateproc_graph.create_stage(stage_num, stage_desc);
    
end


end

