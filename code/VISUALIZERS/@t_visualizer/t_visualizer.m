classdef t_visualizer < handle

    properties (SetAccess=protected, GetAccess=public)
        
        % DESCRIPTION OF PARAMETERS
        % params.fig_num - number of figure window to draw at
        % params.sig_descs{n}.data_type - 'SIGNAL' | 'STATE'
        % params.sig_descs{n}.stage_name - name of stage used as data source; '[INPUT]' means that sigsrc_stage or stategen_stage will be used
        
        % Parameters
        params;
        
        % Experiment object
        exp;
        
        % Name
        name;
        
        % Input buffers
        bufs_in;
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Get buffer by input type ('SIGNAL' / 'STATE'), stage name ('[INPUT]' / some name), and (optionally) buffer name
        buf = get_exp_buf(this, data_type, stage_name, buf_name);
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        function init_spec(this)
        end
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_visualizer(name)
            this.name = name;
            this.bufs_in = t_sample_buf.empty(0);
        end
        
        %===================================
        % Object initialization (function of parent class) 
        function params_out = init(this, params_, exp_)
            
            this.params = params_;
            this.exp = exp_;
            
            % Call class-specific init function
            this.init_spec();

            params_out = this.params;
          
        end  
        
        %===================================
        % Perform visualization
        function visualize(this)
        end
        
        %===================================
        % Finish visualization
        function finish(this)
            
            % Close figure
            if ishandle(this.params.fig_num)
                close(this.params.fig_num);
            end
            
        end 
        
    end
    
end

