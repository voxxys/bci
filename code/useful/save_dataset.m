function save_dataset(EEG, dirpath_out, fname_out)
% Save dataset and write result to logfile

% Save dataset
fpath_out = fullfile(dirpath_out, fname_out);
try
    pop_saveset(EEG, 'filename', fname_out,...
        'filepath', dirpath_out, 'savemode', 'onefile');
catch
    log_write('>>>> ERROR: cannot save dataset ''%s'' (( %s ))\n',...
        fpath_out, lasterr);
    return;
end
log_write('>>>> Saved to ''%s''\n\n', fpath_out);

end

