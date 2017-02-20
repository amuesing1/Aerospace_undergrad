%Orbital Lab 2: Preliminary Orbit Determination
%Written by: Samantha Growley
%Date Last modified: 4/12/2016
close all
clc
clear all

data = csvread('AER_TAKE2.csv');
time = data(1:4,1);  %time (EpSec)
A = data(1:4,2); %Azimuth (deg)
a = data(1:4,3); %Elevation (deg)
rho= data(1:4,4); %range (km)

%% CALCULATE SEZ COORDINATES

%Convert from degrees to radians
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
%Angular rotation rate of the Earth
omega = 0.72921158553*10^(-4); %rad/s
%Initial local siderial time at Grenwich
theta_GO = deg2rad(100.431387);


f = 0.00335; %flattening of earth
Re = 6378.137; %km
H = 1.61; %km

for i = 1: length(time)
    %Calculate
    theta_LST(i) = theta_GO + delta + omega*(time(i));
    
    %Calculate transromation matrix
    T = [sin(phi)*cos(theta_LST(i)) -sin(theta_LST(i)) cos(phi)*cos(theta_LST(i));...
        sin(phi)*sin(theta_LST(i)) cos(theta_LST(i)) cos(phi)*sin(theta_LST(i));...
        -cos(phi) 0 sin(phi)];
    
    rho_ECI(:,i) = T*[rho_S(i); rho_E(i); rho_Z(i)];
       
end
%Radius vector from Earth to ground station

%Need Radius vector for each time. Z component does not change with time
Ones = ones(1, length(theta_LST));
    R = [(Re/sqrt(1-(2*f-f*f)*(sin(phi))^2)+H)*cos(phi)*cos(theta_LST);...
        (Re/sqrt(1-(2*f-f*f)*(sin(phi))^2)+H)*cos(phi)*sin(theta_LST);...
        (Re/sqrt(1-(2*f-f*f)*(sin(phi))^2)+H)*sin(phi)*Ones];

%ECI Satellite Position Vectors
r = R+rho_ECI;

%Compare this ECI poistion vector to calculated position vectors
J2000 = csvread('J2000_TAKE2.csv');
r_STK = J2000(:,2:4)';
diff = r-r_STK

%Format to call Gibbs Method
r = r';
r1 = r(1,:);
r2 = r(2,:);
r3 = r(3,:);

%Determine v2 using Gibbs Method and Compare with STK
[v2] = Gibbs_Method(r1,r2,r3);
v_STK = J2000(2,5:7);
diff = v2-v_STK
%Calculate the difference with STK

%CHECK CORRECT :)



