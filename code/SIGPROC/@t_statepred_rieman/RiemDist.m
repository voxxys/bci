function RD = RiemDist(X,Y)

% Calculates distance bentween the two covariance matrices
% taking into account the approximate curvature of the natural space of
% hermitian symmetric matrices
% Input args:
% X, Y are two covariance matrices to measure the distance between
% Example:
% x = randn(10,1000); % 10 dimensional data arrays(1000 samples)
% y = randn(10,1000);
% X = 1/1000*x*x';  % calculate covariance matrices(mean = 0)
% Y = 1/1000*y*y';
% D = RiemDist(X,Y);% calculate distance
 
[a b] = eig(pinv(sqrtm(Y))*X*pinv(sqrtm(Y)));
    
RD = sum((log(diag(b)).^2));
    