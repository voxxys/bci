function res = log_open(fpath, mode)
% Opens file fpath for writing and stores descriptor in global variable flog

global flog;

% Close old log file
log_close();

% Create folder if needed
[fpath_dir, fname_noext, fname_ext] = fileparts(fpath);
try
    mkdir(fpath_dir);
catch
    fprintf('log_open(): cannot create folder ''%s''\n', fpath_dir);
    res = 0;
    return;
end

% Get string with current date and time
date_str = datestr(now,'dd-mmm-yyyy_HH.MM.SS');

fname = sprintf('%s_(%s)%s', fname_noext, date_str, fname_ext);
fpath = fullfile(fpath_dir, fname);

% Open file
if strcmp(mode, 'new')
    flog = fopen(fpath, 'w');
elseif strcmp(mode, 'add')
    flog = fopen(fpath, 'a');
else
    fprintf('log_open(): invalid mode ''%s''\n', mode);
end
    
% Check result
if (flog == -1)
    fprintf('log_open(): cannot create log file ''%s''\n', fname);
    flog = 0;
    res = 0;
    return;
end

% Version of matlab
matlab_ver = version;

% EEGLAB version
Q = regexpi(path,'eeglab[0-9]+_[0-9]+_[0-9]+_[0-9]+[a-z]?','match');
Q = unique(Q);
eeglab_ver = sprintf('%s ', Q{:});

% Write header with current date and time, matlab version and eeglab version
fprintf(flog,...
    '\r\n\r\n========== %s ==========\r\nMATLAB: %s\r\nEEGLAB: %s\r\n\r\n',...
    date_str, matlab_ver, eeglab_ver);

res = 1;


end

