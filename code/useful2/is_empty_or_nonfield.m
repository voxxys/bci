function res = is_empty_or_nonfield(s, fieldname)
% Check if fieldnames is not a field of structure s or if s.fieldname is empty

res = 0;

if ~isfield(s, fieldname)
    res = 1;
elseif isempty(getfield(s, fieldname))
    res = 1;
end

end

