function [ c_d ] = dragrocket( D,q_inf )
%calculating the coefficient of drag fo a bottle rocket
global a_b
s = .0095; %Largest cross sectional area of a bottle m^2

c_d = D./(q_inf*s); %Coefficient of drag
end

