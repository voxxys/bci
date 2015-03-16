%===================================
% Add data to buffer
function append(obj, sample_idx_new, data_new)

assert(obj.ready == 1);

sz_new = size(data_new, 2);
sz_max = length(obj.sample_idx);
sz_used = obj.sz_used;

assert(length(sample_idx_new) == sz_new);
assert(sz_new <= sz_max);

pos_last_new = obj.pos_last + sz_new;

if pos_last_new <= sz_max

    % Append data in 1 chunk
    obj.sample_idx(obj.pos_last+1 : pos_last_new) = sample_idx_new;
    obj.data(:, obj.pos_last+1 : pos_last_new) = data_new;

else

    % Check if not enough space in non-ring buffer
    if strcmp(obj.buf_type,'linear')
        fprintf('t_sample_buf::append() -> buffer overflow\n');
        assert(0==1);
    end

    % Sizes of 2 chunks splitted by the end of buffer
    sz1 = sz_max - obj.pos_last;
    sz2 = sz_new - sz1;

    % Append data in 2 chunks
    for n = [1, 2]

        if n == 1
            pos1 = obj.pos_last + 1;    % position of 1-st new sample in buffer
            pos2 = sz_max;              % position of last new sample in buffer
            in_pos1 = 1;                % position of 1-st sample in input data
            sz = sz1;                   % size of chunk
        else
            pos1 = 1;                   % position of 1-st new sample in buffer
            pos2 = sz2;                 % position of last new sample in buffer
            in_pos1 = sz1 + 1;          % position of 1-st sample in input data
            sz = sz2;                   % size of chunk
        end

        % Append chunk
        obj.data(:, pos1:pos2) = data_new(:, in_pos1 : in_pos1+sz-1);
        obj.sample_idx(pos1:pos2) = sample_idx_new(in_pos1 : in_pos1+sz-1);

    end

    pos_last_new = sz2;

end

% Update buffer size and first & last positions
obj.pos_last = pos_last_new;
obj.sz_used = sz_used + sz_new;
if obj.pos_first == 0
    obj.pos_first = 1;
end
if obj.sz_used > sz_max
    obj.sz_used = sz_max;
    if obj.pos_last == sz_max
        obj.pos_first = 1;
    else
        obj.pos_first = obj.pos_last + 1;
    end
end

end
