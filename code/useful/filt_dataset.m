function EEG = filt_dataset(EEG, filt_low, filt_high)
% Apply lowpass and highpass filters to dataset,
% update history and description
% If filt_low or filt_high == 0 - don't use it

% Apply filters to data
if filt_low
    [EEG, cmnd] = pop_eegfilt(EEG, filt_low, 0, [], [0], 0, 0, 'fir1', 0);
    EEG = eegh(cmnd, EEG);
end
if filt_high
    [EEG, cmnd] = pop_eegfilt(EEG, 0, filt_high, [], [0], 0, 0, 'fir1', 0);
    EEG = eegh(cmnd, EEG);
end

% Update description
if filt_high
    comm_new =  sprintf('Data filtered: %f - %f Hz', filt_low, filt_high);
else
    comm_new =  sprintf('Data filtered: %f - Inf Hz', filt_low);
end
EEG.comments = pop_comments(EEG.comments, '', strvcat(' ', comm_new));
   

end

