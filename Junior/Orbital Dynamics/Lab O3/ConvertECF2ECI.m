function [ECI,V_ECI] = ConvertECF2ECI(x_3,t)
% Inputs: GST is the greenich sidereal time in degrees.
%   X_O is the initial radius and velocity vectors concatonated
    GST = 99.9595;
theta_G = deg2rad(GST);
    omega_vector = [0;0;0.72921158553*10^(-4)]; %rotation of earth
    theta = theta_G + norm(omega_vector)*t ;
    
    %transfermation matrix 
    Q = [cos(theta) sin(theta) 0;...
        -sin(theta) cos(theta) 0;...
            0           0      1];
        
    radius_ECI = [x_3(1); x_3(2); x_3(3)];
    velocity_ECI = [x_3(4); x_3(5); x_3(6)];
    %use transformation matrix to convert frames
    transformed_r = Q'*radius_ECI;
    transformed_v = Q'*velocity_ECI + cross(omega_vector,transformed_r);
    %fill vectors
    ECI = zeros(1,3);
    ECI(1) = transformed_r(1);
    ECI(2) = transformed_r(2);
    ECI(3) = transformed_r(3);
   
    V_ECI = zeros(1,3);
    V_ECI(1) = transformed_v(1);
    V_ECI(2) = transformed_v(2);
    V_ECI(3) = transformed_v(3);
    

    




end