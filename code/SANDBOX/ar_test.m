x = [1 2 0 0; 0 1 2 0; 0 0 1 2; 2 0 0 1];
x = x + 1;

x = repmat(x,16,1);
x = x + 0.01*randn(size(x));
% x = x + 5*randn(size(x));
% 
% noise = randn(size(x));
% x = x + noise;

mean_substr = repmat(mean(x),size(x,1),1);

x = x - mean_substr;

% x = x';

Spec = vgxset('ARsolve', repmat({true(4)}, 2, 1));
%[EstSpec1,EstSE1,logL1,W1] = vgxvarx(Spec,x(3:end,:));%,[], x(1:2,:));
% [EstSpec1,EstSE1,logL1,W1] = vgxvarx(Spec,x(3:end,:),[],x(1:2,:));

EstW = vgxinfer(Spec, x(3:end,:));%, [], x(1:2,:));

plot(x(3:end,1));
hold on;
plot(EstW(:,1),'g');



%%
x = [1 1 1 1];

x = [x; 2*x; 3*x; 4*x];

x = x';

x_true = [x (x+4) (x+8)];

A1 = pinv(x(:,2:3)')*x(:,3:4)';

% now x(:,3:4) = x(:,2:3)*A1


A2 = pinv(x(:,1:2)')*x(:,3:4)';

% now x(:,3:4) = x(:,1:2)*A2

mod_1 = vgxset('a', [0; 0], 'b', [1, 1],	'AR', {A1, A2});

mod_2 = vgxset('AR', {A1, A2});

mod_3 = vgxset('ARsolve', repmat({true(2)}, 2, 1), 'bsolve',true(2, 1), 'asolve',true(2,1));

mod_4 = vgxset('ARsolve', repmat({true(4)}, 2, 1));


[EstSpec1,EstSE1,logL1,W1] = vgxvarx(mod_4,x(:,3:4),[],x(:,1:2));

%%
YF = [100 50 20 56;110 52 22 89]; % starting values
rng(1);                               % For reproducibility
Y = vgxsim(mod_2,190,[],YF);


%%

% [EstSpec1,EstSE,logL,W] = vgxvarx(Mdl1,(W1'*z_cur(:,ind1))');
% [EstSpec2,EstSE,logL,W] = vgxvarx(Mdl1,(W2'*z_cur(:,ind2))');