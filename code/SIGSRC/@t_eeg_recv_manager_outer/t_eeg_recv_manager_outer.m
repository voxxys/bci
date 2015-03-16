classdef t_eeg_recv_manager_outer < t_eeg_recv_manager_base
% Reads data from t_eeg_recv_manager_NVX object created elsewhere
    
    properties (SetAccess=private)
        
        % DESCRIPRION OF CLASS-SPECIFIC PARAMETERS
        % params.params_base.recv_obj_name - name of recieving object in global workspace
        
        % Recieving object (t_eeg_recv_manager_...)
        recv_obj;
        
    end
    
    methods (Access=protected)
        
        %===================================
        function init_spec(this)
            
            % Get recieving object from global workspace
            recv_obj_name = this.params.recv_obj_name;
            eval(sprintf('global %s; this.recv_obj = %s;', recv_obj_name, recv_obj_name));
            
        end
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_eeg_recv_manager_outer(name)
            this = this@t_eeg_recv_manager_base(name);
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(this)
            [nchan_eeg, nchan_mark] = this.recv_obj.get_nchans();
        end
        
        %===================================
        function srate = get_srate(this)
            srate = this.recv_obj.get_srate();
        end       
        
        %===================================
        function chan_names = get_chan_names_out(this)
            chan_names = this.recv_obj.get_chan_names_out();
        end       
        
        %===================================
        function chan_names = get_mark_chan_names_out(this)
            chan_names = this.recv_obj.get_mark_chan_names_out();
        end
        
        %===================================
        function start_recv(this)
            this.recv_obj.restart();
        end
        
        %===================================
        function stop_recv(this)
        end  
        
        %===================================
        function restart(this)
            this.recv_obj.restart();
        end  
        
        %===================================
        function nsamples_recv = recv_data(this, buf_eeg, buf_mark)
            nsamples_recv = this.recv_obj.recv_data(buf_eeg, buf_mark);
        end
        
    end
    
end

