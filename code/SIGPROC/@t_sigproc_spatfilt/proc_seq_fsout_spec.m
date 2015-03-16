function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)

% Allocate memory for output data
data_out = zeros(length(this.params.params_base.chan_names_out), length(sample_idx_in));

% Apply filters
data_out = this.params.params_spec.M * data_in;


end
