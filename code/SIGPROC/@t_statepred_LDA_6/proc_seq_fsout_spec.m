function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)


nchan = size(data_in,1);
nsamples = size(data_in,2);
state_ids = this.params.params_spec.state_ids;
data_out = zeros(2,nsamples);

rating = zeros(size(state_ids,2),size(data_in,2));

numlda = 1;
for state_num_i = 1 : size(state_ids,2)
    for state_num_j = 1 : size(state_ids,2)
        if(state_num_i ~= state_num_j)
            rating(state_num_j,:) = rating(state_num_j,:) + data_in(2*numlda,:);
            
            
            
            numlda = numlda + 1;
        end
    end
end


% 
% idx = (D > 0) + 1;
% data_out(1,:) = this.params.params_spec.state_labels(idx);
% 
% 
% data_out(2,:) = 1 ./ (1 + exp(-D/1));

[val, ind] = max(rating);
val = val/3;

data_out(1,:) = state_ids(ind);
data_out(2,:) = val;


end