function EEG = append_comments(EEG, str)
% Append EEG dataset comments

 EEG.comments = pop_comments(EEG.comments, '', strvcat(' ', str), 1);

end

