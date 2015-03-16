classdef t_sigproc_test_1 < t_sigproc_base
% TESTING OBJECT: Multiplies each channel by some value
    
    properties
        
        % params.params_spec.mult_vals = [...]
        
        M;
        
    end
    
    methods
        
        %===================================
        % Constructor
        function obj = t_sigproc_test_1(name)
            obj = obj@t_sigproc_base(name);
        end
        
    end
    
    methods (Access = protected)
        
        %===================================
        % Class-specific initialization
        function init_spec(obj)
            
            %%{
            obj.params.params_base.chan_names_out = {};
            
            for k = 1 : length(obj.params.inp_descs)
                
                chan_names_in = obj.params.inp_descs(k).chan_names_in;

                chan_id_cur = 1;
                chan_names_out = {};
                
                for m = 1 : length(chan_names_in)
                    for n = 1 : length(obj.params.params_spec.mult_vals)

                       chan_names_out{chan_id_cur} = sprintf('%s_(%i)', chan_names_in{m}, obj.params.params_spec.mult_vals(n));
                       chan_id_cur = chan_id_cur + 1;
                       
                   end
                end   
                
                obj.params.params_base.chan_names_out = [obj.params.params_base.chan_names_out, chan_names_out];
                
            end
            %%}
            
            nchans = length(obj.params.params_base.chan_names_out);
            obj.M = ones(nchans, nchans);
            
        end
        
        %===================================
        % Process data with original sampling rate as a whole (e.g. temporal filtering)
        %%{
        function data_out = proc_seq_fsin_spec(obj, sample_idx_in, data_in, inp_num)
            
            nchan_in = size(data_in,1);
            mult_vals = obj.params.params_spec.mult_vals;
            nmults = length(mult_vals);
            
            nchan_out = nchan_in * nmults;            
            data_out = zeros(nchan_out, size(data_in,2));
            
            chan_out_num = 1;
            
            for n = 1 : nchan_in               
                for m = 1 : nmults
                   
                    data_out(chan_out_num,:) = mult_vals(m) * data_in(n,:);
                    chan_out_num = chan_out_num + 1;
                    
                end                
            end
            
        end
        %%}
        
        %===================================
        % Process downsampled data (e.g. spatial filtering)
        %{
        function data_out = proc_seq_fsout_spec(obj, sample_idx_in, data_in)
            
            data_out = obj.M * data_in;
            
        end
        %}
        
    end
    
end

