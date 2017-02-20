function [ e,c_L,c_Di,delta ] = PLLT( b,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N )
% Problem 1

% convert to radians
alpha_t=geo_t*pi/180;
alpha_r=geo_r*pi/180;
alpha_L0_t=aero_t*pi/180;
alpha_L0_r=aero_r*pi/180;

theta=linspace(0.00000001,(pi/2)-0.00000001,N);

S=b*(c_t+c_r)/2;
AR=(b^2)/S;

% create smooth curve
alpha=linspace(alpha_t,alpha_r,N);
alpha_L0=linspace(alpha_L0_t,alpha_L0_r,N);
c=linspace(c_t,c_r,N);

for i=1:N
    for j=1:N
        A(i,j)=((2*b)/(pi*c(i)))*sin((2*j-1)*theta(i))+(2*j-1)*((sin((2*j-1)*theta(i)))/(sin(theta(i))));
    end
end
constant=alpha-alpha_L0;

% solve for A_1,3 . . .
A_matrix=A\constant';

delta=0;
for i=2:N
    delta=delta+(2*i-1)*(A_matrix(i)/A_matrix(1))^2;
end

% span efficiecy factor
e=1/(1+delta);

%c_l and c_Di
c_L=A_matrix(1)*pi*AR;
c_Di=(c_L^2)/(pi*e*AR);

end

