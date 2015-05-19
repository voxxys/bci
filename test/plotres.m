
ind = res_real_states_buf > 0;
sum(res_real_states_buf(ind) == result_data_buf(ind))/size(res_real_states_buf(ind),2)

figure
plot(res_real_states_buf(ind),'g');
hold on;
plot(result_data_buf(ind));