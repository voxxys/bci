clear;
clc;
exp_time = 200;

load('M_eog.mat');
load('freq.mat');
load('WW');
load('net.mat');

states_ids = [1,2,5,6];
numcomb = size(states_ids,2)*(size(states_ids,2)-1);
num_q = 1;
M_CSP = cell(1,numcomb);

for state_num_i = 1 : size(states_ids,2)
    for state_num_j = 1 : size(states_ids,2)
        if(state_num_i ~= state_num_j)  
            name = sprintf('CSP_mat_%i_%i.mat',1,2);
            m = load(name);
            
            M_CSP{num_q} = m.M_N;
            num_q = num_q + 1;
        end
    end
end



% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','Data'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

inf = inlet.info();

srate = inf.nominal_srate();
numch = inf.channel_count();

resampling_factor = 10;





size_time = srate*exp_time*1.2; % size for buffers before resampling
size_time_res = floor(srate*exp_time*1.2/resampling_factor); % size for buffers after resampling

% same for each pair
received_data_buf = zeros(numch,size_time);
no_eye_data_buf = zeros(numch,size_time);

% separate cell for every pair of states
filtered_data_buf = cell(1,numcomb);
resampled_data_buf = cell(1,numcomb);
csp_data_buf = cell(1,numcomb);
winpow_data_buf = cell(1,numcomb);
shrinkage_data_buf = zeros(numcomb,size_time_res);
result_data_buf = zeros(1,size_time_res);

for num_q = 1:numcomb

    filtered_data_buf{num_q} = zeros(numch,size_time);
    
    resampled_data_buf{num_q} = zeros(numch,size_time_res);
    
    size_csp = size(M_CSP{num_q},1);
    csp_data_buf{num_q} = zeros(size_csp,size_time_res);
    winpow_data_buf{num_q} = zeros(size_csp,size_time_res);
    
end
    
pos = 1;
pos_res = 1;


fmin = 11;
fmax = 20;
order_high = 5;
order_low = 5;

inp_num = 1;

Zlast{inp_num,1} = [];
Zlast{inp_num,2} = [];


win = 300;

% for moving average filter
a_ma = 1;
b_ma = ones(1,win);
Zlast_ma = cell(12);
for num_q = 1:numcomb
    Zlast_ma{num_q} = [];
end




        
%%%%%%%%%%%%%% designing filters

fs = srate;

for num_q = 1:numcomb
    
    fmin = freq{num_q}(1);
    fmax = freq{num_q}(2);

    if fmin > 0     
        [b_high{num_q}, a_high{num_q}] = butter(order_high, fmin/(fs/2), 'high');
    end

    if fmax < Inf  
        [b_low{num_q}, a_low{num_q}] = butter(order_low, fmax/(fs/2), 'low');    
    end

end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










disp('Now receiving chunked data...');




% initializing the timer
t = timer('TimerFcn', 'runReceiveLoop=false; disp(''Timer!'')','StartDelay',exp_time);
start(t);


% receive loop
runReceiveLoop = true;
while runReceiveLoop == true
    
    
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    
    if(size(chunk,2)>0)
        
            % EYE ARTIFACTS

            no_eye_chunk = M_eog*chunk;
            
            
        for num_q = 1:numcomb

            % FILTERING

             [filtered_chunk, Z] = filter(b_high{num_q}, a_high{num_q}, chunk, Zlast{inp_num,1}, 2);
             Zlast{inp_num,1} = Z;
             
             [filtered_chunk, Z] = filter(b_low{num_q}, a_low{num_q}, filtered_chunk, Zlast{inp_num,2}, 2);
             Zlast{inp_num,2} = Z;
             
%              [filtered_chunk, Z] = filter(b_high{num_q}, a_high{num_q}, chunk, [], 2);
%              Zlast{inp_num,1} = Z;
%              
%              [filtered_chunk, Z] = filter(b_low{num_q}, a_low{num_q}, filtered_chunk, [], 2);
%              Zlast{inp_num,2} = Z;

            % RESAMPLING

            resampled_chunk = resample(filtered_chunk',1,resampling_factor)';


            % CSP

            csp_chunk = M_CSP{num_q}*resampled_chunk;


            % POWER, WINDOW AVERAGING

            power_chunk = csp_chunk.^2;

%             for k=1:size(csp_chunk,1)
%                  win_chunk(k,:) = conv(power_chunk(k,:),ones(1,win),'same');
%             end;

             [win_chunk, Z] = filter(b_ma, a_ma, power_chunk, Zlast_ma{num_q}, 2);
             Zlast_ma{num_q} = Z;

            % SHRINKAGE

            shrinkage_chunk = WW{num_q}'*win_chunk;


            % WRITING TO BUFFERS

            size_ch = size(chunk,2);
            
            received_data_buf(:,pos:(pos+size_ch-1)) = chunk;
            no_eye_data_buf(:,pos:(pos+size_ch-1)) = no_eye_chunk;
            filtered_data_buf{num_q}(:,pos:(pos+size_ch-1)) = filtered_chunk;


            size_ch_res = size(resampled_chunk,2);
            resampled_data_buf{num_q}(:,pos_res:(pos_res+size_ch_res-1)) = resampled_chunk;
            csp_data_buf{num_q}(:,pos_res:(pos_res+size_ch_res-1)) = csp_chunk;
            winpow_data_buf{num_q}(:,pos_res:(pos_res+size_ch_res-1)) = win_chunk;
            shrinkage_data_buf(num_q,pos_res:(pos_res+size_ch_res-1)) = shrinkage_chunk;

            
        end
        
        % update writing position in buffers
        pos = pos + size_ch;            
        pos_res = pos_res + size_ch_res;
        
        
        result_chunk = net1(shrinkage_data_buf(:,(pos_res-size_ch_res):(pos_res-1)));
        
        [val, ind] = max(result_chunk);

        result_data_buf((pos_res-size_ch_res):(pos_res-1)) = states_ids(ind);

    end
    
    
    for s=1:length(stamps)
        % and display it
        fprintf('%.2f\t',chunk(:,s));
        fprintf('%.5f\n',stamps(s));
    end
       
    
    pause(0.01);
    
end

% deleting the timer;
delete(t);