function Y = classify_shrinkage(obj,X)

  % compute discriminant functions d
  d = zeros(size(X,1),length(obj.Sigma));
  for k=1:length(obj.Sigma)
    d(:,k) = X * obj.Sinv * obj.mu{k} - obj.mu{k}' * obj.Sinv * obj.mu{k};
  end

  % get most likely class
  Y = (d == repmat(max(d,[],2),[1 size(d,2)]));
  Y = bsxfun(@rdivide,Y,sum(Y,2));

end
