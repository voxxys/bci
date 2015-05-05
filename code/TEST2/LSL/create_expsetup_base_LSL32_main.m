function create_expsetup_base_LSL32_main(fpath_expsetup, fpath_chanlocs)
% Create base experimental setup
% Load data and states from 32-channel LSL
% Assumed processing: EOGrej -> IIR -> SUBSAMP -> CSP -> WINPOW -> LDA
% Visualizers: scalp powers, task, EOG rejection


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Names of channels (NVX)
%chan_names = {'Fp1', 'Fp2', 'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'T3', 'C3', 'Cz', 'C4',...
%    'T4', 'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'};

% BrainAmps
%chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};
%chan_names = {'Fp1', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};
% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%     'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};

%temp
% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
%     'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'P4', 'P8',  'O1', 'Oz', 'O2'};

%temp + Pz
chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'Pz', 'P4', 'P8',  'O1', 'Oz', 'O2'};


% Mask of channels to visualize at scalp
chan_names_vismask = chan_names;

nchans = length(chan_names);

% Frequency bands
%freq_bands = {[11 14], [16 25]};
freq_bands = {[7 14], [16 25]};
nbands = length(freq_bands);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expsetup.exp_info.setup_name = 'LSL32_main';
expsetup.exp_info.parent_procname = 'create_expsetup_base_LSL32_main';

% Duration of experiment in seconds
expsetup.exp_params.exp_duration_t = 20;

% Reciever parameters
expsetup.sigsrc_stage_desc.obj_type = 't_eeg_recv_manager_lsl';
expsetup.sigsrc_stage_desc.params.params_spec = struct();


% Reciever parameters (test)
% expsetup.sigsrc_stage_desc.obj_type = 't_eeg_recv_manager_file';
% expsetup.sigsrc_stage_desc.params.params_spec.fpath_in = 'D:\BCI\EXP_DATA\short_32chan_2.set';
% expsetup.sigsrc_stage_desc.params.params_spec.mode = 'realtime';
% expsetup.sigsrc_stage_desc.params.params_spec.time_mult = 1;

% State generator parameters
expsetup.stategen_stage_desc.obj_type = 't_state_generator_binary';
expsetup.stategen_stage_desc.params.params_base.state_descs(1).label = -1;
expsetup.stategen_stage_desc.params.params_base.state_descs(1).name = 'LEFT';
expsetup.stategen_stage_desc.params.params_base.state_descs(1).mark = -1;
expsetup.stategen_stage_desc.params.params_base.state_descs(2).label = 1;
expsetup.stategen_stage_desc.params.params_base.state_descs(2).name = 'RIGHT';
expsetup.stategen_stage_desc.params.params_base.state_descs(2).mark = 1;
expsetup.stategen_stage_desc.params.params_base.state_id_def = 1;
expsetup.stategen_stage_desc.params.params_spec.T = 5;

