function data_out = proc_seq_fsout_spec(this, sample_idx_in, data_in)

nprev = this.params.nsamples_prev;

nchan = size(data_in,1);
nsamples = size(data_in,2);

cov_mat = this.params.params_spec.cov_mat;

cm_1 = cov_mat(:,:,1);
cm_2 = cov_mat(:,:,2);

data_out = zeros(2, nsamples);

for n = 1:size(data_out,2)
    dat_chunk = data_in(:,(max(1,n - nprev)):n);

    data_cm = dat_chunk * dat_chunk' / size(dat_chunk,2);
    rd_1 = abs(RiemDist(data_cm,cm_1)); 
    rd_2 = abs(RiemDist(data_cm,cm_2));
    
    if(rd_1 == min(rd_1,rd_2))
        idx_min = 1;
    else
        idx_min = 2;
    end

%     [riem_min, idx_min] = min(rd_1,rd_2);
    
    data_out(1,n) = rd_1/rd_2;
    data_out(2,n) = this.params.params_spec.state_labels(idx_min);
end


end