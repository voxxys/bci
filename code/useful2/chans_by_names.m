function chan_idx = chans_by_names(chan_names_all, chan_names_used)
% CHANS_BY_NAMES Find indices of chan_names_used in chan_names_all

nchans = length(chan_names_used);

chan_idx = zeros(1,nchans);

for n = 1 : nchans
    chan_idx(n) = find(strcmp(chan_names_used{n}, chan_names_all));
end

end

