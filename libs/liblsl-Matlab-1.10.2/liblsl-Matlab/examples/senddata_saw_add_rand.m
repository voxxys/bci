% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();


% make a new stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'BioSemi','Data',31,1000,'cf_float32','sdfwerr32432');

chns = info.desc().append_child('channels');
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
randomwalk = zeros(1,10);

rwstate = 0;

while true
    samp = k:(k+9);
    
    randomwalk = rwstate*ones(1,10);
    
    for i = 1:10
        if(rand > 0.5)
            randomwalk(i:10) = randomwalk(i:10) + 5*ones(1,length(i:10));
        else
            randomwalk(i:10) = randomwalk(i:10) - 5*ones(1,length(i:10));
        end
    end
    
    rwstate = randomwalk(10);
    
    samp = samp + randomwalk;
        
    chu = repmat(mod(samp,100),31,1);
    indodd = logical(repmat([1 0],1,16));
    chu(indodd,:) = -chu(indodd,:);
%    chu(10,:)
    
    outlet.push_chunk(chu);
    k = k + 10;
    
    pause(0.01);
end