% load data

ext_data = load('D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_6states_3004_laim_6min.mat');

[data_ext, sample_idx_data] = ext_data.data.get_data();
[states_ext, sample_idx_states] = ext_data.states.get_data();
% assert(all(sample_idx_data == sample_idx_states) == 1);

% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();


% make a new stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'BioSemi','Data',31,1000,'cf_float32','sdfwerr32432');

chns = info.desc().append_child('channels');
for label = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'Ft9', 'Fc5', 'Fc1', 'Fc2', 'Fc6', 'Ft10', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'Tp9', 'Cp5', 'Cp1', 'Cp2', 'Cp6', 'Tp10', 'P7', 'P3', 'Pz', 'P4', 'P8',  'O1', 'Oz', 'O2'}
    ch = chns.append_child('channel');
    ch.append_child_value('label',label{1});
    ch.append_child_value('unit','microvolts');
    ch.append_child_value('type','EEG');
end

disp('Opening an outlet...');
outlet = lsl_outlet(info);

% send data into the outlet
disp('Now transmitting chunked data...');
samp = 1:10;
k = 1;
randomwalk = zeros(1,10);

rwstate = 0;
chunk_size = 10;

while true

    if((k+chunk_size-1)<size(data_ext,2))
        chu = data_ext(1:31,k:(k+chunk_size-1));
    else
        chu = horzcat(data_ext(:,k:end),data_ext(:,1:(k+chunk_size-1-size(data_ext,2))));     
    end
    
    outlet.push_chunk(chu);
    
    k = k + chunk_size;
    
    if(k > size(data_ext,2))
        k = k - size(data_ext,2);
    end

    pause(0.01);
    
end