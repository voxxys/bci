classdef t_visualizer_scalp < t_visualizer
% Visualize scalp distribution of a signal power averaged over some time window

    properties (SetAccess=protected, GetAccess=public)
        
        % DESCRIPTION OF PARAMETERS
        % params.fig_num - number of figure window to draw at
        % params.fpath_chanlocs - path to the file with channel locations
        % params.scalpdata_descs - list of descriptions of scalp data used to plot
        % params.scalpdata_descs{n}.name - name of n-th plot
        % params.scalpdata_descs{n}.src_type - type of data source: 'recv_man' | 'stategen' | 'sigproc_chain' | 'stateproc_chain'
        % params.scalpdata_descs{n}.procstage_name - name of processing stage used as data source (if src_type == 'sigproc_chain' | 'stateproc_chain')
        % params.scalpdata_descs{n}.chan_names_data - names of visualizing channels in source data
        % params.scalpdata_descs{n}.chan_names_chanlocs - names of visualizing channels in chanlocs structure
        % params.scalpdata_descs{n}.subplot_info - coordinates of subplot (a,b,c)
        % params.scalpdata_descs{n}.maplimits = [xmin1, xmax1; xmin2, xmax2] - value limits of topoplot
        % params.scalpdata_descs{n}.chan_mask - mask of channels to show; others will be nulled
        % (minimum / maximum will vary from xmin1/xmax1 to xmin2/xmax2, according to slider position)
        
        % Info about channel locations
        chanlocs;
        
        % Current value limits of each topoplot
        maplimits_cur;
        
    end
    
    methods (Access=protected)
        
        %===================================
        % Slider callback function
        function slider_cb(this, hslider, n)
            
            % Get position of slider (from 0 to 1)
            slider_val = get(hslider, 'value');
            
            maplimits = this.params.scalpdata_descs{n}.maplimits;
            this.maplimits_cur{n}(1) = maplimits(1,1) + (1 - slider_val) * (maplimits(2,1) - maplimits(1,1));
            this.maplimits_cur{n}(2) = maplimits(1,2) + (1 - slider_val) * (maplimits(2,2) - maplimits(1,2));
            
        end
        
        %===================================
        % Class-specific initialization (one can reimplement it in child class)
        init_spec(this)
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_visualizer_scalp(name)
            this = this@t_visualizer(name);
        end

        %===================================
        % Perform visualization
        visualize(this);
        
    end
    
end

