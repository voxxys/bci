classdef t_trainer_SSD < t_trainer_base
% Train parameters of SSD
% Class to use with: t_sigproc_spatfilt

    properties
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_trainer_SSD(name)
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

