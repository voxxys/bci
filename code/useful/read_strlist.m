function strlist = read_strlist(fpath_in)
% read list of strings from text file

fid = fopen(fpath_in, 'r');
strlist = textscan(fid, '%s');
strlist = strlist{1};
fclose(fid);


end

