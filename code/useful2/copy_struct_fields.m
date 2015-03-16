function s_out = copy_struct_fields(s_in, s_out, fieldnames_in)

if ~exist('fieldnames_in', 'var')
    fieldnames_in = fieldnames(s_in);
end

for n = 1 : length(fieldnames_in)
    
    fieldname = fieldnames_in{n};
    
    fld = getfield(s_in, fieldname);
    
    %%{
    if exist('s_out', 'var')
        if isfield(s_out, fieldname)
            
            fld_old = getfield(s_out, fieldname);
            
            if isstruct(fld_old)
                fld = copy_struct_fields(fld, fld_old);
            end
            
        end
    end
    %%}
    
    s_out = setfield(s_out, fieldname, fld);    
    
end

end