% Visualizer parameters (signal)
n = 1;
%%{
expsetup.visualizers(n).name = 'VISUALIZER_TASK';
expsetup.visualizers(n).type = 't_visualizer_state';
expsetup.visualizers(n).params.fig_num = 100;
expsetup.visualizers(n).params.subplot_info = [2,3,2];
expsetup.visualizers(n).params.line_styles = {'r-', 'b-', 'r--', 'b--', 'k-'};
expsetup.visualizers(n).params.line_width = 1;
expsetup.visualizers(n).params.ylim = [-1.5, 7.5];
%expsetup.visualizers(n).params.ylim = [-1 1] * 3*1e3;
expsetup.visualizers(n).params.flip90 = 1;
expsetup.visualizers(n).params.centval = 0;
expsetup.visualizers(n).params.show_legend = 0;
expsetup.visualizers(n).params.hidetaskarrow = 0;
expsetup.visualizers(n).params.hidepredictionarrow = 0;
expsetup.visualizers(n).params.sig_descs{1}.data_type = 'SIGNAL';
expsetup.visualizers(n).params.sig_descs{1}.stage_name = 'LDA_1';
expsetup.visualizers(n).params.sig_descs{1}.chan_names_data = {'pred_smooth'};
expsetup.visualizers(n).params.sig_descs{1}.vis_win_t = 10;
expsetup.visualizers(n).params.sig_descs{1}.smooth_len_t = 0;
expsetup.visualizers(n).params.sig_descs{1}.need_square = 0;
expsetup.visualizers(n).params.sig_descs{1}.k = [-1, 2];
expsetup.visualizers(n).params.sig_descs{1}.spread_channels = 0;
expsetup.visualizers(n).params.sig_descs{2}.data_type = 'SIGNAL';
expsetup.visualizers(n).params.sig_descs{2}.stage_name = 'LDA_2';
expsetup.visualizers(n).params.sig_descs{2}.chan_names_data = {'pred_smooth'};
expsetup.visualizers(n).params.sig_descs{2}.vis_win_t = 10;
expsetup.visualizers(n).params.sig_descs{2}.smooth_len_t = 0;
expsetup.visualizers(n).params.sig_descs{2}.need_square = 0;
expsetup.visualizers(n).params.sig_descs{2}.k = [-1, 2];
expsetup.visualizers(n).params.sig_descs{2}.spread_channels = 0;
expsetup.visualizers(n).params.sig_descs{3}.data_type = 'SIGNAL';
expsetup.visualizers(n).params.sig_descs{3}.stage_name = 'LDA_3';
expsetup.visualizers(n).params.sig_descs{3}.chan_names_data = {'pred_smooth'};
expsetup.visualizers(n).params.sig_descs{3}.vis_win_t = 10;
expsetup.visualizers(n).params.sig_descs{3}.smooth_len_t = 0;
expsetup.visualizers(n).params.sig_descs{3}.need_square = 0;
expsetup.visualizers(n).params.sig_descs{3}.k = [-1, 2];
expsetup.visualizers(n).params.sig_descs{3}.spread_channels = 0;
expsetup.visualizers(n).params.sig_descs{4}.data_type = 'SIGNAL';
expsetup.visualizers(n).params.sig_descs{4}.stage_name = 'LDA_4';
expsetup.visualizers(n).params.sig_descs{4}.chan_names_data = {'pred_smooth'};
expsetup.visualizers(n).params.sig_descs{4}.vis_win_t = 10;
expsetup.visualizers(n).params.sig_descs{4}.smooth_len_t = 0;
expsetup.visualizers(n).params.sig_descs{4}.need_square = 0;
expsetup.visualizers(n).params.sig_descs{4}.k = [-1, 2];
expsetup.visualizers(n).params.sig_descs{4}.spread_channels = 0;
expsetup.visualizers(n).params.sig_descs{5}.data_type = 'SIGNAL';
expsetup.visualizers(n).params.sig_descs{5}.stage_name = 'LDA_5';
expsetup.visualizers(n).params.sig_descs{5}.chan_names_data = {'pred_smooth'};
expsetup.visualizers(n).params.sig_descs{5}.vis_win_t = 10;
expsetup.visualizers(n).params.sig_descs{5}.smooth_len_t = 0;
expsetup.visualizers(n).params.sig_descs{5}.need_square = 0;
expsetup.visualizers(n).params.sig_descs{5}.k = [-1, 2];
expsetup.visualizers(n).params.sig_descs{5}.spread_channels = 0;
expsetup.visualizers(n).params.sig_descs{6}.data_type = 'STATE';
expsetup.visualizers(n).params.sig_descs{6}.stage_name = '[INPUT]';
expsetup.visualizers(n).params.sig_descs{6}.chan_names_data = {'STATE'};
expsetup.visualizers(n).params.sig_descs{6}.vis_win_t = 10;
expsetup.visualizers(n).params.sig_descs{6}.smooth_len_t = 0;
expsetup.visualizers(n).params.sig_descs{6}.need_square = 0;
expsetup.visualizers(n).params.sig_descs{6}.k = [-3, 2];
expsetup.visualizers(n).params.sig_descs{6}.spread_channels = 0;

% n = 2;
% expsetup.visualizers(n).name = 'VISUALIZER_SIGNAL';
% expsetup.visualizers(n).type = 't_visualizer_sig';
% expsetup.visualizers(n).params.fig_num = 100;
% expsetup.visualizers(n).params.subplot_info = [2,1,2];
% expsetup.visualizers(n).params.line_styles = {'r-', 'b-', 'r--', 'b--', 'k-'};
% expsetup.visualizers(n).params.line_width = 1;
% expsetup.visualizers(n).params.ylim = [-1 1] * 4 * 1e2;
% expsetup.visualizers(n).params.flip90 = 0;
% expsetup.visualizers(n).params.centval = 0;
% expsetup.visualizers(n).params.show_legend = 0;
% expsetup.visualizers(n).params.sig_descs{1}.data_type = 'SIGNAL';
% expsetup.visualizers(n).params.sig_descs{1}.stage_name = '[INPUT]';
% expsetup.visualizers(n).params.sig_descs{1}.chan_names_data = {'Fz'};
% expsetup.visualizers(n).params.sig_descs{1}.vis_win_t = 5;
% expsetup.visualizers(n).params.sig_descs{1}.smooth_len_t = 0;
% expsetup.visualizers(n).params.sig_descs{1}.need_square = 0;
% expsetup.visualizers(n).params.sig_descs{1}.k = [0 0.3];
% expsetup.visualizers(n).params.sig_descs{1}.spread_channels = 1;
% expsetup.visualizers(n).params.sig_descs{2}.data_type = 'SIGNAL';
% expsetup.visualizers(n).params.sig_descs{2}.stage_name = 'EOGREJ';
% expsetup.visualizers(n).params.sig_descs{2}.chan_names_data = {'Fz'};
% expsetup.visualizers(n).params.sig_descs{2}.vis_win_t = 5;
% expsetup.visualizers(n).params.sig_descs{2}.smooth_len_t = 0;
% expsetup.visualizers(n).params.sig_descs{2}.need_square = 0;
% expsetup.visualizers(n).params.sig_descs{2}.k = [0 0.3];
% expsetup.visualizers(n).params.sig_descs{2}.spread_channels = 1;
%%}

