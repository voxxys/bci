function init_spec(this)


% Load channel locations
EEG1 = load_dataset(this.params.fpath_chanlocs);
this.chanlocs = EEG1.chanlocs;
clear EEG1;


figure(this.params.fig_num);

% Create sliders
for n = 1 : length(this.params.scalpdata_descs)

    % Plot "coordinates"
    subplot_info = this.params.scalpdata_descs{n}.subplot_info;
    nplots_y = subplot_info(1);
    nplots_x = subplot_info(2);
    plot_x = mod(subplot_info(3) - 1, nplots_x) + 1;
    plot_y = floor((subplot_info(3) - 1) / nplots_x) + 1

    % Margins (plot - subplot)

    % Margins (subplot - slider)
    dx = 0.05;
    dy = 0.1;

    % Width and height of slider
    w = 0.02;
    h = (1 / nplots_y) - 2 * dy;

    % Position of slider
    %x = (plot_x - 1) / nplots_x + dx;
    %y = (nplots_y - plot_y) / nplots_y + dy;

    subplot(subplot_info(1), subplot_info(2), subplot_info(3));
    pos = get(gca, 'position');
    x = pos(1)-0.01;
    y = pos(2);

    % Create slider
    figure(this.params.fig_num)
    hslider = uicontrol('style', 'slider', 'position', [x,y,w,h], 'min', 0, 'max', 1,...
        'units', 'normalized', 'callback', @(hslider,eventdata,handles)this.slider_cb(hslider, n));
    this.slider_cb(hslider, n);

end


end
