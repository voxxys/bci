% Print parameters
function print_params(this)

log_write('\n=================  %s  =================\n\n', this.stage_name);

% Procesing object
log_write('OBJECT\n');
log_write('\tName: %s\n', this.proc_obj.name);
log_write('\tType: %s\n', this.obj_type);
log_write('\n');

% Common parameters
log_write('PARAMS\n');
log_write('\tsrate_out: %i\n', this.params.params_base.srate_out);
log_write('\ttimewin_prev: %i\n', this.params.params_base.timewin_prev);
log_write('\tdownsamp_type: %s\n', this.params.params_base.downsamp_type);
log_write('\tupsamp_type: %s\n', this.params.params_base.upsamp_type);
log_write('\n');

% Input buffers
for n = 1 : length(this.bufs_in)
   
    log_write('BUF_IN [%i]\n', n);
    
    buf_in = this.bufs_in(n);
    
    log_write('\tName: %s\n', buf_in.buf_name);
    log_write('\tSampling rate: %i\n', buf_in.srate);
    log_write('\tType: %s\n', buf_in.buf_type);
    log_write('\tLength: %i samples\n', buf_in.get_buf_len());    
    
    log_write('\tChannels: \n');
    for m = 1 : length(buf_in.chan_names)
        log_write('\t\t%i %s\n', m, buf_in.chan_names{m});
    end
    
    log_write('\n');

end

% Input - output descriptors
for n = 1 : length(this.params.inp_descs)
   
    log_write('INPUT [%i]\n', n);
    
    inp_desc = this.params.inp_descs(n);
    
    log_write('\tSampling_rate: %i\n', inp_desc.srate_in);
    log_write('\tDownsampling coeff: %i\n', inp_desc.k_downsamp);
    log_write('\tUpsampling coeff: %i\n', inp_desc.k_upsamp);
    log_write('\tNo. of preceding samlpes: %i\n', inp_desc.nsamples_prev);
    
    log_write('\tChannels (IN): \n');
    for m = 1 : length(inp_desc.chan_names_in)
        log_write('\t\t%i %s\t(%i)\n', m, inp_desc.chan_names_in{m}, inp_desc.chan_idx_in(m));
    end
    
    log_write('\n');
    
end

% Output channels
log_write('OUTPUT CHANNELS: \n');
for m = 1 : length(this.params.params_base.chan_names_out)
    log_write('\t%i %s\n', m, this.params.params_base.chan_names_out{m});
end
log_write('\n');

% Output buffer
log_write('BUF_OUT\n');
log_write('\tName: %s\n', this.buf_out.buf_name);
log_write('\tSampling rate: %i\n', this.buf_out.srate);
log_write('\tType: %s\n', this.buf_out.buf_type);
log_write('\tLength: %i samples\n', this.buf_out.get_buf_len());
log_write('\tChannels: \n');
for m = 1 : length(this.buf_out.chan_names)
    log_write('\t\t%i %s\n', m, this.buf_out.chan_names{m});
end
log_write('\n');


end



