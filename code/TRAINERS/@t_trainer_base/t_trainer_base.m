classdef t_trainer_base < handle
% Base class for training processing stage

    % Properties that are initialized during init() call
    properties (SetAccess=private, GetAccess=public)
        
        % Name of object
        name;
        
        % Signal processing stage for resampling and collecting input data
        sigproc_stage;
        
        % State processing stage for resampling state vector
        stateproc_stage;
        
        % Object that resamples and combines inputs (bufs_in -> buf_out)
        inp_proc_obj;
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_trainer_base(name)
            this.name = name;            
        end
        
        %===================================
        % Initialize trainer
        init(this, stage_desc, bufs_in_data, bufs_in_states);        
        
        %===================================
        % Perform processing
        function params = train(this, params, train_params)
            
            % Combine and resample input data
            this.sigproc_stage.do_work();
            
            % Resample input state vector
            this.stateproc_stage.do_work();
            
            % Perform class-specific training using combined and resampled
            % input signal and state data
            buf_data = this.sigproc_stage.buf_out;
            buf_states = this.stateproc_stage.buf_out;
            params = this.train_spec(buf_data, buf_states, params, train_params);
            
        end

    end
    
    methods (Access=protected)
    
        function params = train_spec(this, buf_data, buf_states, params, train_params)            
            fprintf('t_trainer_base::train_spec() must be reimplemented in child class\n');
            assert(0==1);            
        end
        
    end
    
end

