function eeglab_path = find_eeglab_path()
% Find path to eeglab root folder in matlab PATH variable

% This is scary
Q = regexpi(path,'[A-Za-z]\:[A-Za-z_0-9\\.-]+eeglab[_0-9]+[A-Za-z_0-9]+','match');
Q = unique(Q);
eeglab_path = Q{1};


end

