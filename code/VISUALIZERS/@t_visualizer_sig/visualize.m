function visualize(this)


ndescs = length(this.params.sig_descs);

% Go to figure
figure(this.params.fig_num);

% Create subplot
subplot(this.params.subplot_info(1), this.params.subplot_info(2), this.params.subplot_info(3)); cla; hold on;

lgnd = {};
plot_num = 1;

vmin = Inf;
vmax = -Inf;

% Get max smooth_len
smooth_len_max = 0;
for n = 1 : ndescs
    desc = this.params.sig_descs{n};
    smooth_len_max = max(smooth_len_max, desc.smooth_len_t * this.bufs_in(n).srate);
end

for n = 1 : ndescs

    % Descriptor of current visualization
    desc = this.params.sig_descs{n};

    % Input buffer
    buf = this.bufs_in(n);

    % Get visualizing data from output buffer of the source
    data_sz = desc.vis_win_t * buf.srate;
    [data_vis, sample_idx_vis] = buf.get_last_data(data_sz);
    if isempty(sample_idx_vis)
        continue;
    end

    % Leave only channels used to visualize (if needed)
    if ~isempty(desc.chan_names_data)
        chan_idx_src = find_str_idx(buf.chan_names, desc.chan_names_data);
        data_vis = data_vis(chan_idx_src,:);
        chan_names_used = desc.chan_names_data;
    else
        chan_names_used = buf.chan_names;
    end

    nchan = size(data_vis,1);

    % Calculate power and smooth data if needed
    if desc.need_square
        data_vis = data_vis.^2;
    end
    smooth_len = desc.smooth_len_t * buf.srate;
    if smooth_len
        for m = 1 : nchan
            data_vis(m,:) = smooth(data_vis(m,:), smooth_len);
        end
    end

    % Apply mltiplier
    data_vis = data_vis * desc.k(2) + desc.k(1);
    
    % Spread channels
    if this.params.sig_descs{n}.spread_channels
       
        % Subtract mean level from each channel
        data_vis = bsxfun(@minus, data_vis, mean(data_vis,2));
        
        ymin = this.params.ylim(1);
        ymax = this.params.ylim(2);
        
        nchan = size(data_vis,1);
        
        % Add shift to each channel
        dy = ymin + (ymax - ymin) / (nchan + 2) * (1 + [1 : nchan])';
        data_vis = bsxfun(@plus, data_vis, dy); 
        
    end

    % Cutoff borders
    sample_idx_vis = sample_idx_vis(smooth_len_max/2+1 : end - smooth_len_max/2);
    data_vis = data_vis(:,smooth_len_max/2+1 : end - smooth_len_max/2);

    % Plot data
    for m = 1 : nchan
        style_num = mod(plot_num, length(this.params.line_styles)) + 1;
        if this.params.flip90
            plot(data_vis(m,:), sample_idx_vis, this.params.line_styles{style_num}, 'LineWidth', this.params.line_width);
        else
             plot(sample_idx_vis, data_vis(m,:), this.params.line_styles{style_num}, 'LineWidth', this.params.line_width);
        end
        %disp([max(data_vis(:)), min(data_vis(:))]);
        fprintf('%.10f  %.10f\n', max(data_vis(:)), min(data_vis(:)));
        lgnd = [lgnd, strrep(sprintf('%s.%s', buf.buf_name, chan_names_used{m}), '_', '\_')];
        plot_num = plot_num + 1;
    end

    % Update plot limits
    if ~isempty(sample_idx_vis)
        vmin = min(vmin, sample_idx_vis(1));
        vmax = max(vmax, sample_idx_vis(end));                
    end

end

if (vmin==Inf) || (vmax==-Inf)
    return;
end

% Plot central level
c = this.params.centval;
if this.params.flip90
    plot([c c], [vmin, vmax], 'k');
else
    plot([vmin, vmax], [c c], 'k');
end

if this.params.flip90
    ylim([vmin, vmax]);
    xlim(this.params.ylim);
else
    xlim([vmin, vmax]);
    ylim(this.params.ylim);
end

% Add legend
if this.params.show_legend
    legend(lgnd);
end

%drawnow;    


end
