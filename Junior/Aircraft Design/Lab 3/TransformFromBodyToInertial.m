%Dylan Richards 
%ASEN3128 - Aircraft Dynamics Lab2 - Euler Angles 
%Date Created: 1/25/16


function [ vector_inertial ] = TransformFromBodyToInertial( vector_body,euler_angles )
%Purpose: For a vector given in body coordinates, determine the components
%in inertial coordinates.

%Input: vector_body = Air-relative velocity vector expressed in body coordinates
%                   as a 3D column vector [u; v; w].
%       euler_angles = angles describing the orientation of the aircraft as
%                   a 3D column vector; specifically in the order:
%                   [roll(phi); pitch(theta); yaw(psi)] (Assuming the values are in radians!!)


R = RotationMatrix321(euler_angles); %rotation matrix from inertial to body coordinates

%must transpose this rotation matrix(R) to go the other way:
vector_inertial = R'*vector_body; %converts from body to inertial coordinates

end

