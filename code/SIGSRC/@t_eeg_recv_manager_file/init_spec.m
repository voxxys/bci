function init_spec(this)


% Load dataset
this.EEG = load_dataset(this.params.params_spec.fpath_in);
if isempty(this.EEG)
    log_write('[%s] t_eeg_recv_manager_file::init_spec() -> cannot load %s - ERROR\n', this.name, this.params.params_spec.fpath_in);
    assert(0==1);
end

% Current position is the beginning of dataset
this.dataset_pos_cur = 1;


end