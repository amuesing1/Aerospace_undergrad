%Dylan Richards 
%ASEN3128 - Aircraft Dynamics Lab2 - Euler Angles 
%Date Created: 1/25/16

function [ vector_body ] = WindAnglesToAirRelativeVelocityVector( wind_angles )
%Purpose: Calculate the aircraft air-relative velocity in body coordinates
%from the airspeed, angle of attack, and sideslip angle. 

%Input: Aircraft airspeed(V), sideslip angle(beta), and angle of attack(alpha) as a 3D
%column vector [V; beta; alpha]. (Assuming the values are in radians!!)

%Output: Air-relative velocity vector expressed in body coordinates
%as a 3D column vector [u; v; w].

V = wind_angles(1,:); %airspeed
beta = wind_angles(2,:); %sideslip angle
alpha = wind_angles(3,:); %angle of attack

u = V.*cos(beta).*cos(alpha);
v = V.*sin(beta);
w = V.*cos(beta).*sin(alpha);

vector_body = [u; v; w;];

end

