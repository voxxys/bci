classdef t_state_generator_binary < t_state_generator
% Generate binary sequence of labels, switch label periodically
    
    properties (SetAccess=private, GetAccess=public)

        % DESCRIPTION OF CLASS-SPECIFIC PARAMETERS
        % params.params_spec.T - interval between state switches (sec)
        
        % Time of last state switch
        t_switch = [];
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_state_generator_binary(name)
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
            
            state_id_cur_new = this.state_id_cur;
            
            t = toc(this.exp_timer);
            dt = t - this.t_switch;
            
            if isempty(this.t_switch) || (dt > this.params.params_spec.T)
                
                this.t_switch = t;
                
                assert((this.state_id_cur==1) || (this.state_id_cur==2));
                
                if this.state_id_cur == 1
                    state_id_cur_new = 2;
                else
                    state_id_cur_new = 1;
                end
                
            end
            
            % Create output data
            data_states = state_id_cur_new * ones(1,length(sample_idx));
            
        end
        
    end
    
end

