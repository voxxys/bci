classdef t_sample_buf < handle
    
    %properties (SetAccess=private, GetAccess=private)
    properties (SetAccess=public, GetAccess=public)
        
        buf_name;
        srate;
        chan_names;
        buf_type;           % 'ring' / 'linear'
        ready;        
        
        sample_idx;
        data;
        
        pos_first;
        pos_last;
        sz_used;
        
    end
    
    methods (Access = public)
        
        %===================================
        % Constructor
        function obj = t_sample_buf(buf_name)
            obj.buf_name = buf_name;
            obj.ready = 0;
        end

        %===================================
        % Allocate memory
        allocate(obj, chan_names, nsamples, buf_type, srate);
        
        %===================================
        % Free memory
        function free(obj)
            obj.sample_idx = [];
            obj.data = [];
            obj.ready = 0;
            log_write('>>>>> %s -> FREE BUFFER\n', obj.buf_name);
        end
        
        
        %===================================
        % Add data to buffer
        append(obj, sample_idx_new, data_new);
        
        %===================================
        % Get last data from buffer
        function [data_out, sample_idx_out] = get_last_data(obj, data_sz)
            
            data_sz = min(data_sz, obj.sz_used);
            
            % Position of last sample to output
            pos2 = obj.pos_last;
            
            % Position of first sample of output
            if pos2 >= data_sz
                pos1 = pos2 - data_sz + 1;
            else
                pos1 = length(obj.sample_idx) - (data_sz - pos2) + 1;
            end
            
            % Index of first sample to output
            sample_id_first = obj.sample_idx(pos1);
            
            % Get data
            [data_out, sample_idx_out] = obj.get_data(sample_id_first, data_sz);
            
        end
        
        %===================================
        % Get data from buffer
        [data_out, sample_idx_out] = get_data(obj, sample_id_first, data_sz, nsamples_prev);
        
    end
    
    methods (Access = public)        
        
        % Get names of channels
        function chan_names = get_chan_names(obj)
            assert(obj.ready == 1);
            chan_names = obj.chan_names;
        end
        
        % Get number of channels
        function nchans = get_num_channels(obj)
            assert(obj.ready == 1);
            nchans = length(obj.chan_names);
        end
        
        % Get number of channel by name
        function chan_id = chan_by_name(obj, chan_name)
            assert(obj.ready == 1);
            chan_id = find(strcmp(obj.chan_names, chan_name));
            assert(length(chan_id) == 1);
        end
        
        % Get maximum size of buffer
        function sz_max = get_sz_max(obj)
            assert(obj.ready == 1);
            sz_max = length(obj.sample_idx);
        end
        
        % Get number of samples in buffer
        function sz_used = get_sz_used(obj)
            assert(obj.ready == 1);
            sz_used = obj.sz_used;
        end
        
        % Get number of last sample in the buffer or zero if buffer is empty
        function id = get_last_sample_id(obj)
            assert(obj.ready == 1);
            if obj.sz_used == 0
                id = 0;
            else
                id = obj.sample_idx(obj.pos_last);
            end
        end
        
        % Get length of buffer in samples (==get_sz_max)
        function len = get_buf_len(obj)
            len = size(obj.data,2);
        end
        
        % Get length of buffer in seconds
        function len_t = get_buf_len_t(obj)
            len_t = size(obj.data,2) / obj.srate;
        end
            
    end
    
    
end

