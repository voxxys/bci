function paradigm = train_paradigm(this, trainpar, expresult)


%%%% INITIALIZE PARAMETERS

this.init_params(trainpar);

this.expresult = expresult;


%%%% INITIALIZE INPUT / PROCESSING STAGES

this.init_stages();


%%%%  START SIGNAL SOURCE AND STATE GENERATOR

% Start timer
exp_timer = tic();

% Start recieving data
this.sigsrc_stage.proc_obj.start_recv();

% Start task generator
t = toc(exp_timer);
this.stategen_stage.proc_obj.start(t);


%%%%  PERFORM TRAINING


% Get all EEG data
this.sigsrc_stage.do_work();

% Get all state codes
this.stategen_stage.do_work();

% Clear loaded data to free some memory
this.expresult.data.free();
this.expresult.states.free();


% Train and perform processing steps
for n = 1 : length(this.sigproc_graph.stage_order)
    

    stage_num = this.sigproc_graph.stage_order(n);
    
    % Descriptor of current stage
    stage_desc = this.sigproc_stage_descs(stage_num);
    
    
    % Train stage
    if ~isempty(stage_desc.trainer_type)
        
        log_write('>>>>>  TRAIN STAGE:  %s\n', stage_desc.stage_name);
        
        % Create trainer object
        obj_name = sprintf('%s.TRAINER', stage_desc.stage_name);
        eval(sprintf('trainer = %s(''%s'');', stage_desc.trainer_type, obj_name));
        
        % Get list of input buffers of current stage (data & states)
        bufs_in_data = this.sigproc_graph.get_stage_inp_bufs(stage_num);
        bufs_in_states = this.stateproc_graph.get_stage_inp_bufs(stage_num);
        
        % Initialize trainer object
        trainer.init(stage_desc, bufs_in_data, bufs_in_states);  
        
        % Train
        params = stage_desc.params;
        if isfield(stage_desc, 'train_params')
            train_params = stage_desc.train_params;
        else
            train_params = struct();
        end
        stage_desc.params = trainer.train(params, train_params);
        
        % Destroy trainer object
        trainer = [];
        
    end
    
    
    % Store stage descriptor (with trained parameters) to output paradigm
    stage_desc_0 = this.sigproc_stage_descs(stage_num);
    stage_desc = rmfield(stage_desc, {'trainer_type', 'train_params'});
    stage_desc_0 = rmfield(stage_desc_0, {'trainer_type', 'train_params'});
    paradigm.sigproc_stage_descs(stage_num) = stage_desc_0;
    if isfield(stage_desc.params, 'params_spec')
        paradigm.sigproc_stage_descs(stage_num).params.params_spec = stage_desc.params.params_spec;
    end
    
    
    % Create signal processing stage
    stage_desc = this.sigproc_graph.create_stage(stage_num, stage_desc);
  
    
    % Create state processing stage descriptor from signal processing stage descriptor
    stateproc_stage_desc = sigproc_to_stateproc_desc(stage_desc);
    
    % Create state processing stage
    this.stateproc_graph.create_stage(stage_num, stateproc_stage_desc);
    

    % Process signal
    this.sigproc_graph.stages(stage_num).do_work();

    % Process state vector
    this.stateproc_graph.stages(stage_num).do_work();
    
    % Check if we can destroy input stage
    if this.sigproc_graph.is_out_stages_created(0)
        this.sigsrc_stage.destroy_buf();
        this.stategen_stage.destroy_buf();
    end
        
    % Check if we can destroy some stages
    for n = 1 : length(this.sigproc_graph.stageconn_descs)        
        if this.sigproc_graph.is_out_stages_created(n)
            this.sigproc_graph.stages(n).destroy_buf();
            this.stateproc_graph.stages(n).destroy_buf();
        end        
    end
    

end


%%%% Confusion matrix (comment)

%this.sigproc_graph.stage_order(end)
% is better than
%this.sigproc_graph.stage_order(length(this.sigproc_graph.stage_order))

% this.sigproc_graph.stages(this.sigproc_graph.stage_order(end)) is not guaranteed to be a predicting stage!
% For example, it can be the end of visualzation branch
% You should specify in settings, what stage to use for calculateion of conf. mat.

% states_true is better than states2
% states_pred is better than states3

% I've rewritten train_paradigm() so the memory is deallocated each time when some stage is terminal in the branch
% It means that this code will not work here.
% However, prediction error is calculated in t_trainer_LDA::train_spec(). You can add calc. of confusion matrix there
% In perform exp() the code in this position will work fine.

% Please output interesting information not by disp(), but using log_write() so it is stored on the disk.
% log_write() is my function which has exactly the same notation as fprintf(), but without file id.


%states2 = this.sigproc_graph.stages(this.sigproc_graph.stage_order(length(this.sigproc_graph.stage_order))).buf_out.data(1,:);
%states3 = this.stateproc_graph.stages(this.stateproc_graph.stage_order(length(this.stateproc_graph.stage_order))).buf_out.data;

%confM = confusionmat(states2,states3);

%disp(confM);




end

