function idx = find_str_idx(str_vec_all, str_vec_used)
% Find indices of strings from str_vec_used in str_vec_all

if ~iscell(str_vec_used)
    str_vec_used = {str_vec_used};
end

idx = cellfun(@(s)find(strcmp(s,str_vec_all)), str_vec_used, 'UniformOutput', false);
idx = [idx{:}];
if length(idx) ~= length(str_vec_used)
    fprintf('find_str_idx() -> some strings not found');
    assert(0==1);
end

end

