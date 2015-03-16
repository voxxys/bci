%===================================
% Get data from buffer
function [data_out, sample_idx_out] = get_data(obj, sample_id_base, data_sz, nsamples_prev)
% Read data_sz samples starting nsamples_prev before the sample with index == sample_id_base

assert(obj.ready == 1);

%init_var('data_sz', 'Inf');
%init_var('nsamples_prev', '0');

if ~exist('data_sz', 'var')
    data_sz = Inf;
end
if ~exist('nsamples_prev', 'var')
    nsamples_prev = 0;
end

data_out = [];
sample_idx_out = [];

if data_sz == 0
    return;
end

assert(data_sz > nsamples_prev);

sz_max = length(obj.sample_idx);    % size of buffer
sz_used = obj.sz_used;              % number of samples in buffer

pos_first = obj.pos_first;
pos_last = obj.pos_last;

% If buffer is empty
if sz_used == 0
    return;
end

% Index of base sample not set - beginning becomes a base
if ~exist('sample_id_base', 'var')
    sample_id_base = obj.sample_idx(pos_first);
end

pos1 = [];          % position of 1-st sample to read
sz0 = [];           % number of samples that precede 1-st reading sample
sz_zerofill = [];   % number of output samples we must fill with zeroes

% Find chunk of data (1-st or 2-nd) that can contain sample with index == sample_id_base
if pos_first <= pos_last    % linear or non-closed ring buffer - search in one chunk of data  
    
    idx = find(obj.sample_idx(pos_first : pos_last) >= sample_id_base);
    chunk_num = 1;

else                        % closed ring buffer - search in 2 chunks of data  
    
    idx = find(obj.sample_idx(pos_first : end) >= sample_id_base);    
    if ~isempty(idx)	% sample_id_base found in 1-st chunk
        chunk_num = 1;
    else                % sample_id_base not found in 1-st chunk
        idx = find(obj.sample_idx(1 : pos_last) >= sample_id_base);
        chunk_num = 2;
    end
    
end

% All samples have index < sample_id_base
if isempty(idx)
    return;
end

if chunk_num == 1
    
    % Get position of sample with index == sample_id_base
    pos_base = pos_first + idx(1) - 1;
    
    % Get position of 1-st sample to read
    pos1 = pos_base - nsamples_prev;
    pos1 = max(pos1, pos_first);
    
    % Get number of output samples we must fill with zeroes
    sz_zerofill = pos1 - (pos_base - nsamples_prev);
    
    % Get number of samples that precede 1-st reading sample 
    sz0 = pos1 - pos_first;
    
else

    % Get position of sample with index == sample_id_base
    pos_base = idx(1);
    
    % Get position of 1-st sample to read
    pos1 = pos_base - nsamples_prev;
    
    if pos1 <= 0    % 1-st sample to read is in the 1-st chunk
        
        % Update position of 1-st sample to read
        pos1 = sz_max + pos1;
        pos10 = pos1;
        pos1 = max(pos1, pos_first);
        
        % Get number of samples that precede 1-st reading sample
        sz0 = pos1 - pos_first;
        
        % Get number of output samples we must fill with zeroes
        sz_zerofill = pos1 - pos10; 
        
    else            % 1-st sample to read is in the 2-nd chunk
        
        % Get number of samples that precede 1-st reading sample 
        sz0 = sz_max - pos_first + pos1;
        
        % Get number of output samples we must fill with zeroes
        sz_zerofill = 0;
        
    end
    
end

% Get number of samples to read
data_sz_in = data_sz - sz_zerofill;
data_sz_in = min(data_sz_in, sz_used - sz0);

% Number of output samples
data_sz_out = data_sz_in + sz_zerofill;

% Allocate output data
sample_idx_out = zeros(1, data_sz_out);
data_out = zeros(size(obj.data,1), data_sz_out);

% First sz_zerofill data values will be zeroes, first sz_zerofill sample_idx will be -sz_zerofill..-1
sample_idx_out(1 : sz_zerofill) = [-sz_zerofill : -1];

pos2 = pos1 + data_sz_in - 1;

if pos2 <= sz_max   % Read in 1 chunk

    sample_idx_out(sz_zerofill+1 : end) = obj.sample_idx(pos1:pos2);
    data_out(:, sz_zerofill+1 : end) = obj.data(:,pos1:pos2);

else                % Read in 2 chunks                

    % Sizes of 2 chunks splitted by the end of buffer
    sz1 = sz_max - pos1 + 1;
    sz2 = data_sz_in - sz1;

    % Read data from 2 chunks
    for n = [1, 2]

        if n == 1
            pos1 = pos1;                % position of 1-st sample in buffer
            pos2 = sz_max;              % position of last sample in buffer
            out_pos1 = 1;               % position of 1-st sample in output data
            sz = sz1;                   % size of chunk
        else
            pos1 = 1;                   % position of 1-st sample in buffer
            pos2 = sz2;                 % position of last sample in buffer
            out_pos1 = sz1 + 1;         % position of 1-st sample in output data
            sz = sz2;                   % size of chunk
        end

        % Append chunk
        sample_idx_out(sz_zerofill + [out_pos1 : out_pos1+sz-1]) = obj.sample_idx(pos1:pos2);
        data_out(:, sz_zerofill + [out_pos1 : out_pos1+sz-1]) = obj.data(:, pos1:pos2);

    end

end

end


