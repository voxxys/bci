fname = 'D:\bci\EXP_DATA\EXP_LSL32_new\bci_expresult_LSL32_first_2603_first_real_T20.mat';
load(fname)

fixed_states = states.data;
borders = [1 find(abs(diff(fixed_states))==1) length(fixed_states)];

for b = 2:(length(borders)-1)
        fixed_states(borders(b-1):borders(b)) = mod((b-2)*ones(1,size(fixed_states(borders(b-1):borders(b)),2)),6) + ones(1,size(fixed_states(borders(b-1):borders(b)),2));
        
end

states.data = fixed_states;

save(fname,'data','states');