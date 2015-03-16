%===================================
% Set input / output buffers
function params_out = set_bufs(this, bufs_in, buf_out)

    assert(this.ready == 1);
    assert(length(bufs_in) == length(this.params.inp_descs));
    
    name = this.name;

    % Store buffer references
    this.bufs_in = bufs_in;
    this.buf_out = buf_out;
    
    % Check sampling rates
    assert(buf_out.srate == this.params.params_base.srate_out);
    for inp_num = 1 : length(this.params.inp_descs)
        assert(bufs_in(inp_num).srate == this.params.inp_descs(inp_num).srate_in);
    end
    
    % Find indices of input channels in input buffers
    for inp_num = 1 : length(this.params.inp_descs)
       
        inp_desc_cur = this.params.inp_descs(inp_num);
                    
        for chan_num_in = 1 : length(inp_desc_cur.chan_names_in)
            
            chan_name_cur = inp_desc_cur.chan_names_in{chan_num_in};
            
            % Find channel with given name in the input buffer
            
%             for i = 1:length(bufs_in(inp_num).chan_names)
%                 bufs_in(inp_num).chan_names(i) = strrep(bufs_in(inp_num).chan_names(i), '7-14', '7-9');
%             end
            
            chan_id_cur = find(strcmp(chan_name_cur, bufs_in(inp_num).chan_names));
            if isempty(chan_id_cur)
                log_write('[%s] t_sigproc_base::set_bufs() -> channel ''%s'' not found in the input buffer %i - ERROR\n', name, chan_name_cur, inp_num);
                assert(1==0);
            end
            if length(chan_id_cur) > 1
                log_write('[%s] t_sigproc_base::set_bufs() -> more than 1 channel with name ''%s'' found in the input buffer - ERROR\n', name, chan_name_cur);
                assert(1==0);
            end
            
            % Store channel index to parameters
            this.params.inp_descs(inp_num).chan_idx_in(chan_num_in) = chan_id_cur;
            
        end
        
    end
    
    params_out = this.params;

end


