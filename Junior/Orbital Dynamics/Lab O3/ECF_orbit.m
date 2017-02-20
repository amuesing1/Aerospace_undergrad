function EOM=ECF_orbit(t,x)
%function for ODE45 equations to numerical integrate in ECF coordinates
EOM=zeros(6,1);

J2 = 0.00108263;
mu = 398600.4418;
R_E = 6378.137;
r=sqrt(x(1)^2+x(2)^2+x(3)^2);
v=[x(4);x(5);x(6)];
rvec=[x(1);x(2);x(3)];
omega_rate=0.72921158553e-4; %rotation rate of sidereal day [rad/sec]
w=[0;0;omega_rate];

EOM(1)=x(4);
EOM(2)=x(5);
EOM(3)=x(6);
EOM(4)=-(mu*x(1))/(r^3)*(1-(1.5*J2*(R_E/r)^2)*(5*(x(3)/r)^2-1));
EOM(5)=-(mu*x(2))/(r^3)*(1-(1.5*J2*(R_E/r)^2)*(5*(x(3)/r)^2-1));
EOM(6)=-(mu*x(3))/(r^3)*(1-(1.5*J2*(R_E/r)^2)*(5*(x(3)/r)^2-3));

acc=[EOM(4);EOM(5);EOM(6)];

acc=acc-2*cross(w,v)-cross(w,cross(w,rvec));

EOM(4)=acc(1);
EOM(5)=acc(2);
EOM(6)=acc(3);


end