function [R,I,C] = FromXYZtoRIC(r,v,ECI_differences)
% function finds the RIC coordinate system for a given position vector and
% velocity vector.
% Inputs: 
%       r: position vector in ECI coordinates [rx,ry,rz];
%       v: velocity vector in ECI coordinates [vx,vy,vz];
% Outpus: 
%       R: Radial vector. unit vector
%       I: In-track vector. unit vector
%       C: Cross-track vector. unit vector
difference_position_vector = ECI_differences(1:3);
R_vec = r/norm(r);
C_vec = (cross(r,v)/norm(cross(r,v)));
I_vec = cross(C_vec,R_vec);

Q = [R_vec;I_vec;C_vec];
output = Q*difference_position_vector';
R = output(1,:);
I = output(2,:);
C = output(3,:);