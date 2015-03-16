function data_out = correct_baseline(data, sample_times, bl_interval)
% data(channels,samples,trials) -- input data
% sample_times -- time of each data sample (in ms)
% bl_interval = (t_start, t_end) -- baseline interval (in ms)

% Default baseline is prestimulus
if ~exist('bl_interval', 'var')
    bl_interval = [min(sample_times), 0];
end

sample_idx = find((sample_times >= bl_interval(1)) &...
    (sample_times <= bl_interval(2)));

baseline = mean(data(:,sample_idx,:), 2);   % mean over baseline samples

data_out = bsxfun(@minus, data, baseline);


end

