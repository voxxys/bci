classdef t_procstage_graph < handle
% Graph of signal processing stages

    % Parameters
    properties (SetAccess=private, GetAccess=public)
        
        % Name of this object
        name;
        
        % Descriptors of stages
        % stage_descs(n).stage_name - name of stage
        % stage_descs(n).obj_type - type of stage processing object
        % stage_descs(n).params - parameters of stage
        % stage_descs(n).params.inp_descs(m).inp_stage_name - name of stage that correspond to m-th input ('[INPUT]' means inp_stage)
        % stage_descs(n).params.inp_descs(m).inp_stage_id - index of stage that correspond to m-th input (filled during init() call) (0 means inp_stage)
        %stage_descs;
        
        % Descriptors of stage connectivity: names, input names, indices (created during init())
        stageconn_descs;
        
        % Descriptors of stages: names, processing types, params (created during create_stage())
        stage_descs;
        
        % Input stage (created elsewhere)
        outer_inp_stage;
        
        % Name of input stage buffer to use
        outer_inp_buf_name;
        
    end
        
    properties (SetAccess=private, GetAccess=public)
        
        % Stage objects
        stages;
        
        % Order of stage usage
        stage_order;
        
    end
    
    methods (Access=public)
        
        %===================================
        % Constructor
        function this = t_procstage_graph(name)
           this.name = name;
           this.stageconn_descs = repmat(struct('stage_name',[],'inp_stage_names',[],'inp_stage_idx',[],'inp_stage_active_flags',[]), 0, 0);
           this.stage_descs = repmat(struct('stage_name',[],'obj_type',[],'params',[]), 0, 0);
           this.stages = t_sigproc_stage.empty(0);
        end
        
        %===================================
        % Set outer input stage
        function set_outer_inp_stage(this, outer_inp_stage, outer_inp_buf_name)
            this.outer_inp_stage = outer_inp_stage;
            this.outer_inp_buf_name = outer_inp_buf_name;
        end
        
        %===================================
        % Initialize
        function init(this, stage_descs)
           
            % Init descriptors of stage connectivity
            this.init_stageconn_descs(stage_descs);
            
            % Convert input stage names to indices
            this.get_inp_stage_idx();
            
            % Find order of stage usage
            this.find_stage_order();
            
            % Create empty array of stages
            this.stages = t_sigproc_stage.empty(0);
            
        end

        %===================================
        % Create stage
        stage_desc = create_stage(this, stage_num, stage_desc);
        
    end
    
    methods (Access = private)
        
        %===================================
        % Initialize descriptors of stage connectivities
        init_stageconn_descs(this, stage_descs);
        
        %===================================
        % Convert input stage names to indices
        get_inp_stage_idx(this);
        
        %===================================
        % Find stage order
        find_stage_order(this);
        
    end
    
    methods (Access=public)
        
        %===================================
        %{
        % Get parameters of stage inputs
        function inp_params = get_stage_inp_params(this, stage_num)
           
            stageconn_desc = this.stageconn_descs(stage_num);
            
            for n = 1 : length(stageconn_desc.inp_stage_idx)
                
                inp_stage_id = stageconn_desc.inp_stage_idx(n);
                
                if inp_stage_id == 0
                    inp_params{n} = this.outer_inp_stage.params;
                else
                    inp_params{n} = this.stage_descs(inp_stage_id).params;
                end 
                
            end
                
        end
        %}
        
        %===================================
        % Get input buffer of the stage
        function inp_bufs = get_stage_inp_bufs(this, stage_num)
           
            inp_bufs = t_sample_buf.empty(0);
            
            stageconn_desc = this.stageconn_descs(stage_num);
            
            for n = 1 : length(stageconn_desc.inp_stage_idx)
                
                % Get buffers only for active inputs
                if ~stageconn_desc.inp_stage_active_flags(n)
                    continue;
                end
                
                inp_stage_id = stageconn_desc.inp_stage_idx(n);

                if inp_stage_id == 0        % outer input
                    inp_bufs(end+1) = getfield(this.outer_inp_stage, this.outer_inp_buf_name);
                else                        % inner input
                    inp_bufs(end+1) = getfield(this.stages(inp_stage_id), 'buf_out');
                end

            end
                
        end
        
        %===================================
        % Check if all output stages of given stage are created
        function res = is_out_stages_created(this, stage_num)
            
            res = 1;
            
            if stage_num
                % Check if given stage itself is created
                if stage_num > length(this.stages)
                    res = 0;
                    return;
                end
                if ~this.stages(stage_num).ready
                   res = 0;
                   return;
                end
            end
            
            for n = 1 : length(this.stageconn_descs)
                
               stages_inp_cur = this.stageconn_descs(n).inp_stage_idx;
               
               % If n-th stage is the output of a gvent stage - check if it is created
               if any(stages_inp_cur == stage_num)
                   
                   if n > length(this.stages)
                       res = 0;
                       return;
                   end                   
                   if ~this.stages(n).ready
                       res = 0;
                       return;
                   end
                   
               end
               
            end
            
        end
        
        %===================================
        % Get stage by name
        function stage = stage_by_name(this, stage_name)
           
            for n = 1 : length(this.stages)

                if strcmp(this.stages(n).stage_name, stage_name)
                    stage = this.stages(n);
                    return;
                end

            end

            stage = [];

        end
        
    end
    
end

