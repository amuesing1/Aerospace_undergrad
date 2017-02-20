% HW7.m
% Written by: Jeremy Muesing
% ASEN 3200
% Date Created: 2/29/16

clear all
clc
%% Problem 1
euler_angles=[103 70 230];

phi = euler_angles(1);
theta = euler_angles(2);
psi = euler_angles(3);

R1=[1 0 0; 0 cosd(phi) sind(phi); 0 -sind(phi) cosd(phi)]; %roll rotation matrix
R2=[cosd(theta) 0 -sind(theta); 0 1 0; sind(theta) 0 cosd(theta)]; %pitch rotation matrix
R3=[cosd(psi) sind(psi) 0; -sind(psi) cosd(psi) 0; 0 0 1]; %yaw rotation matrix

R=R1*R2*R3; %mutiplies the three rotation matrixes to get the final rotation matrix

q=quat2dcm([0.328474 -.437966 0.801059 -.242062]);

% rotates from spacecraft to inertial with angles, then inertial to space
% station with quaternion. This computes a single DCM from spacecraft to
% space station
DCM=R.*q

%% Problem 2
clear all


euler_angles=[-30 40 20];

phi = euler_angles(1);
theta = euler_angles(2);
psi = euler_angles(3);

R1=[1 0 0; 0 cosd(theta) sind(theta); 0 -sind(theta) cosd(theta)];
R31=[cosd(phi) sind(phi) 0; -sind(phi) cosd(phi) 0; 0 0 1];
R32=[cosd(psi) sind(psi) 0; -sind(psi) cosd(psi) 0; 0 0 1];

R=R31*R1*R32;

% part b
Phi=acosd(.5*(R(1,1)+R(2,2)+R(3,3)-1)) %degrees

% part a
e=(1/(2*sind(Phi)))*[R(2,3)-R(3,2); R(3,1)-R(1,3); R(1,2)-R(2,1)]

% part c
q=[cosd(Phi/2); e(1)*sind(Phi/2); e(2)*sind(Phi/2); e(3)*sind(Phi/2)]

%% Problem 3
clear all

% T frame to B frame
mB=[-0.8285 0.5522 -0.0955];
t1B=[0.8273 0.5541 -0.0920];
t2B=cross(t1B,mB)/norm(cross(t1B,mB));
t3B=cross(t1B,t2B);
C_T2B=[t1B; t2B; t3B];

%T frame to I frame
mI=[-0.8393 0.4494 -0.3044];
t1I=[-0.1517 -0.9669 0.2050];
t2I=cross(t1I,mI)/norm(cross(t1I,mI));
t3I=cross(t1I,t2I);
C_T2I=[t1I; t2I; t3I];

% I frame to B frame, part a
C_I2B=C_T2B'*C_T2I

% euler angles, part b
[phi theta psi]=dcm2angle(C_I2B);%radians
angles=rad2deg([phi theta psi])
