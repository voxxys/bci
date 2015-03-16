classdef t_stategen_stage < handle
% Processing stage: state generator

    % Parameters
    properties (SetAccess=private, GetAccess=public)
        
        % Name of processing stage
        stage_name;
        
        % Name of class of object that performs this stage
        obj_type;
        
        % Parameters of processing
        % params.params_base - common
        % params.params_spec - class-specific
        % params.buf_out_desc - parameters of output buffer
        params;
        
        % Signal source stage object from which we can get markers
        sigsrc_stage_obj;
        
    end
    
    % Properties that are initialized during init() call
    properties (SetAccess=private, GetAccess=public)
        
        % Is initialized
        ready;
        
        % Object that performs this stage
        proc_obj;
        
        % Output buffers
        buf_out;
        
    end
    
    methods
        
        %===================================
        % Constructor
        function this = t_stategen_stage(stage_name)
            
            this.ready = 0;
            
            if exist('stage_name', 'var')
                this.stage_name = stage_name;
            else
                this.stage_name = 'UNNAMED_STAGE';
            end
            
        end
        
        %===================================
        % Initialize processing stage
        init(this, obj_type, params);
        
        %===================================
        % Set sinal source to take data & markers from
        function set_sigsrc_stage(this, sigsrc_stage_obj)
            this.sigsrc_stage_obj = sigsrc_stage_obj;
        end
        
        %===================================
        % Print parameters
        function print_params(this)
        end
        
        %===================================
        % Perform processing
        function do_work(this)
             this.proc_obj.get_state_vec(this.sigsrc_stage_obj.buf_eeg, this.sigsrc_stage_obj.buf_mark, this.buf_out);
        end
        
        %===================================
        % Destroy output buffer
        function destroy_buf(this)
            this.buf_out.free();
            this.ready = 0;
        end
        
    end
    
    %{
    methods
        
        function this = set.obj_type(this, obj_type)
           assert(this.ready == 0);
           this.obj_type = obj_type;
        end
        
        function this = set.params(this, params)
           assert(this.ready == 0);
           this.params = params;
        end
        
    end
    %}
    
end

