classdef t_state_generator_null < t_state_generator
% Generate sequence of identical markers
    
    properties (SetAccess=private, GetAccess=public)
    end
    
    methods (Access=protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        function init_spec(obj)
        end
        
        %===================================
        % Class-specific convertion of eeg+markers to states
        function [data_states, state_id_cur_new] = get_statevec_spec(obj, sample_idx, data_eeg, data_mark)
            
            state_id_cur_new = obj.state_id_cur;
            
            % Create output data
            data_states = state_id_cur_new * ones(1,length(sample_idx));
            
        end
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function obj = t_state_generator_null(name)
            obj = obj@t_state_generator(name);
        end
        
    end
    
end

