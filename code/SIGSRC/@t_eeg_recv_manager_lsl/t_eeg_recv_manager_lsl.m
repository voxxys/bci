classdef t_eeg_recv_manager_lsl < t_eeg_recv_manager_base
% Generate test sinusoidal signals
    
    properties (SetAccess=private)
        
        % DESCRIPRION OF PARAMETERS
        % params.params_spec.sig_freqs - frequencies of output signals
        % this.params.params_spec - sampling rate of generated signal
        
        % Timer
        timer;
        
        % Time of last signal request
        last_req_time;
        
        
        % inlet
        inlet;
        
        % LSL information
        inf;
        
    end
    

    % Private
    methods (Access=protected)
        
        %===================================
        function init_spec(this)
            
            % Connect to LSL
            lib = lsl_loadlib();
            disp('Resolving an EEG stream...');
            result = {};
            while isempty(result)
                result = lsl_resolve_byprop(lib,'type','EEG'); end
            disp('Opening an inlet...');
            this.inlet = lsl_inlet(result{1});
            disp('Now receiving data...');
            
            % Get info
            this.inf = this.inlet.info();

        end
        
    end
    
    
    % Public
    methods
        
        %===================================
        function this = t_eeg_recv_manager_lsl(name)
            this = this@t_eeg_recv_manager_base(name);
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(this)
            nchan_eeg = this.inf.channel_count();
            nchan_mark = 1;
        end
        
        %===================================
        function srate = get_srate(this)
            %srate = this.inf.desc().child_value('nominal_srate');
            srate = this.inf.nominal_srate();
        end       
        
        %===================================
        function chan_names = get_chan_names_out(this)            
            ch = this.inf.desc().child('channels').child('channel');
            for k = 1 : this.inf.channel_count()
                chan_names{k} = ch.child_value('label');
                ch = ch.next_sibling();
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
            
            % Clear LSL buffer
            this.inlet.pull_chunk();
            
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

            % Read from LSL            
            [chunk,stamps] = this.inlet.pull_chunk();
            data = chunk;

            %fprintf('%.10f  %.10f\n', max(chunk(:)), min(chunk(:)));
            %fprintf('%.10f  %.10f\n', max(chunk(2,:)), min(chunk(2,:)));

            % Average reference
            %data = bsxfun(@minus, data, mean(data,1));
            %data = bsxfun(@minus, data, data(13,:));
            
            nsamples_recv = size(chunk,2);
            nsig = size(chunk,1);
            
            %disp(t);
            %disp(chunk);
            
            % Generate empty portion of marker data
            mark_data = NaN * ones(1, nsamples_recv);
            
            % Assign indices to received samples
            sample_idx_new = this.nsamples_recv_total + [1 : nsamples_recv];
            
            % Add received data & markers to memory buffers
            buf_eeg.append(sample_idx_new, data); 
            buf_mark.append(sample_idx_new, mark_data);

            % Update number of received samples
            this.nsamples_recv_total = this.nsamples_recv_total + nsamples_recv;

            %disp(nsamples_recv);
            %disp([max(data(:)), min(data(:))]);
            
        end
        
    end
    
end
