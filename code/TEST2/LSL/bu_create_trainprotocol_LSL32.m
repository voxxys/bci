function create_trainprotocol_LSL32(fpath_protocol, fpath_chanlocs)
% Create test trainprotocol
% EOGrej -> IIR -> SUBSAMP -> CSP -> WINPOW -> LDA


%=========================================
% Parameters

% NVX
%chan_names = {'Fp1', 'Fp2', 'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'T3', 'C3', 'Cz', 'C4',...
%    'T4', 'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'};
%chan_names_CSP = {'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'C3', 'Cz', 'C4',...
%    'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'};

% BrainAmps
%chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};
%chan_names_CSP = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};

% BrainAmps (no Fp2)
%{
chan_names = {'Fp1', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};
chan_names_CSP = {'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'C3', 'Cz', 'C4',...
    'CP5', 'CP1', 'CP2', 'CP6', 'P7', 'P3', 'Pz', 'P4', 'P8', 'O1', 'Oz', 'O2'};
%}
% BrainAmps (no Pz)
chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};
chan_names_CSP = {'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'C3', 'Cz', 'C4',...
    'CP5', 'CP1', 'CP2', 'CP6', 'P7', 'P3', 'P4', 'P8', 'O1', 'Oz', 'O2'};

% Path to some eeglab dataset with loaded channel locations
%fpath_chanlocs = 'C:\WORK\BCI\EXP_NEW\dataset_short.set';

% Frequency bands
freq_bands = {[11 14], [16 25]};
nbands = length(freq_bands);

nCSP = 3;


%=========================================
% Create train protocol

% Training procedure info
protocol.train_info.setup_name = 'TRAINPROTOCOL_LSL32';
protocol.train_info.parent_procname = 'create_trainprotocol_LSL32';

% Create empty stage descriptor and empty array of descriptors
sigproc_stage_desc_null = struct('stage_name', [], 'obj_type', [], 'params', [], 'trainer_type', [], 'train_params', []);
protocol.sigproc_stage_descs = repmat(sigproc_stage_desc_null, 0, 0);

% IIR filter (highpass)
%%{
stage_desc = struct();
stage_desc.stage_name = 'IIR_HIPASS';
stage_desc.obj_type = 't_sigproc_iir';
stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
stage_desc.params.params_spec.freq_bands = {[0.5 Inf]};
stage_desc.params.params_spec.filt_order = 4;
stage_desc.params.params_spec.need_append_channames = 0;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
%%}

%%{
% IIR filter (lowpass)
stage_desc = struct();
stage_desc.stage_name = 'IIR_LOWPASS';
stage_desc.obj_type = 't_sigproc_iir';
stage_desc.params.inp_descs(1).inp_stage_name = 'IIR_HIPASS';
%stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
%stage_desc.params.params_spec.freq_bands = {[45 55]};
stage_desc.params.params_spec.freq_bands = {[0 45]};
stage_desc.params.params_spec.filt_order = 6;
stage_desc.params.params_spec.need_append_channames = 0;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
%%}

% EOG correction
stage_desc = struct();
stage_desc.stage_name = 'EOGREJ';
stage_desc.obj_type = 't_sigproc_spatfilt';
stage_desc.params.inp_descs(1).inp_stage_name = 'IIR_LOWPASS';
stage_desc.params.inp_descs(1).chan_names_in = chan_names;      % process only EEG channels
stage_desc.trainer_type = 't_trainer_EOGrej';
stage_desc.train_params.eog_chan_name = 'Fp1';
stage_desc.train_params.eog_sigma_mult = 4;
stage_desc.train_params.ncomps_eog = 3;
stage_desc.train_params.fpath_chanlocs = fpath_chanlocs;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% IIR filter
stage_desc = struct();
stage_desc.stage_name = 'IIR';
stage_desc.obj_type = 't_sigproc_iir';
stage_desc.params.inp_descs(1).inp_stage_name = 'EOGREJ';
stage_desc.params.params_spec.freq_bands = freq_bands;
stage_desc.params.params_spec.filt_order = 5;
stage_desc.params.params_spec.need_append_channames = 1;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Subsampling
stage_desc = struct();
stage_desc.stage_name = 'SUBSAMPLE_1';
stage_desc.obj_type = 't_sigproc_base';
stage_desc.params.inp_descs(1).inp_stage_name = 'IIR';
stage_desc.params.params_base.srate_out = 100;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Average window power (for visualization only)
stage_desc = struct();
stage_desc.stage_name = 'WINPOW_VIS';
stage_desc.obj_type = 't_sigproc_winpow';
stage_desc.params.inp_descs(1).inp_stage_name = 'SUBSAMPLE_1';
stage_desc.params.params_base.timewin_prev = 1;      % sec
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% CSP (for each band)
for band_num = 1 : 2
    
    fmin = freq_bands{band_num}(1);
    fmax = freq_bands{band_num}(2);
    
    stage_desc = struct();
    stage_desc.stage_name = sprintf('CSP_%i_%i', fmin, fmax);
    stage_desc.obj_type = 't_sigproc_spatfilt';
    stage_desc.params.inp_descs(1).inp_stage_name = 'SUBSAMPLE_1';    
    stage_desc.params.inp_descs(1).chan_names_in =...
        cellfun(@(s)sprintf('%s_(%i-%i)', s, fmin, fmax), chan_names_CSP, 'UniformOutput', false);
    stage_desc.trainer_type = 't_trainer_CSP';
    stage_desc.train_params.state1 = 1;
    stage_desc.train_params.state2 = 2;
    stage_desc.train_params.lambda = 0.1;
    stage_desc.train_params.nCSP = nCSP;
    stage_desc.train_params.fpath_chanlocs = fpath_chanlocs;
    stage_desc.train_params.filtnames_base =...
        sprintf('CSP_(%i-%i)', fmin, fmax);
    stage_desc.train_params.chan_names_chanlocs = chan_names_CSP;
    %stage_desc.train_params.vis_type = 'none';
    %stage_desc.train_params.vis_type = 'filters';
    stage_desc.train_params.vis_type = 'patterns';
    protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
    
end

% Average window power
stage_desc = struct();
stage_desc.stage_name = 'WINPOW';
stage_desc.obj_type = 't_sigproc_winpow';
for band_num = 1 : 2
    fmin = freq_bands{band_num}(1);
    fmax = freq_bands{band_num}(2);
    stage_desc.params.inp_descs(band_num).inp_stage_name = sprintf('CSP_%i_%i', fmin, fmax);
end
stage_desc.params.params_base.timewin_prev = 2;      % sec
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Prediction with LDA
stage_desc = struct();
stage_desc.stage_name = 'LDA';
stage_desc.obj_type = 't_statepred_LDA';
stage_desc.params.inp_descs(1).inp_stage_name = 'WINPOW'; 
stage_desc.trainer_type = 't_trainer_LDA';
stage_desc.train_params.state1 = 1;
stage_desc.train_params.state2 = 2;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Save protocol
save(fpath_protocol, 'protocol');


end