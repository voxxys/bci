classdef t_train_manager < handle
% Performs paradigm training
    
    % Parameters
    properties (SetAccess=private, GetAccess=public)
        
        % Train manager info
        train_info;
        
        % Description of input stage
        sigsrc_stage_desc;
        % Description of state generator stage
        stategen_stage_desc;
        % Descriptions of signal processing stages
        sigproc_stage_descs;
        
    end
        
    properties (SetAccess=private, GetAccess=public)
        
        % Loaded experimental data
        expresult;
        
        % Signal source stage
        sigsrc_stage;
        
        % State generating stage
        stategen_stage;
        
        % Signal & state processing graphs
        sigproc_graph;
        stateproc_graph;
        
    end
    
    methods (Access=private)
        
        %===========================
        % Initialize parameters of stages
        init_params(this, params_outer);
        
        %===========================
        % Initialize stages
        init_stages(this, params_outer);
        
    end
    
    methods (Access=public)
       
        % Train paradigm
        paradigm = train_paradigm(this, trainpar, expresult);
        
    end
    
end

