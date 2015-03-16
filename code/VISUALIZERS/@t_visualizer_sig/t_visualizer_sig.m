classdef t_visualizer_sig < t_visualizer
% Visualize few signals

    properties (SetAccess=protected, GetAccess=public)
        
        % DESCRIPTION OF PARAMETERS
        % params.fig_num - number of figure window to draw at
        % params.subplot_info - coordinates of subplot (a,b,c)
        % params.sig_descs - list of descriptions of channels used to plot
        % params.sig_descs{n}.data_type - 'SIGNAL' | 'STATE'
        % params.sig_descs{n}.stage_name - name of stage used as data source; '[INPUT]' means that sigsrc_stage or stategen_stage will be used
        % params.sig_descs{n}.chan_names_data - names of visualizing channels in source data
        % params.sig_descs{n}.vis_win_t - length of time window to visualize
        % params.sig_descs{n}.smooth_len_t - lenth of smoothing kernel to apply before visualization
        % params.sig_descs{n}.need_square - do we need to square data before visualization
        % params.sig_descs{n}.mult - value multiplier
        % params.line_styles{:} - vector of line styles for each channel
        % params.ylim = [ymin,ymax] - plot limits over y-axis
        % params.flip90 - do we need to flip axes by 90 degrees
        
        % Info about channel locations
        chanlocs;
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        init_spec(this);
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_visualizer_sig(name)
            this = this@t_visualizer(name);
        end

        %===================================
        % Perform visualization
        visualize(this);
        
    end
    
end

