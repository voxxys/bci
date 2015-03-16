function str = yesno(val, yes_str, no_str)
% Returns yes_str (default: 'yes') if val is true 
% Returns no_str  (default: 'no')  if val is false

if ~exist('yes_str', 'var')
    yes_str = 'yes';
end

if ~exist('no_str', 'var')
    no_str = 'no';
end

if val
    str = yes_str;
else
    str = no_str;
end


end

