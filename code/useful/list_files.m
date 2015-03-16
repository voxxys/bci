function [fnames_lst, dirpath_in] = list_files(dirpath_in, mask)
% Return list of files from a given folder according to given mask
% If folder not specified -- open dialog
% [fnames_lst, dirpath_in] = list_files(dirpath_in, mask)

if ~exist('mask', 'var')
    mask = '*.*';
end

if ~exist('dirpath_in', 'var')
    dirpath_in = [];
end

if isempty(dirpath_in);

    % If input folder not set - open dialog
    [fnames_lst, dirpath_in] = uigetfile( '*.set', 'Select file(s)', 'MultiSelect', 'on' );
    if isnumeric(fnames_lst)
        if fnames_lst == 0
            log_write('No datasets selected\n');
            fnames_lst = [];
            dirpath_in = [];
            return;
        end
    end
    
    % If only one file selected -- converst string to cell
    if ~iscell(fnames_lst)
        fnames_lst = {fnames_lst};
    end
    
else
    
    fnames_lst = dir(fullfile(dirpath_in, mask));
    fnames_lst = {fnames_lst.name};
    
end


end

