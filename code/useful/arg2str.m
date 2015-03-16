function str = args2str(arg)
% Converts sequence {'key1','val1','key2',val2',...} to string

str = '';

s = struct(arg{:});
fn = fieldnames(s);

for n = 1 : length(fn)
    val = getfield(s,fn{n});
    if strcmp(class(val),'char')
        valstr = val;
    elseif strcmp(class(val),'double')
        valstr = num2str_new(val,5,2,2);
    else
        valstr = 'unknown';
    end
    str = [str sprintf('%s:  %s\n', fn{n}, valstr)];
end


