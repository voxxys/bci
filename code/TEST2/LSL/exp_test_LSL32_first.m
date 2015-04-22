

close all;


%=========================================
% Parameters

% Path to the working folder
dirpath_work = 'D:\bci\EXP_DATA\EXP_LSL32_new';

% Path to the base expsetup file
fname_expsetup_base = 'expsetup_base_LSL32_first.mat';
fpath_expsetup_base = fullfile(dirpath_work, fname_expsetup_base);

% Path to the expsetup file used in experiment
fname_expsetup = 'expsetup_LSL32_first.mat';
fpath_expsetup = fullfile(dirpath_work, fname_expsetup);

% Path to the paradigm file
fname_paradigm = 'paradigm_LSL32_first.mat';
fpath_paradigm = fullfile(dirpath_work, fname_paradigm);

% Path to some eeglab dataset with loaded channel locations
fname_chanlocs ='short_32chan_2.set';
fpath_chanlocs = fullfile(dirpath_work, fname_chanlocs);

% Path to the output file with experiment result
fname_expresult ='bci_expresult_LSL32_first_test.mat';
fpath_expresult = fullfile(dirpath_work, fname_expresult);


%=========================================
% Create paradigm for the first bci session

create_paradigm_LSL32_first(fpath_paradigm, fpath_chanlocs);


%=========================================
% Create base experimental setup

create_expsetup_base_LSL32_first(fpath_expsetup_base, fpath_chanlocs);


%=========================================
% Combine base experimental setup with paradigm

% Load base expsetup
Q = load(fpath_expsetup_base);
expsetup = Q.expsetup;

% Load paradigm
Q = load(fpath_paradigm);
paradigm = Q.paradigm;

% Add stage descriptors to expsetup
expsetup.sigproc_stage_descs = paradigm.sigproc_stage_descs;

% Save prepared expsetup
save(fpath_expsetup, 'expsetup');


%=========================================
% Perform experiment

% Open logfile
dirpath_log = fullfile(dirpath_work, 'EXP_LOG');
mkdir(dirpath_log);
log_path = fullfile(dirpath_log, 'logfile_exp_test_LSL32_first.txt');
log_open(log_path, 'new');

% Load expsetup
Q = load(fpath_expsetup);
expsetup = Q.expsetup;

% Start experiment
exp_performer = t_exp_performer;
exp_performer.perform_exp(expsetup);


%=========================================
% Save result
data = exp_performer.sigsrc_stage.buf_eeg;
states = exp_performer.stategen_stage.buf_out;
save(fpath_expresult, 'data', 'states');


% Close logfile
log_close;



