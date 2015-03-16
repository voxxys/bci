classdef t_state_generator_mark < t_state_generator
% Generate state labels from input markers
    
    properties (SetAccess=private, GetAccess=public)

        % DESCRIPTION OF CLASS-SPECIIC PARAMETERS
        % params.params_spec.state_markers - marker values that correspond to the states
        % length(params.params_spec.state_markers) == length(this.params.params_base.state_descs)
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_state_generator_mark(name)
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
            
            % Allocate memory for output data
            data_states = zeros(1,length(sample_idx));
            
            % List of markers that correspond to used states
            statedesc_marks = this.params.params_spec.state_markers;
            
            % Indices of states that correspond to input samples (empty if no match found)
            sample_state_idx = arrayfun(@(x)find(x==statedesc_marks), data_mark, 'UniformOutput', false);
            
            % Positions of samples in marker buffer that correspond to one of the used states
            markstate_pos_vec = find(cellfun(@(s)~isempty(s), sample_state_idx));
            
            % Indices of states that correspond to input samples (only if match found)
            markstate_idx = [sample_state_idx{:}];
            
            % "Change" to current state at first sample
            markstate_pos_vec = [1, markstate_pos_vec];
            markstate_idx = [this.state_id_cur, markstate_idx];
            
            % Labels of states that correspond to input samples (only if match found)
            %markstate_labels = [this.params.state_descs(markstate_idx).label];
            
            state_id_cur_new = this.state_id_cur;
            
            % Cycle over all interval between state changes
            markstate_pos_vec = [markstate_pos_vec, length(sample_idx)];    % trick to process last interval with the same code
            for n = 1 : (length(markstate_pos_vec)-1)
                state_id_cur_new = markstate_idx(n);
                pos1 = markstate_pos_vec(n);
                pos2 = markstate_pos_vec(n+1);
                data_states(pos1:pos2) = this.params.params_base.state_descs(state_id_cur_new).label;
            end
            
        end
        
    end
    
end

