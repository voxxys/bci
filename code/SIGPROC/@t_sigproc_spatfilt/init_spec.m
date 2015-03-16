function init_spec(this)


% Set names of output channels
if ~isempty(this.params.params_spec.filt_names)
    this.params.params_base.chan_names_out = this.params.params_spec.filt_names;    
end

% Total number of input channels
nchan_out = length(this.params.params_spec.filt_names);

% Total number of input channels
nchan_in = 0;
for n = 1 : length(this.params.inp_descs)
    nchan_in = nchan_in + length(this.params.inp_descs(n).chan_names_in);
end

% Check size of filter matrix
M = this.params.params_spec.M;
if size(M,2) ~= nchan_in
    log_write('[%s] t_sigproc_spatfilt::init_spec() -> width of filter matrix (%i) must be equal to the total number of input channels (%i)\n',...
        name, size(M,2), nchan_in);
	assert(1==0);
end    
if nchan_out && (size(M,1) ~= nchan_out)
    log_write('[%s] t_sigproc_spatfilt::init_spec() -> height of filter matrix (%i) must be equal to the number of output channels (%i)\n',...
        name, size(M,1), nchan_out);
	assert(1==0);
end


end     

