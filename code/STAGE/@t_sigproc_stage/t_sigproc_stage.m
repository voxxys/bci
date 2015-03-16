classdef t_sigproc_stage < handle
% Signal processing stage

    % Parameters
    properties (SetAccess=private, GetAccess=public)

        % Name of processing stage
        stage_name;
        
        % Name of class of object that performs this stage
        obj_type;
        
        % Parameters of processing
        % params.inp_descs - descriptors of inputs
        % params.params_base - common
        % params.params_spec - class-specific
        % params.buf_out_desc - parameters of output buffer
        params;
        
        % References to the input buffers
        bufs_in;
        
    end
    
    % Properties that are initialized during init() call
    properties (SetAccess=private, GetAccess=public)        
        
        % Is initialized
        ready;
        
        % Object that performs this stage
        proc_obj;
        
        % Output buffer
        buf_out;
        
    end
    
    methods
        
        %===================================
        % Constructor
        function this = t_sigproc_stage(stage_name)
            
            this.ready = 0;
            
            if exist('stage_name', 'var')
                this.stage_name = stage_name;
            else
                this.stage_name = 'UNNAMED_STAGE';
            end
            
        end
        
        %===================================
        % Initialize processing stage
        init(this, obj_type, params, bufs_in);        
        
        %===================================
        % Print parameters
        print_params(this);
        
        %===================================
        % Perform processing
        function do_work(this)
            this.proc_obj.do_work();
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
        
        function this = set.bufs_in(this, bufs_in)
           assert(this.ready == 0);
           this.bufs_in = bufs_in;
        end
        
    end
    %}
    
end

