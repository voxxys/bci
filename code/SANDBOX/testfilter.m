win = 5;

a = 1;
b = ones(1,win);


testvec = [1 2 3 4 5 6 7 8 9 10; 10 9 8 7 6 5 4 3 2 1];

[testvec_f,z] = filter(b,a,testvec(:,1:5),[],2);
testvec_f_2 = filter(b,a,testvec(:,6:10),z);