function log_write(varargin)
% Writes to console and to the file given by global descriptor flog

    global flog;
    
    term_old = sprintf('\n');
    term_new = sprintf('\r\n');
    
    str = sprintf(varargin{:});
    str = strrep(str, term_old, term_new);
    str = strrep(str, '\', '\\');

    try
        %fprintf(flog, varargin{:});
        fprintf(flog, str);
    end
    
    fprintf(varargin{:});
    %fprintf(str);
    
end


