function [data,states,sample_idx] = removeoutliers(data,states,sample_idx,sds)

    row_mean = mean(data,2);
    row_std = std(data,0,2);

    mask = (abs(data-row_mean(:,ones(1,size(data,2)))) < sds * row_std(:,ones(1,size(data,2))));

    idx = ~sum(~mask,1);

    idx = find(idx);

%     disp(size(idx,2)/size(data,2));

    data = data(:,idx);
    states = states(idx);
    sample_idx = sample_idx(idx);


end