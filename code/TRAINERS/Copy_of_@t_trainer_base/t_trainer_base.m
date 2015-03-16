classdef t_trainer_base < handle
% Base class for training processing stage

    % Properties that are initialized during init() call
    properties (SetAccess=private, GetAccess=public)
        
        % Name of object
        name;
        
        % References to the input buffers
        bufs_in;
        
        % Buffer with combined inputs (output of inp_proc_obj)
        buf_total;
        
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
        init(this, bufs_in, stage_desc);        
        
        %===================================
        % Perform processing
        function params = train(this, params, train_params)
            
            % Combine data from bufs_in and store it in buf_total
            this.inp_proc_obj.do_work();
            
            params = train_spec(params, train_params);
            
        end

    end
    
    methods (Access=protected)
    
        function params = train_spec(this, params, train_params)            
            fprintf('t_trainer_base::train_spec() must be reimplemented in child class\n');
            assert(0==1);            
        end
        
    end
    
end

