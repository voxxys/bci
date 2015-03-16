classdef t_sigproc_spatfilt < t_sigproc_base
% Apply a set of spatial filters

    properties (SetAccess=private, GetAccess=private)
        
        % DESCRIPTION OF CLASS-SPECIFIC PARAMETERS
        % params.params_spec.filt_names - names of filters
        % params.params_spec.M - filter matrix (filters x channels)
        
        % Indices of input channels to filter (in the array of combined inputs)
        chan_idx_in_filt;
        
    end
    
    methods
        
        %===================================
        % Constructor
        function this = t_sigproc_spatfilt(name)
            this = this@t_sigproc_base(name);
        end
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        init_spec(this);
       
        %===================================
        % Process downsampled data
        data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in);
        
    end
    
end

