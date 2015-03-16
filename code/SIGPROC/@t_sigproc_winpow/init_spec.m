function init_spec(this)
            
% Create list of output channel names
chan_names_out = {};
for inp_num = 1 : length(this.params.inp_descs)
    chan_names_out = [chan_names_out, cellfun(@(s)sprintf('%s_avgpow', s), this.params.inp_descs(inp_num).chan_names_in, 'UniformOutput', false)];
end
this.params.params_base.chan_names_out = chan_names_out;

end