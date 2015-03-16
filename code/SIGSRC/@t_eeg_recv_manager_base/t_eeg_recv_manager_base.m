classdef t_eeg_recv_manager_base < handle
% Base class for reading EEG data from some source


    properties (SetAccess=protected)
        
        % Name
        name;
        
        % Parameters
        params;
        
        % Total number of recieved samples
        nsamples_recv_total;      
        
        % Here we store info about errors (str, nsamples, time)
        err_log;
        
    end
    

    % Private
    methods (Access=protected)
        
        %==========================================
        function err_log_add(err_str)
            fprintf(['>>>> ERROR: ' err_str '\n']);
            global exp_timer;
            err_log{end+1} = struct('str', err_str,...
                'nsamples', nsamples_recv_total, 'time', toc(exp_timer));
        end
        
        %===================================
        function init_spec(this)
        end        
        
    end
    
    
    % Public
    methods (Access=public)
        
        %===================================
        function this = t_eeg_recv_manager_base(name)
            this.name = name;
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(this)
            fprintf('t_eeg_recv_manager::get_nchans() has no implementation\n');
            assert(1==0);
        end
        
        %===================================
        function srate = get_srate(this)
            fprintf('t_eeg_recv_manager::get_srate() has no implementation\n');
            assert(1==0);
        end       
        
        %===================================
        function chan_names = get_chan_names_out(this)
            fprintf('t_eeg_recv_manager::get_chan_names_out() has no implementation\n');
            assert(1==0);
        end       
        
        %===================================
        function chan_names = get_mark_chan_names_out(this)
            fprintf('t_eeg_recv_manager::get_mark_chan_names_out() has no implementation\n');
            assert(1==0);
        end
      
        %===================================
        function params_out = init(this, params_)
            
            this.params = params_;
            
            % Perform class-specific initialization
            this.init_spec();

            this.nsamples_recv_total = 0;
            this.err_log = {};
            
            % Get output sampling rate and channel names
            this.params.params_base.srate_out = this.get_srate();
            this.params.params_base.chan_names_out = this.get_chan_names_out();
            
            params_out = this.params;
            
        end
        
        
        %===================================
        function start_recv(this)
            fprintf('t_eeg_recv_manager::start_recv() has no implementation\n');
            assert(1==0);
        end
        
        %===================================
        function stop_recv(this)
            fprintf('t_eeg_recv_manager::stop_recv() has no implementation\n');
            assert(1==0);
        end
        
        %===================================
        function restart(this)            
            fprintf('t_eeg_recv_manager::restart() has no implementation\n');
            assert(1==0);
        end  
        
        
        %===================================
        function nsamples_recv = recv_data(this, buf_eeg, buf_mark)
        % Reads EEG samples & markers from input source
        % buf_eeg and buf_markers are t_sample_buf objects
        % Size of buffers: buf_eeg(nchans_eeg,nsamples_max)
        % Size of buffers: buf_mark(nchans_mark,nsamples_max)
        % nsamples_recv - number of samples read
        % nsamples_recv_total <- nsamples_recv_total + nsamples_recv
    
            fprintf('t_eeg_recv_manager::recv_data() has no implementation\n');
            assert(1==0);

        end
        
    end
    
end

