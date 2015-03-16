%===================================
% Object initialization (function of parent class) 
function params_out = init(this, params, bufs_in)


    name = this.name;

    
    % Store parameters passed as argument
    this.params = copy_struct_fields(params, this.params);

    % Check parameters that we expect to be initialized at the top level
    if is_empty_or_nonfield(this.params.params_base, 'srate_out')
        log_write('[%s] t_sigproc_base::init() -> srate_out not specified - ERROR\n', name);
        assert(1==0);
    end
    if is_empty_or_nonfield(this.params.params_base, 'timewin_prev')
        log_write('[%s] t_sigproc_base::init() -> timewin_prev not specified - ERROR\n', name);
        assert(1==0);
    end
    for n = 1 : length(this.params.inp_descs)
        if is_empty_or_nonfield(this.params.inp_descs(n), 'srate_in')
            log_write('[%s] t_sigproc_base::init() -> inp_descs(%i).srate_in not specified - ERROR\n', name, n);
            assert(1==0);
        end
        if is_empty_or_nonfield(this.params.inp_descs(n), 'chan_names_in')
            log_write('[%s] t_sigproc_base::init() -> inp_descs(%i).chan_names_in not specified - ERROR\n', name, n);
            assert(1==0);
        end
    end
    
    % Initialize some parameters with empty values
    % (to be sure that somebody didn't set them at the top level)
    % These parameters can be set inside init_spec(),
    % or otherwise they will be initialized by default values after init_spec() call
    this.params.params_base.downsamp_type = [];      % 'interp' | 'thin' | 'special'
    this.params.params_base.upsamp_type = [];        % 'interp' | 'repeat'
    this.params.params_base.chan_names_out = [];
    for n = 1 : length(this.params.inp_descs)
        this.params.inp_descs(n).nsamples_prev = [];
        this.params.inp_descs(n).k_downsamp = [];
        this.params.inp_descs(n).k_upsamp = [];
    end


    %%%%  Call class-specific init function
    this.init_spec();
    
    
    % Set default type of downsampling (if needed)
    if isempty(this.params.params_base.downsamp_type)
        this.params.params_base.downsamp_type = 'thin';
    end

    % Set default type of upsampling (if needed)
    if isempty(this.params.params_base.upsamp_type)
        this.params.params_base.upsamp_type = 'repeat';
    end
    
    % Set default names of output channels (if needed)
    if isempty(this.params.params_base.chan_names_out)
        log_write('[%s] t_sigproc_base::init() -> chan_names_out not specified - will use names of input channels\n', name);
        chan_names_out = {};
        for n = 1 : length(this.params.inp_descs)
            chan_names_out = [chan_names_out, this.params.inp_descs(n).chan_names_in];
        end
        this.params.params_base.chan_names_out = chan_names_out;
    end
    
    for n = 1 : length(this.params.inp_descs)
        
        % Input & output sampling rate
        fs_in = double(this.params.inp_descs(n).srate_in);
        fs_out = double(this.params.params_base.srate_out);
        
        % Output sampling rate -> coefficients of downsampling / upsampling
        if fs_in >= fs_out                  % will preserve sampling rate or downsample input data
            k_down = fs_in / fs_out;
            k_up = 1;
        else                                % will upsample input data
            k_down = 1;
            k_up = fs_out / fs_in;
        end
        this.params.inp_descs(n).k_downsamp = k_down;
        this.params.inp_descs(n).k_upsamp = k_up;
        
        % Check upsampling / downsampling coefficients
        if floor(k_down) ~= k_down
            log_write('[%s] t_sigproc_base::init() -> inp_descs(%i).k_downsamp is not integer - ERROR\n', name, n);
            assert(1==0);
        end
        if floor(k_up) ~= k_up
            log_write('[%s] t_sigproc_base::init() -> inp_descs(%i).k_upsamp is not integer - ERROR\n', name, n);
            assert(1==0);
        end
        
        % Preceding time window -> number of preceding samples
        this.params.inp_descs(n).nsamples_prev = ceil(this.params.params_base.timewin_prev * fs_in);
        
    end

    params_out = this.params;

    % Initialize index of first processed sample
    this.sample_id_last = 0;

    this.bufs_in = [];
    this.buf_out = [];
    
    this.ready = 1;

    
end
