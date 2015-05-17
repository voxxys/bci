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
% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
%     'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'};
% chan_names_CSP = {'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'C3', 'Cz', 'C4',...
%     'CP5', 'CP1', 'CP2', 'CP6', 'P7', 'P3', 'P4', 'P8', 'O1', 'Oz', 'O2'};

% new (no Pz)
% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T3', 'C3', 'Cz', 'C4',...
%     'T4', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'T5', 'P3', 'P4', 'T6',  'O1', 'Oz', 'O2'};
% chan_names_CSP = {'F7', 'F3', 'Fz', 'F4', 'F8', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'C3', 'Cz', 'C4',...
%     'Cp5', 'Cp1', 'Cp2', 'Cp6', 'T5', 'P3', 'P4', 'T6', 'O1', 'Oz', 'O2'};

%temp
% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
%     'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'P4', 'P8',  'O1', 'Oz', 'O2'};
% chan_names_CSP = {'F7', 'F3', 'Fz', 'F4', 'F8', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'C3', 'Cz', 'C4',...
%     'Cp5', 'Cp1', 'Cp2', 'Cp6', 'P7', 'P3', 'P4', 'P8', 'O1', 'Oz', 'O2'};

% chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
%     'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'Pz', 'P4', 'P8',  'O1', 'Oz', 'O2'};
% chan_names_CSP = {'F7', 'F3', 'Fz', 'F4', 'F8', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'C3', 'Cz', 'C4',...
%     'Cp5', 'Cp1', 'Cp2', 'Cp6', 'P7', 'P3', 'P4', 'P8', 'O1', 'Oz', 'O2'};

chan_names = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'P4', 'P8',  'O1', 'Oz', 'O2'};
chan_names_CSP = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'P4', 'P8',  'O1', 'Oz', 'O2'};


% Path to some eeglab dataset with loaded channel locations
%fpath_chanlocs = 'C:\WORK\BCI\EXP_NEW\dataset_short.set';

% Frequency bands
%freq_bands = {[11 14], [16 25]};
freq_bands = {[11 20]};

state_ids = [1 2 5 6];

nn = size(state_ids,2);
% freq_bands = cell(1, nn^2-nn);
% naming_freq_bands = {[7 14], [16 25]};
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
stage_desc.trainer_type = 't_trainer_EOGrej_set';
stage_desc.train_params.eog_chan_name = 'Fp1';
stage_desc.train_params.eog_sigma_mult = 2;
stage_desc.train_params.ncomps_eog = 3;
stage_desc.train_params.fpath_chanlocs = fpath_chanlocs;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% IIR filter

