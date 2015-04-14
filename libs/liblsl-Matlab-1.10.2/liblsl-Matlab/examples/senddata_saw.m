% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();


% make a new stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'BioSemi','Data',31,1000,'cf_float32','sdfwerr32432');

chns = info.desc().append_child('channels');

% for label = {'Fp1', 'Fp2', 'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'T3', 'C3', 'Cz', 'C4',...
%     'T4', 'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'}

for label = {'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz', 'C4',...
    'T8', 'TP9', 'CP5', 'CP1', 'CP2', 'CP6', 'TP10', 'P7', 'P3', 'Pz', 'P4', 'P8', 'FT9', 'O1', 'Oz', 'O2',  'FT10'}
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
while true
    samp = k:(k+9);
    outlet.push_chunk(repmat(mod(samp,100),32,1));
    k = k + 10;
    
    pause(0.01);
end