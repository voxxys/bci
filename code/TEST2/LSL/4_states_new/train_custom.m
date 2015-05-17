clear
clc

load('D:\bci\EXP_DATA\EXP_LSL32_new\1305_lisa_re_first.mat');


%

[data_cur,sample_idx_data] = data.get_data();
states_cur = states.get_data();
chan_names = data.chan_names;

%

states_ids = [1,2,5,6];

%

chan_names_chanlocs = chan_names;

EEGDummy = load_dataset('D:\bci\EXP_DATA\EXP_LSL32_new\short_32chan_2.set');


chanlocs = EEGDummy.chanlocs;
chan_idx_chanlocs = find_str_idx(lower({chanlocs.labels}), lower(chan_names_chanlocs));

chanlocs_vis = chanlocs(chan_idx_chanlocs);

eog_sigma_mult = 2;


X = data_cur;

sz = size(X,2);
X = X(:,0.1*sz:end);

eog_chan_id = find(strcmp('Fp1', chan_names));
Xeog = X(eog_chan_id,:);

mask_pos = (Xeog >= 0);
mask_neg = (Xeog < 0);
Xeog_pos = Xeog(find(mask_pos));
Xeog_neg = Xeog(find(mask_neg));
bpos = (abs(Xeog .* mask_pos) > (eog_sigma_mult * sqrt(mean(Xeog_pos.^2))));
bneg = (abs(Xeog .* mask_neg) > (eog_sigma_mult * sqrt(mean(Xeog_neg.^2))));
artif_idx = find(bpos | bneg);
Xartif = X(:,artif_idx);

[W, score, d] = princomp(Xartif');

X = data_cur;     % unfiltered again


figure;
set(gcf, 'units', 'normalized', 'outerposition', [0 0.05 1 0.95]);
nx = 6;
ny = 6;
for m = 1 : size(W,1);
    V = W(:,m);
    subplot(ny,nx,m);
    topoplot(V, chanlocs_vis);
end

str = inputdlg('Which patterns should we discard?');
comp_idx_eog = str2num(str{1});

Weog = W(:,comp_idx_eog);
U = eye(size(W)) - Weog * Weog';
M_eog = U;

data_cur = M_eog*data_cur;

%%



numfile = 1;
for state_num_i = 1 : size(states_ids,2)
    for state_num_j = 1 : size(states_ids,2)
        if(state_num_i ~= state_num_j)        
            [fmin,fmax,M_N,Minv_N,LDA_coeff,W12,Q12] = findparam(data_cur,states_cur,sample_idx_data,chan_names,states_ids(state_num_i),states_ids(state_num_j));
            name = sprintf('CSP_mat_%i_%i.mat',states_ids(state_num_i),states_ids(state_num_j));
            
            save(name,'M_N','Minv_N');
            freq{numfile} = [fmin,fmax];
            LDA_coeffs{numfile} = LDA_coeff;

            WW{numfile} = W12;
            QQ(numfile,:) = Q12;

        numfile = numfile + 1;        

        end
    end
end

save('freq.mat','freq');
save('LDA_coeffs.mat','LDA_coeffs');
save('M_eog.mat','M_eog');
save('WW.mat','WW');

%%

states_cur = states_cur(1:10:end);
%%
indTr = 1:fix(length(states_cur)/2);

states_cur_train = states_cur(indTr);

QQ_train = QQ(:,indTr);



% states_cur_train = states_cur;
% QQ_train = QQ;




Nc = length(states_ids);
target = zeros(Nc,size(states_cur,2));
for c = 1:Nc
    target(c,find(states_cur==states_ids(c)))=1;
end;

target_train = target(:,indTr);

% target_train = target;



clear net2;
net2 = patternnet(15);
% net2.divideFcn = 'divideind';
% net2.divideParam.trainInd = indTr(1:2:end);
% net2.divideParam.valInd = indTr(2:2:end);
% net2.divideParam.testInd = indTr(end)+1:size(QQ,2);

net2.trainParam.min_grad = 1e-7;
net2.trainParam.max_fail = 30;
net2.trainParam.epochs = 5000;
[net1,tr] = train(net2,QQ,target);

save('net','net1');
Ztrain = net1(QQ);

[val,ind] = max(Ztrain);

states_pred = states_ids(ind);

%%
load('net');
Ztest = net1(QQ);

