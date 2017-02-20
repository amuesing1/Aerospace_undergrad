function [vector_body] = TransformFromInertialToBody(vector_inertial, eular_angles)

% ASEN 3128 Lab 2 part 1d)
% David Barker, Dylan Richards, Andrew Quinn

% Problem: For a vector given in inertial coordinates,...
% determine the components in body coordinates

% Input: vector_inertial = [x; y; z];       x_e
%        eular_angles = [phi; theta; psi] (in rads);  
%
% Output: vector_body = [u; v; w];          x_b

R = RotationMatrix321(eular_angles);
% x_b = R_b/e * x_e
vector_body = R*vector_inertial;

end