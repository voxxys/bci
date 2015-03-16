function chan_id = chan_by_name(EEG, chan_name)
% CHAN_BY_NAME Returns channel id by its name
% Usage: chan_id = chan_by_name(EEG, chan_name)

if iscell(chan_name)
    chan_id = cellfun(@(s)find(strcmp({EEG.chanlocs.labels},s)), chan_name);
else
    %chan_id = find(ismember({EEG.chanlocs.labels}, chan_name));
    chan_id = find(strcmp({EEG.chanlocs.labels}, chan_name));
end

end

