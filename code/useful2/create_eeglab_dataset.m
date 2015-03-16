function EEG = create_eeglab_dataset(data, markers, srate, chan_names)
% data(nchans x nsamples) - signal
% markers(nmarkers x 2) - events
% markers(n,1) - event latency in samples
% markers(n,2) - event label
% srate - sampling rate
% chan_names - list of channel names


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%eeglab_path = 'F:\eeglab12_0_2_5b';
eeglab_path = 'C:\WORK\HSE\TOOLBOX\eeglab12_0_2_5b';
fpath_chanlocs = fullfile(eeglab_path, 'plugins\dipfit2.2\standard_BESA\standard-10-5-cap385.elp');

dirpath_work = 'C:\WORK\bci\TEMP';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% EEG data
X = data;
nchans = size(X,1);

% Create 'X' variable in the base matlab scope
global Xglob;
Xglob = X;
evalin('base', 'global Xglob; X = Xglob;');

% Create dataset
EEG = pop_importdata('dataformat', 'array', 'nbchan', 0, 'data', 'X',...
    'setname', 'Dataset',...
    'srate', srate, 'pnts', 0, 'xmin', 0);
EEG = eeg_checkset(EEG);

% Clear 'X' variable from current and base workspace
clear X;
clear Xglob;
evalin('base', 'clear X; clear Xglob');


% Set channel names and load channel locations
eval_str = 'EEG = pop_chanedit(EEG, ';
for chan_num = 1 : nchans
    eval_str_cur_templ = [...
        '''append'', %i, ',...
        '''changefield'', {%i ''labels'' chan_names{%i}}, ',...
        '''changefield'', {%i ''datachan'' 1}, '];
    eval_str_cur = sprintf(eval_str_cur_templ,...
        chan_num, chan_num, chan_num, chan_num);
    eval_str = [eval_str eval_str_cur];
end
eval_str = [eval_str(1:end-2) ', ''load'', [], ''lookup'', ''' strrep(fpath_chanlocs,'\','\\') ''');'];
eval(eval_str);
EEG = eeg_checkset(EEG);

% Calculate times of events (trial beginnings)
ev_lats = markers(:,1) / srate;

% Event names
ev_types = markers(:,2);

% Save events to text file
ev_data = [ev_types(:) ev_lats(:)]';
fid = fopen(fullfile(dirpath_work, 'ev_data.txt'), 'w');
fprintf(fid, '%i %f\n', ev_data(:))
fclose(fid);

% Load events to dataset
EEG = pop_importevent(EEG, 'event',...
    fullfile(dirpath_work,'ev_data.txt'),...
    'fields', {'type' 'latency'}, 'timeunit', 1);
EEG = eeg_checkset(EEG);


end

