function res = isfield2(s, fieldnames)
% Check existence of fieldname chain in structure

res = 1;

for n = 1 : length(fieldnames)
   
    if ~isfield(s, fieldnames{n})
        res = 0;
        return;
    end
    
    s = getfield(s, fieldnames{n});
    
end

end

