function write_table(fpath_out, data, col_names, row_names, first_col_name, prec)
% Usage: write_table(fpath_out, data, col_names, row_names, first_col_name, prec)

% Decimal precision of output
init_var('prec', '5');


fid = fopen(fpath_out, 'w');

% Write header
fprintf(fid, '%s\t', first_col_name);
fprintf(fid, '%s\t', col_names{1:end-1});
fprintf(fid, '%s\n', col_names{end});

% Write data
for n = 1 : length(row_names)
   
    % Lastname
    fprintf(fid, '%s\t', row_names{n});
    
    % Numeric data
    if length(col_names)==1
        fprintf(fid, sprintf('%%.0%if\n', prec), data(n,1));
    else
        fprintf(fid,  sprintf('%%.0%if\t', prec), data(n,1:end-1));
        fprintf(fid,  sprintf('%%.0%if\n', prec), data(n,end));
    end
    
end

fclose(fid);

end

