classdef t_eeg_recv_manager_file < t_eeg_recv_manager_base
% Reads EEG data from eeglab dataset
    
    
    properties (SetAccess=private)
        
        % DESCRIPRION OF CLASS-SPECIFIC PARAMETERS
        % params.params_spec.fpath_in - path to the input EEGLAB dataset file
        % params.params_spec.mode = 'realtime' | 'block'
        % 'realtime' - data gets available according to sampling rate
        % 'block' - returns a block of a fixed size at each request
        % params.params_spec.out_block_sz - size of output block in 'block' mode
        % params.params_spec.time_mult - time multiplier in 'realtime' mode
        
        % EEGLAB structure with input data
        EEG = [];
        
        % Current position in a dataset
        dataset_pos_cur = 0;
        
        % Timer
        timer;

        % Time of last data reqest
        last_req_time = 0;
        
    end
    
    % Private
    methods (Access=protected)
        
        %===================================
        init_spec(this);
        
    end    
    
    % Public
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_eeg_recv_manager_file(name)
            this = this@t_eeg_recv_manager_base(name);
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(this)
            nchan_eeg = size(this.EEG.data,1);
            nchan_mark = 1;
        end
        
        %===================================
        function srate = get_srate(this)
            srate = this.EEG.srate * this.params.params_spec.time_mult;
        end       
        
        %===================================
        function chan_names = get_chan_names_out(this)
            chan_names = {this.EEG.chanlocs.labels};
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
            this.dataset_pos_cur = 1;
            this.start_recv();
        end        
        
        %===================================
        nsamples_recv = recv_data(this, buf_eeg, buf_mark);
        
    end
    
end

