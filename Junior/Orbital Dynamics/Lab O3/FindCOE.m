% This function finds the classical orbital elements given a position vector
% and a velocity vector. 
% Inputs: a vector of position in inertial coordinates (r), and a vector of
% velocity in the inertial frame (v) 
% Outputs: Angular momentum (h), inclination (i) in degrees, right ascension of the
% ascending node (Omega) in degrees, eccentricity (e), argument of 
% perigee (omega) in degrees,
% true anomoly (nu) in degrees, semi-major axis (a), flight path angle
% (phi) in degrees, radius of apogee (ra) in km and radius of periapse (rp)
% in km

function [h, i, Omega, e, omega, nu, a, phi,ra,rp] = FindCOE(r,v)

mu = 398600; % mu of earth

%1) Calculate the magnitude of the position vector
r_magnitude = norm(r);

%2) Calculate the magnitude of the velocity vector
v_magnitude = norm(v);

%3) Calculate the radial velocity. 
    %Note: if v_r < 0, the satellite is %flying toward perigee. 
    %If v_r > 0, the satellite is flying away from perigee.
v_r = dot(r, v) / r_magnitude;

%4) Calculate the specific angular momentum
h_v = cross(r, v);

%5) Calculate the magnitude of the specific angular momentum. This is the
%1st orbital element
h = sqrt(dot(h_v, h_v));

%6) Calculate inclination. (2nd orbital element). If 90 < i <= 180, the 
% angular momentum vecoter points in the southerly direction. 
% If this is true, then the orbit is
% retrograde, so the motion of the satellite around the earth is opposite
% the earth's rotation
i = acos(h_v(3)/h);
i = rad2deg(i); %[deg]

%7) Calculate the Node line vector N
K_hat = [0 0 1];
N_v = cross(K_hat, h_v);

%8) Calculate the magnitude of N
N = norm(N_v);

%9) Calculate the right ascension of the ascending node: (3rd orbital
%element). If (N_v(3)/N) > 0, omega lies in either the first or fourth
%quadrant. To place it in the right quadrant, observe that the ascending
%node lies on the positive side of the vertical XZ plane (0 <= Omega < 180)
%if N_v(2) > 0. If the ascending node lies on the negative side of the XZ
%plane (180 <= omega < 360) then N_v(2) < 0. Therefore, N_v(2) > 0 implies
%0< omega <= 180 whereas N_v(2) < 0 implies 180 < omega < 360.

Omega = acos(N_v(1) / N);%[rad]
%Quadrant Check
if N_v(2) < 0
    Omega = 2*pi - Omega;
end
Omega = rad2deg(Omega); %[deg]

%10) Calculate the eccentricity vector
e_v = (1/mu) * ((v_magnitude^2 - (mu/r_magnitude)) .* r - (r_magnitude * v_r) .* v);

%11) Calculate the eccentricity (4th orbital element)
e = norm(e_v);

%12) Calculate argument of perigee. (5th element) Note if e_v point up (in the
%+Z-direction), e_v(3) >= 0, which implies that 0 < omega < 180.
%Conversely, e_v(3) < 0 implies 180 < omega < 360
omega = acos(dot(N_v,e_v)/(N * e)); %rad %[rad]
%Quadrant Check
if e_v(3) < 0
    omega = 2*pi - omega;
end
omega = rad2deg(omega); %[deg]

%13) Calculate True anomaly. 6th orbital element. Note: if e_v dot r_ijk >
%0, then theta lies in the 1st or 4th quadrant. If r_v dot v_v >= 0, then
%0 <= theta < 180 (satellite flying away from perigee). If r_v dot v_v <= 0, then
%180 <= theta < 360 (satellite flying toward perigee).
nu = acos(dot(e_v,r)/(e*r_magnitude)); %[rad]
%Quadrant Check
if dot(r, v) <= 0
    nu = 2*pi - nu;
end
nu = rad2deg(nu); %[deg]

%find semi-major axis
rp = (h^2/mu)*(1/(1 + e*cosd(0)));
ra = (h^2/mu)*(1/(1 + e*cosd(180)));
a = (.5)*(rp + ra);

%Flight Path Angle
cosphi = (1+e*cos(nu)) / sqrt(1+2*e*cos(nu)+e^2);
sinphi = (e*sin(nu)) / sqrt(1+2*e*cos(nu)+e^2);
phi = atan2(sinphi,cosphi);
phi = rad2deg(phi);


end

