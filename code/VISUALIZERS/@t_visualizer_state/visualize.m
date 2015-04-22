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
    
    if ~isempty(desc.chan_names_data)
        chan_idx_src = find_str_idx(buf.chan_names, desc.chan_names_data);
        data_vis = data_vis(chan_idx_src,:);
        chan_names_used = desc.chan_names_data;
    else
        chan_names_used = buf.chan_names;
    end

    nchan = size(data_vis,1);
    
     % Cutoff borders
    sample_idx_vis = sample_idx_vis(smooth_len_max/2+1 : end - smooth_len_max/2);
    data_vis = data_vis(:,smooth_len_max/2+1 : end - smooth_len_max/2);

%     axis vis3d;
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
%     set(gca,'Position',[0 0 1 1]);

    axis off;
    switch data_vis(1,end)
        case 1
            image(this.im_le_ha);
        case 2
            image(this.im_ri_ha);
        case 3
            image(this.im_le_fo);
        case 4
            image(this.im_ri_fo);
        case 5
            image(this.im_to);
        case 6
            image(this.im_rest);
    end
    
    % Plot data
%     for m = 1 : nchan
%         style_num = mod(plot_num, length(this.params.line_styles)) + 1;
%         if this.params.flip90
%             plot(data_vis(m,:), sample_idx_vis, this.params.line_styles{style_num}, 'LineWidth', this.params.line_width);
%         else
%              plot(sample_idx_vis, data_vis(m,:), this.params.line_styles{style_num}, 'LineWidth', this.params.line_width);
%         end
% %         disp([max(data_vis(:)), min(data_vis(:))]);
%         fprintf('%.10f  %.10f\n', max(data_vis(:)), min(data_vis(:)));
%         lgnd = [lgnd, strrep(sprintf('%s.%s', buf.buf_name, chan_names_used{m}), '_', '\_')];
%         plot_num = plot_num + 1;
%     end

    % Update plot limits
%     if ~isempty(sample_idx_vis)
%         vmin = min(vmin, sample_idx_vis(1));
%         vmax = max(vmax, sample_idx_vis(end));                
%     end





%drawnow;    


end
