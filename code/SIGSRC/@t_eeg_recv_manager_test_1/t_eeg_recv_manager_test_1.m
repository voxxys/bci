classdef t_eeg_recv_manager_test_1 < t_eeg_recv_manager_base
% Generate test sinusoidal signals
    
    properties (SetAccess=private)
        
        % DESCRIPRION OF PARAMETERS
        % params.params_spec.sig_freqs - frequencies of output signals
        % this.params.params_spec - sampling rate of generated signal
        
        % Timer
        timer;
        
        % Time of last signal request
        last_req_time;
        
    end
    

    % Private
    methods (Access=protected)
        
        %===================================
        function init_spec(this)
        end
        
    end
    
    
    % Public
    methods
        
        %===================================
        function this = t_eeg_recv_manager_test_1(name)
            this = this@t_eeg_recv_manager_base(name);
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(this)
            nchan_eeg = length(this.params.params_spec.sig_freqs);
            nchan_mark = 1;
        end
        
        %===================================
        function srate = get_srate(this)
            srate = this.params.params_spec.srate;
        end       
        
        %===================================
        function chan_names = get_chan_names_out(this)
            for n = 1 : length(this.params.params_spec.sig_freqs)
                chan_names{n} = sprintf('CHAN%i', n);
            end
        end       
        
        %===================================
        function chan_names = get_mark_chan_names_out(this)
            chan_names{1} = 'MARK_CHAN_1';
        end
        
        %===================================
        function start_recv(this)
            this.timer = tic();
            this.last_req_time = 0;
        end
        
        %===================================
        function stop_recv(this)
        end
        
        %===================================
        function restart(this)      
            start_recv();
        end        
        
        %===================================
        function nsamples_recv = recv_data(this, buf_eeg, buf_mark)
        % Generate sinusoidal signals
        % buf_eeg and buf_markers are t_sample_buf objects
        % Size of buffers: buf_eeg(nchans_eeg,nsamples_max)
        % Size of buffers: buf_mark(nchans_mark,nsamples_max)
        % nsamples_recv - number of samples read
        % nsamples_recv_total <- nsamples_recv_total + nsamples_recv
    
            % Get current time
            t = toc(this.timer);
        
            srate = this.params.params_base.srate_out;
            tstep = 1 / srate;
            
            % Vector of output sample times
            tvec = [this.last_req_time : tstep : t];
            
            % Number of samples to output
            nsamples_recv = length(tvec);
            
            % Check if there is no data to output
            if nsamples_recv == 0
                return;
            end

            % Store time of last output sample
            if nsamples_recv
                this.last_req_time = tvec(end);
            end
            
            nsig = length(this.params.params_spec.sig_freqs);
            
            % Here we will store EEG & marker data to output
            data = zeros(nsig, nsamples_recv);
            mark_data = ones(1, nsamples_recv);
            
            % Generate signals
            for n = 1 : nsig                
                f = this.params.params_spec.sig_freqs(n);                
                data(n,:) = sin(2*pi*f*tvec);                
            end
   
            % Assign indices to recieved samples
            sample_idx_new = this.nsamples_recv_total + [1 : nsamples_recv];
            
            % Add recieved data & markers to memory buffers
            buf_eeg.append(sample_idx_new, data); 
            buf_mark.append(sample_idx_new, mark_data);

            % Update number of recieved samples
            this.nsamples_recv_total = this.nsamples_recv_total + nsamples_recv;

        end
        
    end
    
end
