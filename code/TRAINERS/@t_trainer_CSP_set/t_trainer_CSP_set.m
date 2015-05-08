classdef t_trainer_CSP_set < t_trainer_base
% Train parameters of CSP
% Class to use with: t_sigproc_spatfilt

    properties
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_trainer_CSP_set(name)
            this = this@t_trainer_base(name);
        end
        
    end
    
    methods (Access=protected)

        %===================================
        % Perform class-specific training
        params = train_spec(this, buf_data, buf_states, params, train_params);
        
    end
    
    methods (Access=private)
        
        %===================================
        % Visualize training results
        visualize(this, data1_cur, data2_cur, params, train_params);

    end
    
end

