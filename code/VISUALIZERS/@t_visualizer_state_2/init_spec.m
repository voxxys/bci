function init_spec(this)

% Get input buffers by data type (signal / state) + stage name + buffer name
for n = 1 : length(this.params.sig_descs)

    sig_desc = this.params.sig_descs{n};

    % Type of input: signal or state
    data_type = sig_desc.data_type;

    % Name of input stage
    stage_name = sig_desc.stage_name;

    % Name of input buffer
    if isfield(sig_desc, 'buf_name')
        buf_name =sig_desc.buf_name;
    else
        buf_name = [];
    end
    
    % Get input buffer
    this.bufs_in(n) = this.get_exp_buf(data_type, stage_name, buf_name);
    
    this.time = 0;

end

    angle_rad = {pi/2 + 2*pi/5, -2*pi/5+pi/2, pi/2 + 4*pi/5 + pi/10 - pi/40, pi/2 + 6*pi/5 - pi/10 + pi/40, pi/2};

    for i = 1:5
        v{i} = [cos(angle_rad{i}),sin(angle_rad{i})];
        this.xvect{i} = [0,0.5*v{i}(1)];
        this.yvect{i} = [0,0.5*v{i}(2)];
%         this.xvect{i} = this.xvect{i}+0.5;
%         this.yvect{i} = this.xvect{i}+0.5;

    end
    
% % % % % % % % % % % % % % % % % % % % % % % % %     
    this.xvect{1} = 0.2*this.xvect{1};
    this.xvect{2} = 0.2*this.xvect{2};
    this.xvect{3} = 0.35*this.xvect{3};
    this.xvect{4} = 0.35*this.xvect{4};
    this.xvect{5} = 0.3*this.xvect{5};
    
    this.yvect{1} = 0.2*this.yvect{1};
    this.yvect{2} = 0.2*this.yvect{2};
    this.yvect{3} = 0.35*this.yvect{3};
    this.yvect{4} = 0.35*this.yvect{4};
    this.yvect{5} = 0.3*this.yvect{5};
% % % % % % % % % % % % % % % % % % % % % % % % %     

    this.im_to = flipud(imread('to.jpg'));
    this.im_ri_fo = flipud(imread('ri_fo.jpg'));
    this.im_le_fo = flipud(imread('le_fo.jpg'));
    this.im_ri_ha = flipud(imread('ri_ha.jpg'));
    this.im_le_ha = flipud(imread('le_ha.jpg'));
    this.im_rest = flipud(imread('rest.jpg'));

end
