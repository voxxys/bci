%===================================
% Allocate data
function allocate(obj, chan_names, nsamples, buf_type, srate)

assert((strcmp(buf_type,'ring')==1) || (strcmp(buf_type,'linear')==1));

nchans = length(chan_names);

obj.data = zeros(nchans, nsamples);
obj.sample_idx = zeros(1, nsamples);
obj.pos_first = 0;
obj.pos_last = 0;
obj.sz_used = 0;
obj.chan_names = chan_names;
obj.buf_type = buf_type;
obj.srate = srate;
obj.ready = 1;

end

