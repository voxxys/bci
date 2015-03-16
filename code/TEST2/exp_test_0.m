
clear;

%=============================================
% PARAMETERS

exp = struct();

exp.exp_info.setup_name = 'base_setup';
exp.exp_info.parent_procname = 'exp_test';

% Duration of experiment in seconds
exp.exp_params.exp_duration_t = 5;

% Decription of signal source
exp.sigsrc_stage_desc.obj_type = 't_eeg_recv_manager_test_1';
exp.sigsrc_stage_desc.params.params_spec.srate = 600;
exp.sigsrc_stage_desc.params.params_spec.sig_freqs = [8 4 2];
%exp.sigsrc_stage_desc.params.params_spec.sig_freqs = ones(1,50);
exp.sigsrc_stage_desc.params.buf_out_desc.type = 'ring';
exp.sigsrc_stage_desc.params.buf_out_desc.len_t = 5;

% Description of state generator
exp.stategen_stage_desc.obj_type = 't_state_generator_null';
exp.stategen_stage_desc.params.params_base.state_descs(1).label = 1;
exp.stategen_stage_desc.params.params_base.state_descs(1).name = 'STATE1';
exp.stategen_stage_desc.params.params_base.state_id_def = 1;

% Stage 1
n = 1;
stage_desc = struct();
stage_desc.stage_name = 'SIGPROC_STAGE_1';
stage_desc.obj_type = 't_sigproc_test_1';
stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
stage_desc.params.inp_descs(1).chan_names_in = {'CHAN2'};
stage_desc.params.params_base.srate_out = 150;
%stage_desc.params.params_base.timewin_prev = 0.1;
stage_desc.params.buf_out_desc.type = 'ring';
stage_desc.params.buf_out_desc.len_t = 5;
stage_desc.params.params_spec.mult_vals = [-1];
exp.sigproc_stage_descs(n) = stage_desc;

% Stage 2
n = 2;
stage_desc = struct();
stage_desc.stage_name = 'SIGPROC_STAGE_2';
stage_desc.obj_type = 't_sigproc_test_1';
stage_desc.params.inp_descs(1).inp_stage_name = '[INPUT]';
stage_desc.params.inp_descs(1).chan_names_in = {'CHAN1'};
stage_desc.params.params_base.srate_out = 100;
%stage_desc.params.params_base.timewin_prev = 0.1;
stage_desc.params.buf_out_desc.type = 'linear';
%stage_desc.params.buf_out_desc.len_t = 1;
stage_desc.params.params_spec.mult_vals = [1 2];
exp.sigproc_stage_descs(n) = stage_desc;

% Stage 3
n = 3;
stage_desc = struct();
stage_desc.stage_name = 'SIGPROC_STAGE_3';
stage_desc.obj_type = 't_sigproc_test_1';
stage_desc.params.inp_descs(1).inp_stage_name = 'SIGPROC_STAGE_1';
stage_desc.params.inp_descs(1).chan_names_in = {'CHAN2_(-1)'};
stage_desc.params.inp_descs(2).inp_stage_name = 'SIGPROC_STAGE_2';
stage_desc.params.inp_descs(2).chan_names_in = {'CHAN1_(2)'};
stage_desc.params.inp_descs(3).inp_stage_name = 'SIGPROC_STAGE_2';
stage_desc.params.inp_descs(3).chan_names_in = {'CHAN1_(1)'};
stage_desc.params.inp_descs(4).inp_stage_name = '[INPUT]';
stage_desc.params.inp_descs(4).chan_names_in = {'CHAN3'};
stage_desc.params.params_base.srate_out = 300;
%stage_desc.params.params_base.timewin_prev = 0.1;
stage_desc.params.buf_out_desc.type = 'ring';
stage_desc.params.buf_out_desc.len_t = 5;
stage_desc.params.params_spec.mult_vals = [1];
exp.sigproc_stage_descs(n) = stage_desc;

% Stage 4
%{
n = 4;
stage_desc = struct();
stage_desc.stage_name = 'SIGPROC_STAGE_4';
stage_desc.obj_type = 't_sigproc_test_1';
stage_desc.params.inp_descs(1).inp_stage_name = 'SIGPROC_STAGE_3';
stage_desc.params.inp_descs(1).chan_names_in = {'CHAN2_(-1)_(1)'};
stage_desc.params.inp_descs(2).inp_stage_name = 'SIGPROC_STAGE_3';
stage_desc.params.inp_descs(2).chan_names_in = {'CHAN1_(2)_(1)'};
stage_desc.params.inp_descs(3).inp_stage_name = 'SIGPROC_STAGE_3';
stage_desc.params.inp_descs(3).chan_names_in = {'CHAN1_(1)_(1)'};
stage_desc.params.inp_descs(4).inp_stage_name = 'SIGPROC_STAGE_3';
stage_desc.params.inp_descs(4).chan_names_in = {'CHAN3_(1)'};
stage_desc.params.params_base.srate_out = 150;
%stage_desc.params.params_base.timewin_prev = 0.1;
exp.sigsrc_stage.params.buf_out_desc.type = 'ring';
exp.sigsrc_stage.params.buf_out_desc.len_t = 5;
stage_desc.params.params_spec.mult_vals = [10, 100];
%stage_desc.params.params_spec.mult_vals = [1];
exp.sigproc_stage_descs(n) = stage_desc;
%}