% Visualizer parameters (power scalp)
% n = 3;
% %%{
% expsetup.visualizers(n).name = 'VISUALIZER_SCALP';
% expsetup.visualizers(n).type = 't_visualizer_scalp';
% expsetup.visualizers(n).params.fpath_chanlocs = fpath_chanlocs;
% expsetup.visualizers(n).params.fig_num = 100;
% vis_plot_num = [1 3];
% for m = 1 : 2
%     fmin = freq_bands{m}(1);
%     fmax = freq_bands{m}(2);
%     expsetup.visualizers(n).params.scalpdata_descs{m}.name = sprintf('POWER (%i-%i Hz)', fmin, fmax);
%     expsetup.visualizers(n).params.scalpdata_descs{m}.data_type = 'SIGNAL';
%     expsetup.visualizers(n).params.scalpdata_descs{m}.stage_name = 'WINPOW_VIS';
%     expsetup.visualizers(n).params.scalpdata_descs{m}.chan_names_data = {};%...
%     %    cellfun(@(s)sprintf('%s_(%i-%i)_avgpow', s, fmin, fmax), chan_names, 'UniformOutput', false);
%     expsetup.visualizers(n).params.scalpdata_descs{m}.chan_names_chanlocs = chan_names;
%     expsetup.visualizers(n).params.scalpdata_descs{m}.subplot_info = [2,3,vis_plot_num(m)];
%     %expsetup.visualizers(n).params.scalpdata_descs{m}.maplimits = [0.1; 1] * [-0.3, 0.3] * 10^3;     % "brightness"
%     expsetup.visualizers(n).params.scalpdata_descs{m}.maplimits = [1 15]' * [-1 1] * 10^5;     % "brightness"
%     expsetup.visualizers(n).params.scalpdata_descs{m}.chan_mask = {};%... 
%     %   cellfun(@(s)sprintf('%s_(%i-%i)_avgpow', s, fmin, fmax), chan_names_vismask, 'UniformOutput', false);
% end
%%}

% Save setup
save(fpath_expsetup, 'expsetup');


end