numiir = 1;
for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)        
            
            stage_desc = struct();
            stage_desc.stage_name = sprintf('IIR_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.obj_type = 't_sigproc_iir';
            stage_desc.params.inp_descs(1).inp_stage_name = 'EOGREJ';
            stage_desc.params.numi = numiir;
            stage_desc.params.params_spec.freq_bands = freq_bands;
            stage_desc.params.params_spec.filt_order = 5;
            stage_desc.params.params_spec.need_append_channames = 0;
            stage_desc.trainer_type = 't_trainer_freqband_set';
            % stage_desc.train_params.lambda = 0.1;
            protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
            numiir = numiir + 1;
        end
    end
end


% Subsampling
for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)        

            stage_desc = struct();
            stage_desc.stage_name = sprintf('SUBSAMPLE_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.obj_type = 't_sigproc_base';
            stage_desc.params.inp_descs(1).inp_stage_name = sprintf('IIR_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.params.params_base.srate_out = 100;
            protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

        end
    end
end


% CSP (for each band)
for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)
            stage_desc = struct();
            stage_desc.stage_name = sprintf('CSP_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.obj_type = 't_sigproc_spatfilt';
            stage_desc.params.inp_descs(1).inp_stage_name = sprintf('SUBSAMPLE_%i_%i', state_ids(state_num_i), state_ids(state_num_j));    
%             stage_desc.params.inp_descs(1).chan_names_in = chan_names_CSP;
            stage_desc.trainer_type = 't_trainer_CSP_set';
            stage_desc.train_params.state1 = state_ids(state_num_i);
            stage_desc.train_params.state2 = state_ids(state_num_j);
%             stage_desc.train_params.lambda = 0.1;
%             stage_desc.train_params.nCSP = nCSP;
            stage_desc.train_params.fpath_chanlocs = fpath_chanlocs;
            stage_desc.train_params.filtnames_base =...
                sprintf('CSP_(%i_%i)', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.train_params.chan_names_chanlocs = chan_names_CSP;
            %stage_desc.train_params.vis_type = 'none';
            %stage_desc.train_params.vis_type = 'filters';
            stage_desc.train_params.vis_type = 'patterns';
            protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
        end
    end
end


% Average window power


for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)          
            stage_desc = struct();
            stage_desc.stage_name = sprintf('WINPOW_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.obj_type = 't_sigproc_winpow';
            stage_desc.params.inp_descs(1).inp_stage_name = sprintf('CSP_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.params.params_base.timewin_prev = 3;      % sec
            protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

        
        
        end
    end
end


% Prediction with LDA
% 
% numlda = 1;
% for state_num_i = 1 : size(state_ids,2)
%     for state_num_j = 1 : size(state_ids,2)
%         if(state_num_i ~= state_num_j)
%             stage_desc = struct();
%             stage_desc.stage_name = sprintf('LDA_%i_%i',state_ids(state_num_i), state_ids(state_num_j));
%             stage_desc.obj_type = 't_statepred_LDA';
%             stage_desc.params.inp_descs(1).inp_stage_name = sprintf('WINPOW_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
%             stage_desc.trainer_type = 't_trainer_LDA_set';
%             stage_desc.params.numi = numlda;
%             stage_desc.train_params.state1 = state_ids(state_num_i);
%             stage_desc.train_params.state2 = state_ids(state_num_j);
%             protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
%             numlda = numlda + 1;
%         end
%     end
% end

% Shrinkage
numlda = 1;
for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)
            stage_desc = struct();
            stage_desc.stage_name = sprintf('SHRINKAGE_%i_%i',state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.obj_type = 't_statepred_shrinkage';
            stage_desc.params.inp_descs(1).inp_stage_name = sprintf('WINPOW_%i_%i', state_ids(state_num_i), state_ids(state_num_j));
            stage_desc.trainer_type = 't_trainer_shrinkage_set';
            stage_desc.params.numi = numlda;
            stage_desc.train_params.state1 = state_ids(state_num_i);
            stage_desc.train_params.state2 = state_ids(state_num_j);
            protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
            numlda = numlda + 1;
        end
    end
end


% stage_desc = struct();
% stage_desc.stage_name = 'LDA_final'
% stage_desc.obj_type = 't_statepred_LDA_6';
% 
% numlda_f = 1;
% for state_num_i = 1 : size(state_ids,2)
%     for state_num_j = 1 : size(state_ids,2)
%         if(state_num_i ~= state_num_j)
%             
%             stage_desc.params.inp_descs(numlda_f).inp_stage_name = sprintf('LDA_%i_%i', state_ids(state_num_i), state_ids(state_num_j));    
%             numlda_f = numlda_f + 1;
%             
%         end
%     end
% end
% stage_desc.params.params_spec.state_ids = state_ids;
% protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);


% Perceptron
stage_desc = struct();
stage_desc.stage_name = 'PERCEPTRON';
stage_desc.obj_type = 't_statepred_perc';
stage_desc.trainer_type = 't_trainer_perc_set';

numlda_f = 1;
for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)
            
            stage_desc.params.inp_descs(numlda_f).inp_stage_name = sprintf('SHRINKAGE_%i_%i', state_ids(state_num_i), state_ids(state_num_j));    
            numlda_f = numlda_f + 1;
            
        end
    end
end
stage_desc.params.params_spec.state_ids = state_ids;
protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);
           

% % Prediction with Rieman distance
% stage_desc = struct();
% stage_desc.stage_name = 'RIEMDIST';
% stage_desc.obj_type = 't_statepred_rieman';
% stage_desc.params.inp_descs(1).inp_stage_name = 'WINPOW'; 
% stage_desc.params.nsamples_prev = 10;
% % stage_desc.params.params_spec.cov_mat;
% stage_desc.trainer_type = 't_trainer_rieman';
% stage_desc.train_params.state1 = 1;
% stage_desc.train_params.state2 = 2;
% protocol.sigproc_stage_descs(end+1) = copy_struct_fields(stage_desc, sigproc_stage_desc_null);

% Save protocol
save(fpath_protocol, 'protocol');


end