function EEG = load_dataset(fpath_in)
% Load dataset from file and write error to log if failed

try
    EEG = pop_loadset(fpath_in, '');        
catch
    log_write('>>>> ERROR: cannot load dataset ''%s'' (( %s ))\n',...
        fpath_in, lasterr);
    EEG = [];
end

end

