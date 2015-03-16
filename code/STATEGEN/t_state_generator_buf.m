classdef t_state_generator_buf < t_state_generator
% Generate state labels from input markers
    
    properties (SetAccess=private, GetAccess=public)

        % DESCRIPTION OF CLASS-SPECIIC PARAMETERS
        % params.params_spec.buf
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_state_generator_buf(name)
            this = this@t_state_generator(name);
        end
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        function init_spec(this)
        end
        
        %===================================
        % Class-specific convertion of eeg+markers to states
        function [data_states, state_id_cur_new] = get_statevec_spec(this, sample_idx, data_eeg, data_mark)
            
            [data_states, sample_idx_data] = this.params.params_spec.buf.get_data();
            
            assert(size(data_states,1) == 1);
            %assert(same(sample_idx_data, sample_idx) > 0);
            assert(all(sample_idx_data == sample_idx) == 1);
            
            state_id_cur_new = data_states(end);
            
        end
        
    end
    
end

