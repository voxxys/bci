function visualize(this, W, X, params, train_params)
            
% Load channel locations
EEG1 = load_dataset(train_params.fpath_chanlocs);
chanlocs = EEG1.chanlocs;
clear EEG1;

% Visualize
figure;
set(gcf, 'units', 'normalized', 'outerposition', [0 0.05 1 0.95]);
nx = 6;
ny = 6;
for m = 1 : size(W,1);
    V = W(:,m);
    subplot(ny,nx,m);
    topoplot(V, chanlocs);
end

% Visualize initial & clean data
%{
Xclean = this.params.filt_descs{1}.M * X;
d = 1.5 * (max(X(:)) - min(X(:)));
nchan = size(X,1);
A = bsxfun(@plus, X, [1:nchan]'*d);
Aclean = bsxfun(@plus, Xclean, [1:nchan]'*d);
figure; hold on;
plot(A', 'b'); plot(Aclean', 'r');
%}

end