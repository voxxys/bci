function params = train_spec(this, buf_data, buf_states, params, train_params)
% buf_data, buf_states - buffers with signal samples and states coresponfing to these samples
% params - initial params of this stage, will be appended during training
% train_params - parameters of training procedure
% train_params.state1, train_params.state2 - 1-st and 2-nd states which we try to separate using CSP
% train_params.lambda - regularization coefficient for covariance matrices


% Get data & states
[X, sample_idx_data] = buf_data.get_data();
%X = bsxfun(@minus, X, mean(X,2));

% Sampling rate
srate = buf_data.srate;

% Highpass signal (>1 Hz)
%{
fmin = 1;
order = 5;
[b_high, a_high] = butter(order, fmin/(srate/2), 'high');
X = filter(b_high, a_high, X, [], 2);
X = bsxfun(@minus, X, mean(X,2));
%}

%{
Xmean = mean(X(:));
Xstd = std(X(:));
mask = (abs(X-Xmean) < 4 * Xstd);
mask = prod(double(mask),1);
idx = find(mask);
X = X(:,idx);
%}

sz = size(X,2);
X = X(:,0.1*sz:end);

% EOG channel
eog_chan_id = find(strcmp(train_params.eog_chan_name, buf_data.chan_names));
Xeog = X(eog_chan_id,:);

% Find artefact intervals
mask_pos = (Xeog >= 0);
mask_neg = (Xeog < 0);
Xeog_pos = Xeog(find(mask_pos));
Xeog_neg = Xeog(find(mask_neg));
bpos = (abs(Xeog .* mask_pos) > (train_params.eog_sigma_mult * sqrt(mean(Xeog_pos.^2))));
bneg = (abs(Xeog .* mask_neg) > (train_params.eog_sigma_mult * sqrt(mean(Xeog_neg.^2))));
artif_idx = find(bpos | bneg);
Xartif = X(:,artif_idx);

% Perform PCA on artifactual data
[W, score, d] = princomp(Xartif');

% Visualize filters/patterns
[X, sample_idx_data] = buf_data.get_data();     % unfiltered again
this.visualize(W, X, params, train_params);

% Ask user what patterns should we discard
str = inputdlg('Which patterns should we discard?')
comp_idx_eog = str2num(str{1});

% Construct filter that excludes artifactual componentss
%Weog = W(:,1:train_params.ncomps_eog);
Weog = W(:,comp_idx_eog);
U = eye(size(W)) - Weog * Weog';
params.params_spec.M = U;

% Names of filters
params.params_spec.filt_names = [];


end