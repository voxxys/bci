last_req_time = 0;
nsamples_recv_total = 0;
dataset_pos_cur = 1;

ext_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\1305_lisa_re_first.mat');

[data_ext, sample_idx_data] = ext_data.data.get_data();
[states_ext, sample_idx_states] = ext_data.states.get_data();


% % % % 


tcur = toc(t);

         
dt = (tcur - this.last_req_time);
srate = 1000; % !!!
nsamples_recv = floor(dt * srate);


if nsamples_recv == 0
    return;
else
    last_req_time = tcur;
end

% Number of samples in dataset
nsamples_total = size(data_ext,2);

% Check if we need to output more data than we have in dataset
if nsamples_recv > nsamples_total
    log_write('[%s] t_eeg_recv_manager_file::recv_data() -> we have to output more data than we have in dataset - ERROR\n', name);
    assert(0==1);
end

pos_first = dataset_pos_cur;
pos_last = dataset_pos_cur + nsamples_recv - 1;


if pos_last < nsamples_total

    data_input_chunk = data_ext(:, pos_first:pos_last);

else                

    data_input_chunk = horzcat(data_ext(:,pos_first:end),data_ext(:,1:(pos_last - nsamples_total)));     

end


% Update current position in a dataset
dataset_pos_cur = pos_last + 1;
if dataset_pos_cur > nsamples_total
    dataset_pos_cur = pos_last - nsamples_total + 1;
end

% Assign indices to recieved samples
sample_idx_new = nsamples_recv_total + [1 : nsamples_recv];


% Update number of recieved samples
nsamples_recv_total = nsamples_recv_total + nsamples_recv;

