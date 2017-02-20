function [r] = SEZ_coord(t,A,a,rho)
%Written by: Samatha Growley

%SEZ_COORD determines three s/c position vectors in SEZ coordinates from
%the three sets of azimuth (A), elevation (a) and range (rho) measurements
%four minutes apart obtained by tracking station during ascending pass.
A = deg2rad(A);
a = deg2rad(a);
%Calculate SEZ coordinates
    rho_S = -rho.*cos(a).*cos(A);
    rho_E = rho.*cos(a).*sin(A);
    rho_Z = rho.*sin(a);
rho_SEZ = [rho_S rho_E rho_Z];

%Rotate the SEZ vetors into the ECI using geodetic latitude (phi)
phi = deg2rad(40.008);
delta = deg2rad(-105.262);
omega = 0.72921158553*10^(-4); %rad/s
theta_GO = deg2rad(100.431387);


f = 0.00335; %flattening of earth
Re = 6378.137; %km
H = 1.61; %km

for i = 1: length(t)
    %Use rho_SEZ(i)
    theta_LST(i) = theta_GO + delta + omega*(t(i));
    
    %Calculate transromation matrix
    T = [sin(phi)*cos(theta_LST(i)) -sin(theta_LST(i)) cos(phi)*cos(theta_LST(i));...
        sin(phi)*sin(theta_LST(i)) cos(theta_LST(i)) cos(phi)*sin(theta_LST(i));...
        -cos(phi) 0 sin(phi)];
    
    rho_ECI(:,i) = T*[rho_S(i); rho_E(i); rho_Z(i)];
       
end
%Radius vector from Earth to ground station
Ones = ones(1, length(theta_LST));
    R = [(Re/sqrt(1-(2*f-f*f)*(sin(phi))^2)+H)*cos(phi)*cos(theta_LST);...
        (Re/sqrt(1-(2*f-f*f)*(sin(phi))^2)+H)*cos(phi)*sin(theta_LST);...
        (Re/sqrt(1-(2*f-f*f)*(sin(phi))^2)+H)*sin(phi)*Ones];

%ECI Satellite Position Vectors
r = R+rho_ECI;

end