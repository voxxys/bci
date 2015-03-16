function perform_exp(this, exp_params)
% Perform experiment


%%%% INITIALIZE PARAMETERS

this.init_params(exp_params);


%%%% INITIALIZE INPUT / PROCESSING STAGES

this.init_stages();


%%%%  INITIAIZE VISUALIZERS

if ~isfield(exp_params, 'visualizers')
    exp_params.visualizers = [];
end

for n = 1 : length(exp_params.visualizers)
    
    if isempty(exp_params.visualizers(n))
        continue;
    end
    
    % Create visualizer object
    obj_name = exp_params.visualizers(n).name;
    obj_type = exp_params.visualizers(n).type;
    eval_str = sprintf('vis_obj = %s(''%s'');', obj_type, obj_name);
    eval(eval_str);
    this.visualizers{n} = vis_obj;
    
    % Initialize vizualizer object
    this.visualizers{n}.init(exp_params.visualizers(n).params, this);
    
end


%%%%  START SIGNAL SOURCE AND STATE GENERATOR

% Start timer
exp_timer = tic();

% Start recieving data
this.sigsrc_stage.proc_obj.start_recv();

% Start task generator
t = toc(exp_timer);
this.stategen_stage.proc_obj.start(t);


%%%%  PERFORM RECIEVING AND PROCESSING

exp_start_time = toc(exp_timer);

% Main cycle
%try
    
    while 1

        % Check if experiment time has finished
        dt = (toc(exp_timer) - exp_start_time);
        if dt > this.exp_params.exp_duration_t
            break;
        end
        
        % Visualize previous data & state
        for n = 1 : length(this.visualizers)
            if ~isempty(this.visualizers{n})
                this.visualizers{n}.visualize();
            end
        end
        
        % Get signal from source
        this.sigsrc_stage.do_work();
        
        % Get state vector
        this.stategen_stage.do_work();
        
        % Perform processing steps
        for n = 1 : length(this.sigproc_graph.stage_order)       
            
            stage_num = this.sigproc_graph.stage_order(n);
            
            % Process signal
            this.sigproc_graph.stages(stage_num).do_work();
            
            % Process state vector
            this.stateproc_graph.stages(stage_num).do_work();
            
        end
        
    end
    
%catch
    
    %fprintf('Critical error: %s\n', lasterr);
    
%end

%{
%fpath_out = 'C:\WORK\bci\DATA\exp_out_2_rep.mat';
data = exp.recv_man.buf_eeg;
states = exp.stategen.buf;
states_pred = exp.sigproc_chain{end}.buf;
states2 = exp.stateproc_chain{end}.buf;
save(exp.fpath_result, 'data', 'states', 'states_pred', 'states2');
%}

% Terminate visualization
for n = 1 : length(this.visualizers)
    try
        this.visualizers{n}.proc_obj.finish();
    end
end

LDA_stage = -1;


for i = 1:length(this.sigproc_graph.stages)
    if(strcmp(this.sigproc_graph.stages(i).stage_name,'LDA'))
        LDA_stage = i;
    end
end

log_write('LDA stage num = %f\n', LDA_stage);

states_predicted = this.sigproc_graph.stages(LDA_stage).buf_out.data(1,:);
states_true = this.stateproc_graph.stages(LDA_stage).buf_out.data;

states_true = states_true(states_true ~= 0);
states_predicted = states_predicted(states_true ~= 0);

pred_ok = mean(states_true == states_predicted);



confM = confusionmat(states_true,states_predicted);

log_write('>>>>> Correct =  %f\n', pred_ok);
log_write('>>>>> Confusion matrix: \n ')
%log_write(confM);

disp(confM);




% Calculate confusion matrix
%{
states = this.stategen_stage.buf_out;
states2 = this.sigproc_graph.stages(this.sigproc_graph.stage_order(length(this.sigproc_graph.stage_order))).buf_out.data(1,:);
states3 = this.stateproc_graph.stages(this.stateproc_graph.stage_order(length(this.stateproc_graph.stage_order))).buf_out.data;

disp(states);

disp(states2);
disp(states3);

confM = confusionmat(states2,states3);

disp(confM);
%}

end

