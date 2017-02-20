function [h_mag,i,OMEGA,e_mag,omega,theta] = Elements(r,v)
%ELEMENTS takes inputs of inertial position and velecotiy
%Written by: Samantha Growley

mu = 398600;
%1) Calculate the distance
r_mag = norm(r);

%2) Calculate the speed
v_mag = norm(v);

%3) Calculate the radial velocity
vr = dot(r,v)/r_mag;

%4) Calculate the spcific angular momentum
h = cross(r,v);

%5) Calculate the magnitude of the specific angular momentum
h_mag = norm(h);

%6) calculate the inclination
i = acosd(h(3)/h_mag);

%7) calculate the node line
Khat = [0 0 1];
N = cross(Khat, h);

%8) calculate the mangitude of N
N_mag = norm(N);

%9) calculate the right ascension of the ascending node
OMEGA = acosd(N(1)/N_mag);
if N(2) < 0
    OMEGA = 360 - OMEGA;
else
    OMEGA = OMEGA;
end

%10) calculate the eccentricity vector
c1 = (norm(v)^2) - (mu/norm(r));
c2 = norm(r)*vr;
e = (1/mu)*((c1.*r)-(c2.*v));

%11) calculate the eccentricity
e_mag = norm(e);
%12) calculate the argument of perigee
omega = acosd(dot(N/N_mag,e/e_mag));
if e(3) <= 0
    omega = 360 - omega;
else
    omega = omega;
end
%13) calculate the true anomaly
theta = acosd(dot(e/e_mag,r/r_mag));
if vr < 0
    theta = 360 - theta;
else
    theta = theta;
end

%14) semimajor axis for STK
a=h_mag^2/(mu*(1-e_mag^2))
end

