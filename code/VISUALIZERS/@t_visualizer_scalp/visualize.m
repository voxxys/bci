function visualize(this)


ndescs = length(this.params.scalpdata_descs);

% Go to figure
figure(this.params.fig_num);

for n = 1 : ndescs

    % Descriptor of current visualization
    desc = this.params.scalpdata_descs{n};

    % Create subplot for current visualization
    subplot(desc.subplot_info(1), desc.subplot_info(2), desc.subplot_info(3)); cla;

    % Get data source
    buf = this.get_exp_buf(desc.data_type, desc.stage_name);

    %{
    % Get visualizing data from output buffer of the source
    data_sz = desc.avg_win_t * src.params.srate_out;
    [data_vis, sample_idx_vis] = src.buf.get_last_data(data_sz);
    if isempty(sample_idx_vis)
        continue;
    end

    % Calculate power and average it over time
    data_vis = data_vis.^2;
    data_vis = mean(data_vis,2);
    %}
    
    % Get last sample from input data
    [data_vis, sample_idx_vis] = buf.get_last_data(1);
    if isempty(data_vis)
        continue;
    end

    % Leave only channels used to visualize
    %chan_idx_src = cellfun(@(s)find(strcmp(s, buf.chan_names)), desc.chan_names_data);

    chan_idx_src = find_str_idx(buf.chan_names, desc.chan_names_data);
    data_vis = data_vis(chan_idx_src,:);

    % Nullify out-of-mask channels
    if ~isempty(desc.chan_mask)
        chan_idx_mask = find_str_idx(desc.chan_names_data, desc.chan_mask);
        chan_idx_null = [1 : length(desc.chan_names_data)];
        chan_idx_null(chan_idx_mask) = [];
        data_vis(chan_idx_null,:) = 0;
    end

    % Find indices of visualizing channels in chanlocs
    % TODO: to init_spec()
    chan_idx_chanlocs = cellfun(@(s)find(strcmp(s, lower({this.chanlocs.labels}))), lower(desc.chan_names_chanlocs));
    chanlocs_vis = this.chanlocs(chan_idx_chanlocs);

    % Plot scalp
    tic;
    topoplot2(data_vis, chanlocs_vis, 'maplimits', this.maplimits_cur{n}, 'style', 'map');
    %topoplot2(data_vis, chanlocs_vis, 'maplimits', [-1 1] * 10^5, 'style', 'map');
    toc;

    % Get current state from state generator
    [state_name, state_label] = this.exp.stategen_stage.proc_obj.get_cur_state();

    % Create title
    title_str = sprintf('%s  [STATE = %s]', desc.name, state_name);
    title(title_str);

end

drawnow;


end