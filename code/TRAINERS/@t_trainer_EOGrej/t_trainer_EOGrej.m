classdef t_trainer_EOGrej < t_trainer_base
% Trains parameters of EOG rejection
% Class to use with: t_sigproc_spatfilt
    
    properties
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_trainer_EOGrej(name)
            this = this@t_trainer_base(name);
        end
        
    end
    
    methods (Access=protected)

        %===================================
        % Perform class-specific training
        params = train_spec(this, buf_data, buf_states, params, train_params);
        
        %===================================
        % Visualize training results
        visualize(this, W, X, params, train_params)
        
    end
    
end

