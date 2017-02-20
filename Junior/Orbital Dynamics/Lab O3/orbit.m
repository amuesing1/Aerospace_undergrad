function EOM=orbit(t,x)
%function for ODE45 equations to numerically integrate in the ECI
%coordinate frame and taking into account the J2 effect
EOM=zeros(6,1);

J2 = 0.00108263;
mu = 398600.4418;
R_E = 6378.137;
r=sqrt(x(1)^2+x(2)^2+x(3)^2);

EOM(1)=x(4);
EOM(2)=x(5);
EOM(3)=x(6);
EOM(4)=-(mu*x(1))/(r^3)*(1-(1.5*J2*(R_E/r)^2)*(5*(x(3)/r)^2-1));
EOM(5)=-(mu*x(2))/(r^3)*(1-(1.5*J2*(R_E/r)^2)*(5*(x(3)/r)^2-1));
EOM(6)=-(mu*x(3))/(r^3)*(1-(1.5*J2*(R_E/r)^2)*(5*(x(3)/r)^2-3));


end

