

close all;


%=========================================
% Parameters

% Path to the working folder
dirpath_work = 'D:\bci\EXP_DATA\EXP_LSL32_new';


% Path to the trainprotocol file
fname_trainprotocol = 'train_protocol_LSL32.mat';
fpath_trainprotocol = fullfile(dirpath_work, fname_trainprotocol);

% Path to the recorded result of previous experiment
fname_expresult_old = 'bci_expresult_LSL32_first_12_03_2.mat';
fpath_expresult_old = fullfile(dirpath_work, fname_expresult_old);

% Path to the paradigm file
fname_paradigm = 'paradigm_LSL32_main.mat';
fpath_paradigm = fullfile(dirpath_work, fname_paradigm);

% Path to some eeglab dataset with loaded channel locations
fname_chanlocs = 'short_32chan_2.set';
fpath_chanlocs= fullfile(dirpath_work, fname_chanlocs);


%=========================================
% Create train protocol

create_trainprotocol_LSL32(fpath_trainprotocol, fpath_chanlocs);


%=========================================
% Train paradigm

% Open logfile
dirpath_log = fullfile(dirpath_work, 'TRAIN_LOG');
mkdir(dirpath_log);
log_path = fullfile(dirpath_log, 'logfile_train_test_LSL32.txt');
log_open(log_path, 'new');

% Load trainprotocol file
Q = load(fpath_trainprotocol);
protocol = Q.protocol;

% Load previously recorded experimental data
expresult = load(fpath_expresult_old);

% Train paradigm
train_manager = t_train_manager;
paradigm = train_manager.train_paradigm(protocol, expresult);

% Save paradigm
save(fpath_paradigm, 'paradigm');

% Close logfile
log_close;



