function make_lastname_abbr


fpath_in = 'X:\from_G\report_2013\lastnames_ecg.txt';

[dirpath_in, fname_in, ext_in] = fileparts(fpath_in);

fid = fopen(fpath_in, 'r');
Q = textscan(fid,'%s');
fclose(fid);

lastnames_in = Q{1};

lastnames_out = {};

for n = 1 : length(lastnames_in)
   
    L = upper(lastnames_in{n});
    lastnames_out{n} = L(1:3);
    
end

fname_out = [fname_in '_abbrev', ext_in];
fpath_out = fullfile(dirpath_in, fname_out);

fid = fopen(fpath_out, 'w');
Q = fprintf(fid, '%s\r\n', lastnames_out{:});
fclose(fid);

end

