classdef t_sigproc_base < handle
% Base class for signal processing
    
    properties (SetAccess=protected, GetAccess=public)
        
        % Name of processing object
        name;
        
        % Parameters
        params;        
        
        ready;
        sample_id_last;     % id of last processed sample
        
        % References to input buffers
        bufs_in;
        
        % Reference to output buffer
        buf_out;
        
        %{
        % Indices of output channels that correspond to input channels
        % chan_map_in_out{inp_num}(chan_id) corresponds to index==chan_id in params.inp_descs(inp_num).chan_names_in
        chan_map_in_out;
        
        % Indices of inputs & input channels that correspond to output channel
        % chan_map_out_in(chan_id,1) - number of input (index in params.inp_descs)
        % chan_map_out_in(chan_id,2) - number of input channel (index in params.inp_descs(chan_id).chan_names_in)
        chan_map_out_in;
        %}
        
    end
    
    methods (Access = protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        function init_spec(this)
        end
        
        %===================================
        % Get names of output channels
        % If params.chan_names_out are not specified in init() argument, this method must be implemented in child class
        %{
        function chan_names_out = get_chan_names_out(this)
            assert(0==1);
        end
        %}
        
        %===================================
        % Process data with original sampling rate as a whole (e.g. temporal filtering)
        function data_out = proc_seq_fsin_spec(this, sample_idx_in, data_in, inp_num)
            % size(data_out,2) == size(data_in,2)
            data_out = data_in;             % TODO: don't duplicate
        end
        
        %===================================
        % Downsample data by processing chunks of input data one by one (e.g. window fourier transformation)
        % Each chunk contains (nprev+1) input samples and corresponds to single output sample
        function data_out = proc_samp_fsin_spec(this, sample_idx_in, data_in, inp_num)
            % size(data_out,2) == 1
            data_out = data_in(:,end);     % TODO: don't duplicate
        end
        
        %===================================
        % Process downsampled data (e.g. spatial filtering)
        function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)
            % size(data_out,2) == size(data_in,2)
            data_out = data_in;             % TODO: don't duplicate
        end
        
    end
    
    methods (Access = public)
        
        %===================================
        % Constructor
        function this = t_sigproc_base(name)
            this.name = name;
            this.ready = 0;
        end
        
        %===================================
        % Object initialization
        params_out = init(this, params);
            
        %===================================
        % Set input / output buffers
        params_out = set_bufs(this, bufs_in, buf_out);
        
        %===================================
        % Perform processing
        do_work(this);
        
    end
    
end

