clear
clc

load('D:\bci\EXP_DATA\EXP_LSL32_new\1305_lisa_re_first_2.mat');

load('M_eog.mat');
load('freq.mat');
load('WW');
load('net.mat');

states_ids = [1,2,5,6];

win = 300;


[data_cur,sample_idx_data] = data.get_data();
states_cur = states.get_data();
chan_names = data.chan_names;


data_cur = M_eog*data_cur;


a_ma = 1;
b_ma = ones(1,win);


Fs = 1000;
for i = 1:12
    fmin = freq{i}(1);
    fmax = freq{i}(2);
    
    testdata{i} = data_cur;
    
    [z_high,p_high,k_high] = butter(5, fmin/(Fs/2), 'high');
    [b_high,a_high] = zp2tf(z_high,p_high,k_high);

    [z_low,p_low,k_low] = butter(5, fmax/(Fs/2), 'low');
    [b_low,a_low] = zp2tf(z_low,p_low,k_low);

    % filter
    testdata{i} = filter(b_high, a_high, testdata{i}, [], 2); % data is original untouched data
    testdata{i} = filter(b_low, a_low, testdata{i}, [], 2); 

    
    
end

for i = 1:12
    
    testdata{i} = resample(testdata{i}',1,10)';       

end
states_cur = states_cur(1:10:end);


i = 1;
for state_num_i = 1 : size(states_ids,2)
    for state_num_j = 1 : size(states_ids,2)
        if(state_num_i ~= state_num_j)     
            name = sprintf('CSP_mat_%i_%i.mat',states_ids(state_num_i),states_ids(state_num_j));
            m = load(name);
            M = m.M_N;
            
            testdata_csp{i} = M*testdata{i};
                        
            i = i + 1;
        end
    end
end


for i = 1:12
    
    
    y_data = testdata_csp{i}.^2;

%     for k=1:size(testdata_csp{i},1)
%          y_data(k,:) = conv(y_data(k,:),ones(1,win),'same');
%     end;
    y_data = filter(b_ma, a_ma, y_data, [], 2); 
    
    testdata_csp{i} = y_data;
    
end


QQ = zeros(12,size(y_data,2));

for i = 1:12
    QQ(i,:) = WW{i}'*testdata_csp{i};

end

%%

res = net1(QQ);
[val,ind] = max(res);

states_pred = states_ids(ind);
sum(states_cur == states_pred)/size(states_cur,2)
