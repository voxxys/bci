function M = generatelaplace3()

    M = eye(32);

    %F3

    M(4,1) = -0.25;
    M(4,5) = -0.25;
    M(4,15) = -0.25;
    M(4,3) = -0.25;
    M(4,4) = 1;

    %Fz

    M(5,1) = -0.125;
    M(5,2) = -0.125;
    M(5,4) = -0.25;
    M(5,6) = -0.25;
    M(5,16) = -0.25;
    M(5,5) = 1;

    %F4

    M(6,2) = -0.25;
    M(6,7) = -0.25;
    M(6,5) = -0.25;
    M(6,17) = -0.25;
    M(6,6) = 1;

    %C3

    M(15,4) = -0.25;
    M(15,16) = -0.25;
    M(15,26) = -0.25;
    M(15,14) = -0.25;
    M(15,15) = 1;

    %Cz

    M(16,5) = -0.25; 
    M(16,17) = -0.25; 
    M(16,27) = -0.25; 
    M(16,15) = -0.25; 
    M(16,16) = 1;

    %C4

    M(17,6) = -0.25;
    M(17,18) = -0.25;
    M(17,28) = -0.25;
    M(17,16) = -0.25;
    M(17,17) = 1;

    %P3

    M(26,15) = -0.25;
    M(26,27) = -0.25;
    M(26,30) = -0.25;
    M(26,25) = -0.25;
    M(26,26) = 1;

    %Pz

    M(27,16) = -0.25;
    M(27,28) = -0.25;
    M(27,26) = -0.25;
    M(27,30) = -0.125;
    M(27,32) = -0.125;
    M(27,27) = 1;

    %P4

    M(28,17) = -0.25; 
    M(28,29) = -0.25; 
    M(28,32) = -0.25; 
    M(28,27) = -0.25;
    M(28,28) = 1;


    %Fc5
    
    M(9,3) = -0.25; 
    M(9,4) = -0.25; 
    M(9,15) = -0.25; 
    M(9,14) = -0.25;
    M(9,9) = 1;
    
    %Fc1
    
    M(10,4) = -0.25; 
    M(10,5) = -0.25; 
    M(10,16) = -0.25; 
    M(10,15) = -0.25; 
    M(10,10) = 1; 
    
    %Fc2
    
    M(11,5) = -0.25; 
    M(11,6) = -0.25; 
    M(11,17) = -0.25;
    M(11,16) = -0.25;
    M(11,11) = 1;
        
    %Fc6
    
    M(12,6) = -0.25; 
    M(12,7) = -0.25; 
    M(12,18) = -0.25; 
    M(12,17)= -0.25; 
    M(12,12) = 1; 
    
    %Cp5
    
    M(20,14) = -0.25; 
    M(20,15) = -0.25; 
    M(20,26) = -0.25; 
    M(20,25) = -0.25; 
    M(20,20) = 1; 
    
    %Cp1
    
    M(21,15) = -0.25;
    M(21,16) = -0.25;
    M(21,27) = -0.25;
    M(21,26) = -0.25;
    M(21,21) = 1;
    
    %Cp2
    
    M(22,16) = -0.25;
    M(22,17) = -0.25;
    M(22,28) = -0.25;
    M(22,27) = -0.25;
    M(22,22) = 1;
    
    %Cp6
    
    M(23,17) = -0.25;
    M(23,18) = -0.25;
    M(23,29) = -0.25;
    M(23,28) = -0.25;
    M(23,23) = 1;
    
    

end
