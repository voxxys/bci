classdef t_state_generator < handle
% Generates "true" state labels and sends markers to NVX
    
    properties (SetAccess=protected, GetAccess=public)
        
        % Name
        name;
        
        % DESCRIPTION OF PARAMETERS
        % params.params_base.state_descs - list of descriptors of used states
        % params.params_base.state_descs(n).label - label of n-th state that will be written to state buffer
        % params.params_base.state_descs(n).name - name of n-th state
        % params.params_base.state_id_def - index of default state in state_descs list
        
        % Parameters
        params;
        
        % Experiment start time
        t_start;
        
        % Timer
        exp_timer;
        
        % Index of current state in params.params_base.state_descs list
        state_id_cur;
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        function init_spec(this)
        end
        
        %===================================
        % Class-specific state getting code (can use eeg+markers to generate states or ignore this data)
        function [data_states, state_id_cur_new] = get_statevec_spec(this, sample_idx, data_eeg, data_mark)
            assert(0==1);
        end
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_state_generator(name)
            this.name = name;
        end
        
        %===================================
        % Object initialization (function of parent class) 
        function params_out = init(this, params_)
            
            this.params = params_;
            
            state_id_cur = [];
            
            % Call class-specific init function
            this.init_spec();
            
            % Default state becomes current one
            this.state_id_cur = this.params.params_base.state_id_def;
            
            % State list must contain at least one state
            if isempty(this.params.params_base.state_descs)
            	log_write('[%s] t_state_generator::init() -> state list is empty - ERROR\n', name);
                assert(0==1); 
            end
            
            % If current state not specified - first state becomes current
            if isempty(this.state_id_cur)
                this.state_id_cur = 1;
            end
            
            params_out = this.params;
          
        end        
        
        %===================================
        % Start timer
        function start(this, tstart)
            %global exp_timer;
            %this.t_start = toc(exp_timer);
            this.t_start = tstart;
            this.exp_timer = tic();
        end
        
        %===================================
        % Get vector of state labels that correspond to samples obtained from reciever
        % (must be implemented in child class)
        function get_state_vec(this, buf_eeg, buf_mark, buf_states)
            
            % Check sampling rate
            assert(buf_eeg.srate == buf_states.srate);
            assert(buf_mark.srate == buf_states.srate);
            
            % Get number of last sample in state buffer
            state_sample_id_last = buf_states.get_last_sample_id();
            
            % Get samples from eeg & marker buffers that are not contained in state buffer
            [data_eeg, sample_idx_eeg] = buf_eeg.get_data(state_sample_id_last + 1);
            [data_mark, sample_idx_mark] = buf_mark.get_data(state_sample_id_last + 1);
            assert(length(sample_idx_eeg) == length(sample_idx_mark));
            
            %%%%  Class-specific state getting code (can use eeg+markers to generate states or ignore this data)
            [data_states, state_id_cur_new] = this.get_statevec_spec(sample_idx_eeg, data_eeg, data_mark);
            
            % Write new data to state buffer
            buf_states.append(sample_idx_eeg, data_states);
            
            % Update current state
            this.state_id_cur = state_id_cur_new;
            
        end
        
        %===================================
        % Get current state
        function [state_name, state_label] = get_cur_state(this)
            
            state_name = this.params.params_base.state_descs(this.state_id_cur).name;
            state_label = this.params.params_base.state_descs(this.state_id_cur).label;
            
        end
        
    end
    
end

