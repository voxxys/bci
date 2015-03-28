load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_2603_first_imag_T20.mat')

data_cur = data.data;
states_cur = states.data;

Fs = 1000;
L = size(data_cur,2);
NFFT = 2^nextpow2(L);


Fc_low = 45;
Fc_high = 0.5;

%Wn =  Fc /(Fs/2)

[z_high,p_high,k_high] = butter(5, Fc_high/(Fs/2), 'high');
[b_high,a_high] = zp2tf(z_high,p_high,k_high);
data_cur = filtfilt(b_high, a_high,data_cur')'; 

[z_low,p_low,k_low] = butter(5, Fc_low/(Fs/2), 'low');
[b_low,a_low] = zp2tf(z_low,p_low,k_low);
data_cur = filtfilt(b_low, a_low,data_cur')'; 


 for n = 1 : 2
    Xmean = mean(data_cur(:));
    Xstd = std(data_cur(:));
    mask = (abs(data_cur-Xmean) < 3 * Xstd);
    mask = prod(double(mask),1);
    idx = find(mask);
    data_cur = data_cur(:,idx);
    states_cur = states_cur(idx);
 end



for i = 1:6
    data_state{i} = data_cur(:,states_cur == i);
    
end

% figure;

for i = 1:6
    for j = 1:6
        disp(i);
        disp(j);

        
        data_1 = data_state{i};
        data_2 = data_state{j};
        C1 = data_1 * data_1' / size(data_1,2);
        C2 = data_2 * data_2' / size(data_2,2);

        nchan = size(C1,1);
        C1 = C1 + 0.05 * trace(C1) * eye(nchan) / size(C1,1);
        C2 = C2 + 0.05 * trace(C2) * eye(nchan) / size(C2,1);

        [V d] = eig(C2,C1);
        
        M = inv(V');

        Y1 = M * data_1;
        Y2 = M * data_2;
        
%         subplot(6,6,6*(i-1)+j); 
        figure;
        hold on;
        plot(Y1(1,:), Y1(end,:), 'b.');
        plot(Y2(1,:), Y2(end,:), 'r.');
        legend(['State ', num2str(i)],['State ', num2str(j)]);
        xlabel('CSP\_1');
        ylabel('CSP\_end');
        title([num2str(i), ', ', num2str(j)]);
        
%         y_data = [Y1, Y2];
%         y_states = [ones(1,size(Y1,2)), 2*ones(1,size(Y2,2))];
%         
%         [C,err,P,logp,coeff] = classify(y_data', y_data', y_states, 'linear');
%         fprintf('LDA error: %f\n', err);
% 
%         D = sum(bsxfun(@times, y_data, coeff(1,2).linear)) + coeff(1,2).const;
%         states_pred = (D < 0) + 1;
%         pred_ok = mean(y_states == states_pred);
% 
%         fprintf('Sign test: correct = %f\n', pred_ok);
    end
end


