function init_spec(this)


order = this.params.params_spec.filt_order;

freq_bands = this.params.params_spec.freq_bands;



% Prepare filters for each input and each frequency band
for inp_num = 1 : length(this.params.inp_descs)
    
    % Sampling rate of current input
    fs = this.params.inp_descs(inp_num).srate_in;
    
    for m = 1 : length(freq_bands)

        % Frequency limits
        fmin = freq_bands{m}(1);
        fmax = freq_bands{m}(2);

        % Highpass filter
        if fmin > 0
            [this.bandfilt_coeffs{inp_num,m}.b_high, this.bandfilt_coeffs{inp_num,m}.a_high] =...
                butter(order, fmin/(fs/2), 'high');
        end

        % Lowpass filter
        if fmax < Inf
            [this.bandfilt_coeffs{inp_num,m}.b_low, this.bandfilt_coeffs{inp_num,m}.a_low] =...
                butter(order, fmax/(fs/2), 'low');
        end

        this.Zlast{inp_num,m,1} = [];
        this.Zlast{inp_num,m,2} = [];

    end
    
end


this.params.params_base.chan_names_out = {};

% Create names of output channels for each input
for inp_num = 1 : length(this.params.inp_descs)

    % Indices & names of all input channels used
    chan_names_in = this.params.inp_descs(inp_num).chan_names_in;

    % Postfix to add to output channels for current input
    chan_out_postfix = '';
    if isfield(this.params.params_spec, 'chan_out_postfixes')
        chan_out_postfix = this.params.params_spec.chan_out_postfixes{inp_num};
        if ~isempty(chan_out_postfix)
            chan_out_postfix = [chan_out_postfix, '_'];
        end
    end
    
    % Create list of output channel names
    chan_names_out = {};
    chan_id_cur = 1;
    for n = 1 : length(freq_bands)
       for m = 1 : length(chan_names_in)

            if this.params.params_spec.need_append_channames
                naming_freq_bands = this.params.params_spec.naming_freq_bands;
                chan_names_out{chan_id_cur} = sprintf('%s_%s(%i-%i)', chan_names_in{m},...
                   chan_out_postfix, naming_freq_bands{n}(1), naming_freq_bands{n}(2));
            else
                assert(length(freq_bands) == 1);
                chan_names_out{chan_id_cur} = chan_names_in{m};
            end

            chan_id_cur = chan_id_cur + 1;

       end
    end            
    this.params.params_base.chan_names_out = [this.params.params_base.chan_names_out, chan_names_out];
    
end


end
