function log_close()
% Closes global file descriptor flog

global flog;

try
    fclose(flog);
    flog = 0;
end


end