% Visualizer (INPUT)
%%{
n = 1;
exp.visualizers(n).name = 'VISUALIZER_1';
exp.visualizers(n).type = 't_visualizer_sig';
exp.visualizers(n).params.fig_num = 100;
exp.visualizers(n).params.subplot_info = [2,1,1];
%exp.visualizers(n).params.line_styles = {'r.-', 'b.-', 'm.-', 'g.-', 'k.-'};
exp.visualizers(n).params.line_styles = {'r-', 'b-', 'm-', 'g-', 'k-'};
exp.visualizers(n).params.line_width = 1;
exp.visualizers(n).params.ylim = [-2.2 2.2];
exp.visualizers(n).params.flip90 = 0;
exp.visualizers(n).params.centval = 0;
exp.visualizers(n).params.show_legend = 1;
exp.visualizers(n).params.sig_descs{1}.data_type = 'SIGNAL';
exp.visualizers(n).params.sig_descs{1}.stage_name = '[INPUT]';
%exp.visualizers(n).params.sig_descs{1}.buf_name = 'buf_out';
exp.visualizers(n).params.sig_descs{1}.chan_names_data = {};
exp.visualizers(n).params.sig_descs{1}.vis_win_t = 2;
exp.visualizers(n).params.sig_descs{1}.smooth_len_t = 0;
exp.visualizers(n).params.sig_descs{1}.need_square = 0;
exp.visualizers(n).params.sig_descs{1}.mult = 1;
%%}

%%{
% Visualizer (PROCESSED)
n = 2;
exp.visualizers(n).name = 'VISUALIZER_2';
exp.visualizers(n).type = 't_visualizer_sig';
exp.visualizers(n).params.fig_num = 100;
exp.visualizers(n).params.subplot_info = [2,1,2];
%exp.visualizers(n).params.line_styles = {'r.-', 'b.-', 'm.-', 'g.-', 'k.-'};
exp.visualizers(n).params.line_styles = {'r-', 'b-', 'm-', 'g-', 'k-', 'r--', 'b--', 'm--', 'g--', 'k--'};
exp.visualizers(n).params.line_width = 1;
%exp.visualizers(n).params.ylim = [-2.2 2.2];
exp.visualizers(n).params.ylim = [-Inf Inf];
exp.visualizers(n).params.flip90 = 0;
exp.visualizers(n).params.centval = 0;
exp.visualizers(n).params.show_legend = 1;
exp.visualizers(n).params.sig_descs{1}.data_type = 'SIGNAL';
exp.visualizers(n).params.sig_descs{1}.stage_name = 'SIGPROC_STAGE_3';
exp.visualizers(n).params.sig_descs{1}.chan_names_data = {};
exp.visualizers(n).params.sig_descs{1}.vis_win_t = 2;
exp.visualizers(n).params.sig_descs{1}.smooth_len_t = 0;
exp.visualizers(n).params.sig_descs{1}.need_square = 0;
exp.visualizers(n).params.sig_descs{1}.mult = 1;
%%}

% Visualizer (PROCESSED)
%{
n = 3;
exp.visualizers(n).name = 'VISUALIZER_3';
exp.visualizers(n).type = 't_visualizer_sig';
exp.visualizers(n).params.fig_num = 100;
exp.visualizers(n).params.subplot_info = [3,1,3];
%exp.visualizers(n).params.line_styles = {'r.-', 'b.-', 'm.-', 'g.-', 'k.-'};
exp.visualizers(n).params.line_styles = {'r-', 'b-', 'm-', 'g-', 'k-', 'r--', 'b--', 'm--', 'g--', 'k--'};
exp.visualizers(n).params.line_width = 1;
exp.visualizers(n).params.ylim = [-200.2 200.2];
exp.visualizers(n).params.flip90 = 0;
exp.visualizers(n).params.centval = 0;
exp.visualizers(n).params.show_legend = 0;
exp.visualizers(n).params.sig_descs{1}.data_type = 'SIGNAL';
exp.visualizers(n).params.sig_descs{1}.stage_name = 'SIGPROC_STAGE_4';
exp.visualizers(n).params.sig_descs{1}.chan_names_data = {};
exp.visualizers(n).params.sig_descs{1}.vis_win_t = 2;
exp.visualizers(n).params.sig_descs{1}.smooth_len_t = 0;
exp.visualizers(n).params.sig_descs{1}.need_square = 0;
exp.visualizers(n).params.sig_descs{1}.mult = 1;
%}


%=============================================
% EXPERIMENT

dirpath_exp = 'C:\work\bci\TEST\EXP_TEST';
mkdir(dirpath_exp);

log_path = fullfile(dirpath_exp, 'logfile_exp_test.txt');
log_open(log_path, 'new');

exp_performer = t_exp_performer;
exp_performer.perform_exp(exp);

log_close();
