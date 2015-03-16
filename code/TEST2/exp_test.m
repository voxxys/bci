

close all;


%=========================================
% Parameters

% Path to the working folder
dirpath_work = 'D:\bci\code_stable\bci_test_19_02_2015';


% Path to the base expsetup file
fname_expsetup_base = 'expsetup_base.mat';
fpath_expsetup_base = fullfile(dirpath_work, fname_expsetup_base);

% Path to the expsetup file used in experiment
fname_expsetup = 'expsetup_2.mat';
fpath_expsetup = fullfile(dirpath_work, fname_expsetup);

% Path to eeglab dataset used as input
fname_dataset_inp = 'bci_expresult_1.set';
fpath_dataset_inp = fullfile(dirpath_work, fname_dataset_inp);

% Path to the paradigm file
fname_paradigm = 'paradigm_1_out.mat';
fpath_paradigm = fullfile(dirpath_work, fname_paradigm);

% Path to some eeglab dataset with loaded channel locations
fname_chanlocs ='dataset_short.set';
fpath_chanlocs= fullfile(dirpath_work, fname_chanlocs);


%=========================================
% Create base experimental setup

create_expsetup_base(fpath_expsetup_base, fpath_chanlocs, fpath_dataset_inp);


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
log_path = fullfile(dirpath_log, 'logfile_exp_test.txt');
log_open(log_path, 'new');

% Load expsetup
Q = load(fpath_expsetup);
expsetup = Q.expsetup;

% Start experiment
exp_performer = t_exp_performer;
exp_performer.perform_exp(expsetup);

% Close logfile
log_close;



