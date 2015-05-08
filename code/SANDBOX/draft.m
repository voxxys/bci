

t=1;
for state_num_i = 1 : 4
    for state_num_j = 1 : 4
        if(state_num_i ~= state_num_j)    
            
            freq{t} = [RESULT{state_num_i,state_num_j}.Fc_high,RESULT{state_num_i,state_num_j}.Fc_low];

            
            
            
            t = t+1;
        end
    end
end


%%

t = 1;
state_ids = [1,2,5,6];

for state_num_i = 1 : 4
    for state_num_j = 1 : 4
        if(state_num_i ~= state_num_j)    
            
            name{t} = sprintf('CSP_mat_%i_%i.mat', state_ids(state_num_i), state_ids(state_num_j));
            M{t} = RESULT{state_num_i,state_num_j}.M12;
            Minv{t} = RESULT{state_num_i,state_num_j}.G12';
            M_N = M{t};
            Minv_N = Minv{t};
            save(name{t},'M_N','Minv_N')
                       
            
            t = t+1;
        end
    end
end

