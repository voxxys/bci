function c = struct2cell_new(s)
% Converts structure to the sequence {name1, value1,...}

c = [fieldnames(s) struct2cell(s)]';
c = c(:);

end

