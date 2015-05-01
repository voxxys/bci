function visualize(this, data1_cur, data2_cur, params, train_params)

% Load channel locations
EEG1 = load_dataset(train_params.fpath_chanlocs);
chanlocs = EEG1.chanlocs;
clear EEG1;

% Number of subplots
nx = 3;
ny = 2;

% What to visualize
vis_patterns = 1;
if strcmp(train_params.vis_type, 'patterns')
    vis_patterns = 1;
elseif strcmp(train_params.vis_type, 'filters')
    vis_patterns = 0;
else
    assert(0==1);
end

%params.params_spec.filt_names - names of filters
% params.params_spec.M - filter matrix (filters x channels)

M = params.params_spec.M;
Minv = params.params_spec.Minv;

nfilt = size(M,1);

figure; clf;
set(gcf, 'units', 'normalized', 'outerposition', [0 0.05 1 0.95]);

% Visualize filters or patterns
for m = 1 : nfilt

    % What to visualize
    if vis_patterns
        V = Minv(:,m);
    else
        V = M(m,:);
    end

    % Channel locations
    chan_idx_chanlocs = find_str_idx(lower({chanlocs.labels}), lower(train_params.chan_names_chanlocs));
    chanlocs_vis = chanlocs(chan_idx_chanlocs);

    % Visualization
    subplot(ny,nx,m);
    topoplot(V, chanlocs_vis);
    title(sprintf('%s  %s(%i)', strrep(this.name,'_','\_'), train_params.vis_type, m));

end

% Tranform data
X1 = data1_cur;
X2 = data2_cur;
Y1 = M * X1;
Y2 = M * X2;

% Visualize tranformed data
figure; clf; hold on;
plot(Y1(1,:), Y1(end,:), 'b.');
plot(Y2(1,:), Y2(end,:), 'r.');
legend('State 1', 'State 2');
xlabel('CSP\_1');
ylabel('CSP\_end');
title(sprintf('First and last pattern activations (%s)', strrep(this.name,'_','\_')));


end