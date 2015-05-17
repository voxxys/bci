function [ Result] = ClassifyPair(data, indTr1,indTr2,Lambda,Tsmooth,Ncomp)
    
    M12 = [];
    G12 = [];
        % calculate class covariances
    data_1_train = data(:,indTr1);
    data_2_train = data(:,indTr2);

    C10 = data_1_train * data_1_train' / size(data_1_train,2);
    C20 = data_2_train * data_2_train' / size(data_2_train,2);

    nchan = size(C10,1);

    %regularize covariances
    C1 = C10 + Lambda * trace(C10) * eye(nchan) / nchan;
    C2 = C20 + Lambda * trace(C20) * eye(nchan) / nchan;
    % do generalized eigenvalue decomp
    [V d] = eig(C1,C2);
    iV = inv(V);
    M12 = V(:,[1:Ncomp, end-Ncomp+1:end])';
    G12 = iV([1:Ncomp, end-Ncomp+1:end],:);
    
    Y1 = M12 * data_1_train;
    Y2 = M12 * data_2_train;
    
   

    y_data_train = [Y1.^2, Y2.^2];
    y_states_train = [ones(1,length(indTr1)), 2*ones(1,length(indTr2))];

    % compute average over time square(variance)
    for k=1:size(y_data_train,1)
        y_data_train(k,:) = conv(y_data_train(k,:),ones(1,Tsmooth),'same');
    end;
    
    % build shrinkage (linear) classifier
    obj = train_shrinkage(y_data_train',y_states_train');
    W12 = obj.W;
    Q12 = W12'*y_data_train;

  
    Result.W12 = W12;
    Result.M12 = M12;
    Result.G12 = G12;
    Result.Q12 = Q12;
    Result.Target = y_states_train;
    Result.Input  = y_data_train;
           
    Target = (2-y_states_train);
    Result.Acc = sum( (Q12>0) == Target )/length(y_states_train);
        
end

