function str = num2str_new(x, nmax, nl, nr)
% Converts 1-d numeric array to string
% Usage: str = num2str_new(x, nmax, nl, nr)
% If number of elements > nmax, then output in form:
% <first nl elements> ... <last nr elements>

if (ndims(x)==2) && ((size(x,1)==1) || (size(x,2)==1))
    if length(x) <= nmax
        str = num2str(x);
    else
        str = [num2str(x([1:nl])), ' ... ', num2str(x([end-nr+1:end]))];
    end
else
    str = '<Matrix>';       % more than 1 dimension
end


end

