classdef t_eeg_recv_manager_buf < t_eeg_recv_manager_base
% Reads data from buffer
    
    properties (SetAccess=private)
        
        % DESCRIPRION OF CLASS-SPECIFIC PARAMETERS
        % params.params_spec.buf
        
    end
    
    methods (Access=protected)
        
        %===================================
        function init_spec(this)
        end
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_eeg_recv_manager_buf(name)
            this = this@t_eeg_recv_manager_base(name);
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(this)
            nchan_eeg = length(this.params.params_spec.buf.chan_names);
            nchan_mark = 1;
        end
        
        %===================================
        function srate = get_srate(this)
            srate = this.params.params_spec.buf.srate;
        end       
        
        %===================================
        function chan_names = get_chan_names_out(this)
            chan_names = this.params.params_spec.buf.chan_names;
        end       
        
        %===================================
        function chan_names = get_mark_chan_names_out(this)
            chan_names = {'MARKERS'};
        end
        
        %===================================
        function start_recv(this)
        end
        
        %===================================
        function stop_recv(this)
        end  
        
        %===================================
        function restart(this)
        end  
        
        %===================================
        function nsamples_recv = recv_data(this, buf_eeg, buf_mark)
            
            [data, sample_idx] = this.params.params_spec.buf.get_data();
            nsamples_recv = length(sample_idx);
            
            data_mark = zeros(1,nsamples_recv);
            
            buf_eeg.append(sample_idx, data);
            buf_mark.append(sample_idx, data_mark);
            
        end
        
    end
    
end

