classdef t_state_generator_6states_rand_3 < t_state_generator
% Generate binary sequence of labels, switch label periodically
    
    properties (SetAccess=private, GetAccess=public)

        % DESCRIPTION OF CLASS-SPECIFIC PARAMETERS
        % params.params_spec.T - interval between state switches (sec)
        
        % Time of last state switch
        t_switch = [];
%         states_vec = [     6     5     5     6     3     3     6     2     2     6     1     1     6     3     3     6     4     4     6     3     3     6     5     5     6     1     1     6     5     5     6     4     4     6     5     5     6     3     3     6     2     2     6     5     5     6     1     1     6     2     2     6     4     4     6     1     1     6     2     2     6     3     3     6     4     4     6     2     2     6     5     5     6     1     1     6     2     2     6     4     4     6     3     3     6     1     1     6     4     4];
        states_vec = [6     5     5    6     2     2     6     1     1    6     5     5     6     1     1     6     5     5    6     5     5    6     2     2     6     5     5     6     1     1     6     2     2    6     1     1     6     2     2    6    2     2     6     5     5     6     1     1     6     2     2    6     1     1     6]
        cur_state = 0; 
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_state_generator_6states_rand_3(name)
            
            this = this@t_state_generator(name);
        end
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        function init_spec(this)
            this.states_vec = [this.states_vec,  this.states_vec];
%             stvec2 = 6*ones(1,60);
%             stvec2(2:2:end) = this.states_vec;
%             this.states_vec = stvec2;

        end
        
        %===================================
        % Class-specific convertion of eeg+markers to states
        function [data_states, state_id_cur_new] = get_statevec_spec(this, sample_idx, data_eeg, data_mark)
            
            state_id_cur_new = this.state_id_cur;
            
            t = toc(this.exp_timer);
            dt = t - this.t_switch;
            
            if isempty(this.t_switch) || (dt > this.params.params_spec.T)
                
                this.t_switch = t;
                
                this.cur_state = this.cur_state+1;
                if(this.cur_state > 110)
                    this.cur_state = 1;
                end
                
                state_id_cur_new = this.states_vec(this.cur_state);
                
                
            end
            
            % Create output data
            data_states = state_id_cur_new * ones(1,length(sample_idx));
            
        end
        
    end
    
end

