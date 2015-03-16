classdef t_sigproc_iir < t_sigproc_base
% Performs temporal filtering of signal using IIR filter
    
    properties (SetAccess=private, GetAccess=private)
        
        % CLASS-SPECIFIC PARAMETERS
        % params.params_spec.freq_bands - list of frequency bands
        % params.params_spec.freq_bands{n} = [fmin, fmax] - frequency band for n-th input
        % fmin==0 - lowpass filter
        % fmax==Inf - highpass filter
        % params.params_spec.filt_order - order of filter
        % params.params_spec.chan_out_postfixes - postfixes added to output channels names
        % params.params_spec.chan_out_postfixes{n} - postfix added to output channels names for n-th input
        % params.params_spec.need_append_channames - do we need to add frequency limits to output channel names
        
        % Coefficients of filters
        % size(bandfilt_coeffs) == (number of inputs, number of bands)
        % bandfilt_coeffs{n,m} = struct('a_low', 'b_low', 'a_high', 'b_high')
        % a_low, b_low - coefficients of lowpass filter
        % a_high, b_high - coefficients of highpass filter
        bandfilt_coeffs;
        
        % Parameters of last filter call use to pass to the next filter call
        % to avoid step artifacts
        % size(Zlast,1) == length(params.freq_bands)
        % size(Zlast,2) == (number of inputs)
        % size(Zlast,3) == 2  [1 - filter(a_low,b_low), 2 - filter(a_high,b_high)]
        Zlast;
        
    end
    
    methods
        
        %===================================
        % Constructor
        function this = t_sigproc_iir(name)
            this = this@t_sigproc_base(name);
        end
        
    end
    
    methods (Access = protected)
        
        %===================================
        % Class-specific initialization
        init_spec(this);
        
        %===================================
        % Process data with original sampling rate as a whole
        data_out = proc_seq_fsin_spec(this, sample_idx_in, data_in, inp_num);
        
    end
    
end

