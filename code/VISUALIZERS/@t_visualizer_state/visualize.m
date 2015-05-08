function visualize(this)


ndescs = length(this.params.sig_descs);

% Go to figure
figure(this.params.fig_num);

% Create subplot
subplot(this.params.subplot_info(1), this.params.subplot_info(2), this.params.subplot_info(3)); cla; hold on;
% 
% lgnd = {};
% plot_num = 1;
% 
% vmin = Inf;
% vmax = -Inf;

% Get max smooth_len
smooth_len_max = 0;
for n = 1 : ndescs
    desc = this.params.sig_descs{n};
    smooth_len_max = max(smooth_len_max, desc.smooth_len_t * this.bufs_in(n).srate);
end

delete(findall(gcf,'Tag','toDelete2'));

aggr = [0,0,0,0,0];


for n = 1:ndescs

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

    axis vis3d;
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gca,'Position',[0 0 1 1]);

    axis off;
    
    
    
    if(n < ndescs)
        aggr(n) = mean(data_vis);
        aggr(n) = 1 - aggr(n);

    end
    if(n == ndescs)
        
%     res_vect_x = this.xvect{1}*aggr(1);
%     res_vect_y = this.yvect{1}*aggr(1);
%     this.an = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an,'Color',[0.5 0.5 0.5])
%     
%     res_vect_x = this.xvect{2}*aggr(2);
%     res_vect_y = this.yvect{2}*aggr(2);
%     this.an = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an,'Color',[0.5 0.5 0.5])
%     
%     res_vect_x = this.xvect{3}*aggr(3);
%     res_vect_y = this.yvect{3}*aggr(3);
%     this.an = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an,'Color','red')
%     
%     res_vect_x = this.xvect{4}*aggr(4);
%     res_vect_y = this.yvect{4}*aggr(4);
%     this.an = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an,'Color','red')
%     


% % % % % % % 

%     res_vect_x = this.xvect{5}*aggr(5);
%     res_vect_y = this.yvect{5}*aggr(5);
%     this.an = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an,'Color',[0.5 0.5 0.5])
    
%     res_vect_x = this.xvect{5}*aggr(3);
%     res_vect_y = this.yvect{5}*aggr(3);
%     this.an = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an,'Color',[0.5 0.5 0.5])




%     res_vect_x = this.xvect{1}*aggr(1) + this.xvect{2}*aggr(2) +  this.xvect{3}*aggr(3) +  this.xvect{4}*aggr(4) +  this.xvect{5}*aggr(5);
%     res_vect_y = this.yvect{1}*aggr(1) + this.yvect{2}*aggr(2) +  this.yvect{3}*aggr(3) +  this.yvect{4}*aggr(4) +  this.yvect{5}*aggr(5);
%     res_vect_x = 0.2 * res_vect_x;
%     res_vect_y = 0.2 * res_vect_y;
%     this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%     set(this.an2,'Color','blue')


        switch data_vis(1,end)
            case 1
                delete(findall(gcf,'Tag','toDelete'));
                image(this.im_le_ha);
                if(ndescs == 2)
                    res_vect_x = this.xvect{1}*aggr(1);
                    res_vect_y = this.yvect{1}*aggr(1);
                    this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                    set(this.an2,'Color','blue')
                    
                else
                    res_vect_x = this.xvect{1}*aggr(1);
                    res_vect_y = this.yvect{1}*aggr(1);
                    this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                    set(this.an2,'Color','blue')
                end
                
                this.an = annotation('arrow',this.xvect{1}+0.5,this.yvect{1}+0.5,'Tag','toDelete');
           
            case 2
                delete(findall(gcf,'Tag','toDelete'));
                image(this.im_ri_ha);
                if(ndescs == 2)
                    res_vect_x = this.xvect{2}*(1-aggr(1));
                    res_vect_y = this.yvect{2}*(1-aggr(1));
                    this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                    set(this.an2,'Color','blue')
                else
                    res_vect_x = this.xvect{2}*aggr(2);
                    res_vect_y = this.yvect{2}*aggr(2);
                    this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                    set(this.an2,'Color','blue')
                end
                this.an = annotation('arrow',this.xvect{2}+0.5,this.yvect{2}+0.5,'Tag','toDelete');
            case 3
                delete(findall(gcf,'Tag','toDelete'));
                image(this.im_le_fo);
                res_vect_x = this.xvect{3}*aggr(3);
                res_vect_y = this.yvect{3}*aggr(3);
                this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                set(this.an2,'Color','blue')
                
                this.an = annotation('arrow',this.xvect{3}+0.5,this.yvect{3}+0.5,'Tag','toDelete');
            case 4
                delete(findall(gcf,'Tag','toDelete'));
                image(this.im_ri_fo);
                res_vect_x = this.xvect{4}*aggr(4);
                res_vect_y = this.yvect{4}*aggr(4);
                this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                set(this.an2,'Color','blue')
                
                this.an = annotation('arrow',this.xvect{4}+0.5,this.yvect{4}+0.5,'Tag','toDelete');
            case 5
                delete(findall(gcf,'Tag','toDelete'));
                image(this.im_to);
%                 res_vect_x = this.xvect{5}*aggr(5);
%                 res_vect_y = this.yvect{5}*aggr(5);
%                 this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
%                 set(this.an2,'Color','blue')
                
                res_vect_x = this.xvect{5}*aggr(3);
                res_vect_y = this.yvect{5}*aggr(3);
                this.an2 = annotation('arrow',res_vect_x + 0.5,res_vect_y + 0.5,'Tag','toDelete2');
                set(this.an2,'Color','blue')
                
                this.an = annotation('arrow',this.xvect{5}+0.5,this.yvect{5}+0.5,'Tag','toDelete');
            case 6
                delete(findall(gcf,'Tag','toDelete'));
                image(this.im_rest);
                
        end
        
        if(this.params.hidetaskarrow == 1)
            delete(findall(gcf,'Tag','toDelete'));
        end
        
        if(this.params.hidepredictionarrow == 1)
            delete(findall(gcf,'Tag','toDelete2'));
        end
    
    
    end
    
   
end

pause(0.01);
%     delete(findall(gcf,'Tag','toDelete'));

%     this.time = this.time + 0.1;
%     x_coord = 0.5 + 0.5*sin(this.time);
%     
%     this.an = annotation('arrow',[0.5,x_coord],[0.5,0.5],'Tag','toDelete');

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
