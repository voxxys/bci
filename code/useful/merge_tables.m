function merge_tables(fpath_in1, fpath_in2, fpath_out)
% Merge two tables with same rownames 

[data1, col_names1, row_names1, first_col_name1] = read_table(fpath_in1);
[data2, col_names2, row_names2, first_col_name2] = read_table(fpath_in2);

assert(all(strcmp(row_names1(:), row_names2(:))));
assert(strcmp(first_col_name1, first_col_name2));

data_out = [data1 data2];
col_names_out = [col_names1 col_names2];

write_table(fpath_out, data_out, col_names_out, row_names1, first_col_name1);


end

