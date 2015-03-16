classdef t_exp_performer < handle
   
    % Parameters
    properties (SetAccess=private, GetAccess=public)
        
        % Experiment info
        exp_info;        
        % Experiment parameters
        exp_params;
        
        % Description of input stage
        sigsrc_stage_desc;
        % Description of state generator stage
        stategen_stage_desc;
        % Descriptions of signal processing stages
        sigproc_stage_descs;
        
    end
        
    properties (SetAccess=private, GetAccess=public)
        
        % Signal source stage
        sigsrc_stage;
        
        % State generating stage
        stategen_stage;
        
        % Signal & state processing graphs
        sigproc_graph;
        stateproc_graph;
        
        visualizers;
        
    end
    
    methods (Access=private)
        
        %===========================
        % Initialize parameters of stages
        init_params(this, params_outer);
        
        %===========================
        % Initialize stages
        init_stages(this);
        
    end
    
    methods
        
        %===========================
        % Peform experiment
        perform_exp(this, exp_params);
        
    end
    
end

