classdef t_statepred_rieman < t_sigproc_base
% Predicts a state by the sign of the difference of 2 channels
    
    properties (Access = protected)
        
        % DESCRIPTION OF CLASS-SPECIFIC PARAMETERS
        % params.params_spec.state_labels = [L1,L2] - labels of two states to predict
        
    end
    
    methods
        
        %===================================
        % Constructor
        function this = t_statepred_rieman(name)
            this = this@t_sigproc_base(name);
        end
        
    end
    
    methods (Access = protected)
        
        %===================================
        % Class-specific initialization
        init_spec(this);
        
        %===================================
        % Process data with output sampling rate
        data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in);
        
    end
    
end


