classdef t_sigproc_winpow < t_sigproc_base
% Calculate average signal power in a time window preceding each sample
    
    properties
        
        % DESCRIPTION OF CLASS-SPECIFIC PARAMETERS
        % <nothing>
        
    end
    
    methods
        
        %===================================
        % Constructor
        function this = t_sigproc_winpow(name)
            this = this@t_sigproc_base(name);
        end
        
    end
    
    methods (Access = protected)
        
        %===================================
        % Class-specific initialization
        init_spec(obj);
        
        %===================================
        % Process data with original sampling rate as a whole
        data_out = proc_seq_fsin_spec(obj, sample_idx_in, data_in, inp_num);
        
    end
    
end

