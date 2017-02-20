% Aspen Coates, Sarah Levine, Griffin Esposito
% ASEN 3128 - Lab 2
% Due: 8 February 2016

%% Problem 1, Part c
 % Calculate the 3-2-1 rotation matrix R given the Euler angles. Note, this
 % is the transpose of the matrix labelled LBE in Eq. (4.4,3) in Etkin. 
 % Rather than copy Eq. (4.4,3) directly, consider making this matrix as a 
 % series of three rotations as described at the beginning of Etkin Section
 % 4.4.
 
 function R = RotationMatrix321(euler_angles)
    phi = euler_angles(1);
    theta = euler_angles(2);
    psi = euler_angles(3);
   % Check Input
     if size(euler_angles) ~= [3,1]
         disp('Input Vector is the Wrong Size. Check input.')
     end
     
   % Define Phi, Theta, and Psi Matrices
     M_phi   = [1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
     M_theta = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
     M_psi   = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
     
   % Calculate the Transformation Matrix
     R = M_phi * M_theta * M_psi;
   
 end