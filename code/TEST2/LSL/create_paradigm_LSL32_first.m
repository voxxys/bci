function create_paradigm_LSL32_first(fpath_paradigm, fpath_chanlocs)
% Create paradigm for first start of 32-channel LSL experiment
% INPUT -> IIR -> SUBSAMPLE -> WINPOW_VIS


%=========================================
% Parameters

% NVX
%chan_names = {'Fp1', 'Fp2', 'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'T3', 'C3', 'Cz', 'C4',...
%    'T4', 'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'};
%chan_names_CSP = {'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'C3', 'Cz', 'C4',...
%    'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'};

% BrainAmps
chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};

chan_names_CSP = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};

% Path to some eeglab dataset with loaded channel locations
%fpath_chanlocs = 'C:\WORK\BCI\EXP_NEW\dataset_short.set';

% Frequency bands
%freq_bands = {[11 14], [16 25]};
freq_bands = {[7 14], [16 25]};
nbands = length(freq_bands);

nCSP = 3;


%=========================================
% Create paradigm

% Create empty stage descriptor and empty array of descriptors
sigproc_stage_desc_null = struct('stage_name', [], 'obj_type', [], 'params', []);
paradigm.sigproc_stage_descs = repmat(sigproc_stage_desc_null, 0, 0);

% IIR filter (highpass)
%%{
stage_desc = struct();
stage_desc.stage_name = 'IIR_HIPASS';
stage_desc.obj_type = 't_sigproc_iir';
stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
stage_desc.params.params_spec.freq_bands = {[0.5 Inf]};
stage_desc.params.params_spec.filt_order = 4;
stage_desc.params.params_spec.need_append_channames = 0;
paradigm.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
%%}

%%{
% IIR filter (notch)
stage_desc = struct();
stage_desc.stage_name = 'IIR_NOTCH';
stage_desc.obj_type = 't_sigproc_iir';
stage_desc.params.inp_descs(1).inp_stage_name = 'IIR_HIPASS';
%stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
%stage_desc.params.params_spec.freq_bands = {[45 50]};
stage_desc.params.params_spec.freq_bands = {[0 45]};
stage_desc.params.params_spec.filt_order = 6;
stage_desc.params.params_spec.need_append_channames = 0;
paradigm.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
%%}

% IIR filter
stage_desc = struct();
stage_desc.stage_name = 'IIR';
stage_desc.obj_type = 't_sigproc_iir';
stage_desc.params.inp_descs(1).inp_stage_name = 'IIR_NOTCH';
%stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
%stage_desc.params.inp_descs(1).inp_stage_name = 'IIR_HIPASS';
stage_desc.params.params_spec.freq_bands = freq_bands;
stage_desc.params.params_spec.filt_order = 5;
stage_desc.params.params_spec.need_append_channames = 1;
paradigm.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Subsampling
stage_desc = struct();
stage_desc.stage_name = 'SUBSAMPLE_1';
stage_desc.obj_type = 't_sigproc_base';
stage_desc.params.inp_descs(1).inp_stage_name = 'IIR';
stage_desc.params.params_base.srate_out = 100;
paradigm.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Average window power (for visualization only)
stage_desc = struct();
stage_desc.stage_name = 'WINPOW_VIS';
stage_desc.obj_type = 't_sigproc_winpow';
stage_desc.params.inp_descs(1).inp_stage_name = 'SUBSAMPLE_1';
stage_desc.params.params_base.timewin_prev = 1;      % sec
paradigm.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Save paradigm
save(fpath_paradigm, 'paradigm');


end