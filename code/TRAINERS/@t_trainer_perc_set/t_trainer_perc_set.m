classdef t_trainer_perc_set < t_trainer_base
% Train parameters of LDA
% Class to use with: t_statepred_LDA
    
    properties
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_trainer_perc_set(name)
            this = this@t_trainer_base(name);
        end
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Perform class-specific training

        params = train_spec(this, buf_data, buf_states, params, train_params);
        
    end
    
end

