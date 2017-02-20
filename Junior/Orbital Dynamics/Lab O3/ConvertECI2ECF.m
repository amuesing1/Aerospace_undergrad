function [X_0_ECF] = ConvertECI2ECF(X_0,GST)
% Inputs: GST is the greenich sidereal time in degrees.
%   X_O is the initial radius and velocity vectors concatonated
    theta_G = deg2rad(GST);
    omega_vector = [0;0;0.72921158553*10^(-4)]; %rotation of earth
    theta = theta_G + norm(omega_vector);
    
    %transfermation matrix 
    Q = [cos(theta) sin(theta) 0;...
        -sin(theta) cos(theta) 0;...
            0           0      1];
        
    radius_ECI = [X_0(1); X_0(2); X_0(3)];
    velocity_ECI = [X_0(4); X_0(5); X_0(6)];
    
    transformed_r = Q*radius_ECI;
    transformed_v = Q*velocity_ECI - cross(omega_vector,transformed_r);
    
    X_0_ECF(1) = transformed_r(1);
    X_0_ECF(2) = transformed_r(2);
    X_0_ECF(3) = transformed_r(3);
    
    X_0_ECF(4) = transformed_v(1);
    X_0_ECF(5) = transformed_v(2);
    X_0_ECF(6) = transformed_v(3);
    

    

end