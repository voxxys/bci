function   W  = FisherDA(x,y,alpha)

if(nargin==2)
    alpha = 0.01;
end;
Mx = mean(x,2);
My = mean(y,2);
xc = x-repmat(Mx,1,size(x,2));
yc = y-repmat(My,1,size(y,2));
Cx = xc*xc'/size(xc,2);
Cy = yc*yc'/size(yc,2);

W = tihinv(Cx+Cy,alpha)*(Mx-My);
%W = inv(Cx+Cy+alpha*eye(size(Cx)))*(Mx-My);




