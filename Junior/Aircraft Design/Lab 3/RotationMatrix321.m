function R=RotationMatrix321(euler_angles)
%Purpose: Calculate a 3-2-1 roataion matrix to transform vectors from 
%         inertal coordinates to body coordinates

%Input:  euler_angles: a 3 by 1 vector of euler angles in radians, in the
%        form of [phi; theta; psi].

%Output: Rotation matrix that transforms a inertal vector to a body vector

phi = euler_angles(1);
theta = euler_angles(2);
psi = euler_angles(3);

R1=[1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)]; %roll rotation matrix
R2=[cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)]; %pitch rotation matrix
R3=[cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1]; %yaw rotation matrix

R=R1*R2*R3; %mutiplies the three rotation matrixes to get the final rotation matrix
end