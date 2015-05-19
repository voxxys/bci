function [] = toCtest()
%#codegen
disp('HW');

states_ids = [1,2,5,6];

states = coder.load('D:/bci/code/SANDBOX/states.mat');
QQs = coder.load('D:/bci/code/SANDBOX/QQs.mat');

states_cur = states.states_cur;
indTr = 1:fix(length(states_cur)/2);

states_cur_train = states_cur(indTr);

QQ = QQs.QQ(:,indTr);



% states_cur_train = states_cur;
% QQ_train = QQ;




Nc = length(states_ids);
target = zeros(Nc,size(states_cur,2));
for c = 1:Nc
    target(c,find(states_cur_train==states_ids(c)))=1;
end;

target_train = target(:,indTr);

% target_train = target;



% clear net2;
net2 = patternnet(15);
net2.divideFcn = 'divideind';
net2.divideParam.trainInd = indTr(1:2:end);
net2.divideParam.valInd = indTr(2:2:end);
net2.divideParam.testInd = indTr(end)+1:size(QQ,2);

net2.trainParam.min_grad = 1e-7;
net2.trainParam.max_fail = 30;
net2.trainParam.epochs = 5000;
[net1,~] = train(net2,QQ,target_train);

% save('net','net1');
Ztrain = net1(QQ);

[~,ind] = max(Ztrain);

states_pred = states_ids(ind);

disp(sum(states_cur == states_pred)/size(states_cur,2));



end