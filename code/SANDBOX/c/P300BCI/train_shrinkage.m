function obj = train_shrinkage(X,Y)
      
      nclasses = numel(unique(Y));
      d = size(X,2);
      
      % estimate class priors
      obj.pi = zeros(nclasses,1);
      for j=1:nclasses
        obj.pi(j) = sum(Y==j)/size(Y,1);
      end

      % estimate class-conditional means
      obj.mu = cell(nclasses,1);
      for k=1:nclasses
        obj.mu{k} = nanmean(X(Y == k,:))';
      end
         
      % estimate class-conditional covariance matrices
      obj.Sigma = cell(nclasses,1); 
      obj.lambda = zeros(nclasses,1);
      for k=1:nclasses
        
        obj.Sigma{k} = cov(X(Y == k,:));
        
        if obj.lambda(k)==0
          
          mX = bsxfun(@minus,X(Y == k,:),obj.mu{k}');
          N = size(mX,1);
          W = zeros(N,d,d);
          for n=1:N
            W(n,:,:) = mX(n,:)' * mX(n,:);
          end
          WM = mean(W,1);
          S = squeeze((N/(N-1)) .* WM);
          % do shrinkage
          VS = squeeze((N/((N-1).^3)) .* sum(bsxfun(@minus,W,WM).^2,1));

          v = mean(diag(S));

          t = triu(S,1);
          obj.lambda(k) = sum(VS(:)) / (2*sum(t(:).^2) + sum((diag(S)-v).^2));
         
          obj.lambda(k) = max(0,min(1,obj.lambda(k)));
          
        end
        
        % the regularizing matrix
        T = v*eye(d);
        obj.Sigma{k} = (1-obj.lambda(k))*obj.Sigma{k} + obj.lambda(k)*T;

      end
      
      % compute inverse of joint covariance matrix (i.e. LDA instead of QDA)
      S = 0; for c=1:length(obj.Sigma), S = S + obj.Sigma{c}; end
      obj.Sinv = inv(S/length(obj.Sigma));
  
      obj.W = obj.Sinv*(obj.mu{1}-obj.mu{2});
end
        
    