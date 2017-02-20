function [Aad, Bad, Ayaw, Byaw, Alon, Alat] = AircraftLinearModel(trim_state, trim_inputs, aircraft_parameters)
% Purpose: Function finds the longitudinal stability and lateral stability
% derivative matrices so that the eigen values and eigen vectors of the
% matrices can be found. From the eigen values and eigen vectors the modes
% of the aircraft can be found and modelled.
% Inputs: 
%   Trim State: the state of the aircraft initially in trim
%   Trim Inputs: the control surfaces of the aircraft in trim
%   Aircraft parameters: the recuv or modeflier characteristics
% Ouputs: 
%   Aad: The longitudinal matrix augmented to account for air-density
%   vertical gradient
%   Bad: 6x2 zero matrix
%   Ayaw: lateral matrix augmented with yaw and y-perturbations
% Written By: Corrina Briggs, Jaevyn Faulk, Antoine Steiblen
% Created 3/14/16


ap = aircraft_parameters; %simplify
% Set definitions needed for equations in Longitudinal and Lateral matrices
% Many definitions given in Modeflier or Tempest files
e = ap.e; %oswald efficiency
AR = ap.AR; %aspect ratio
b = ap.b; %wingspan
W = ap.W;
m = ap.m;
g = 9.81;
S = ap.S;
c_bar = ap.c;
C_L_alpha_dot = ap.CLalphadot;
u_0 = norm(trim_state(7:9));
density = stdatmo(abs(trim_state(3))); %find density with height
rho = density;
V = trim_state(7:9);
v_magnitude = norm(V);
C_L_alpha = ap.CLalpha; % Coefficient of lift with respect to AoA
pitch = trim_state(5);
C_L_trim = (W*cos(pitch))/(0.5*rho*v_magnitude^2*S);
C_W_0 = W/(0.5*rho*v_magnitude^2*S);
K =  ap.K; %C_L_trim/(pi*AR*e);
C_x_alpha = C_L_trim*(1-2*K*C_L_alpha);
X_w = 0.5*rho*u_0*S*C_x_alpha;
C_y_beta = ap.CYbeta;
C_y_p = ap.CYp;
C_y_r = ap.CYr;
C_l_beta = ap.Clbeta;
C_l_p = ap.Clp;
C_l_r = ap.Clr;
C_n_beta = ap.Cnbeta;
C_n_p = ap.Cnp;
C_n_r = ap.Cnr;
Iy = ap.Iy;
Ix = ap.Ix;
Iz = ap.Iz;
Ixz = ap.Ixz;
Gamma_0 = Ix*Iz - Ixz^2;
Gamma_1 = (Ixz*(Ix-Iy+Iz))/Gamma_0;
Gamma_2 = (Iz*(Iz-Iy)+Ixz^2)/Gamma_0;
Gamma_3 = Iz/Gamma_0;
Gamma_4 = Ixz/Gamma_0;
Gamma_5 = (Iz-Ix)/Iy;
Gamma_6 = Ixz/Iy;
Gamma_7 = (Ix*(Ix-Iy)+Ixz^2)/Gamma_0;
Gamma_8 = Ix/Gamma_0;
M_z = 0;
X_z = 0;
I_primex = 1/Gamma_3;
I_primez = 1/Gamma_8;
I_primezx = Gamma_4;

kappa_feet = 4.2e-5; % converting Kappa into metric
kappa = kappa_feet / 0.3048;% meters
Z_z = -W*kappa;



%finding Z_w_dot (the change in the body z-direction with respect to the
%rate of change in the w component of speed
C_z_alpha_dot = C_L_alpha_dot;
Z_w_dot = 0.25*rho*c_bar*S*C_z_alpha_dot;

%finding the wind angles
Wind_Angles = AirRelativeVelocityVectorToWindAngles([trim_state(7), trim_state(8), trim_state(9)]);
V = Wind_Angles(1);
Beta = Wind_Angles(2);
Alpha = Wind_Angles(3);

% Coefficients necessary for X and Z derivatives
d_t0 = trim_inputs(4);
C_w0 = ap.W/(.5 * density * v_magnitude^2 * ap.S);
C_D0 = ap.CDmin + ap.K*C_L_trim^2;
theta_0 = trim_state(5);

% X and Z derivatives and coefficients necessary for complete equations
C_x_u = 2*(ap.Sprop/S)*ap.Cprop*(ap.kmotor/u_0)*d_t0*(2*d_t0 - 1 - (2*d_t0*ap.kmotor)/u_0);
X_u = density*u_0*ap.S*C_w0*sin(theta_0) + (1/2)*density*u_0*S*C_x_u;
C_z_u = 0;
Z_u = rho*u_0*S*(-C_W_0*cos(theta_0))+0.5*rho*u_0*S*C_z_u;
C_Z_alpha = -C_D0 - ap.CLalpha;
Z_w = (1/2)*density*u_0*ap.S*C_Z_alpha;
Z_q = (1/4)*density*u_0*ap.c*S*(-ap.CLq);

% M derivatives
M_u = 0;
M_w = (1/2)*density*u_0*ap.S*ap.c*ap.Cmalpha;
M_q = (1/4)*density*u_0*(ap.c^2)*S*ap.Cmq;
M_w_dot = (1/4)*density*u_0*(ap.c^2)*ap.S*ap.Cmalphadot;

%%%%%%%%%%%%%%%%%%%% Longitudinal Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%
% This may come up differently on paper. It was formated to be easily
% examined for errors in matlab
Alon = [(X_u/m)                                      , (X_w/m)                                      , 0                                                      , -ap.g*cos(theta_0);...
        Z_u/(m - Z_w_dot)                            , Z_w/(m - Z_w_dot)                            , (Z_q + m*u_0)/(m - Z_w_dot)                            , (-m*ap.g*sin(theta_0))/(m - Z_w_dot);...
        (1/ap.Iy)*(M_u + (M_w_dot*Z_u)/(m - Z_w_dot)), (1/ap.Iy)*(M_w + (M_w_dot*Z_w)/(m - Z_w_dot)), (1/ap.Iy)*(M_q + (M_w_dot*(Z_q + m*u_0))/(m - Z_w_dot)), -(M_w_dot*ap.W*sin(theta_0)/(ap.Iy*(m -Z_w_dot)));...
        0                                            , 0                                            , 1                                                      , 0];


% for the modified matrix accounting for air density gradient
Alon_mod = zeros(6);

Alon_mod(1:4,1:4) = Alon;

Alon_mod(5,1)=1;Alon_mod(6,2)=1;Alon_mod(6,4)=-u_0;
modified_column_Alon = [X_z/m;Z_z/m;...
    (1/Iy)*(M_z + (M_w_dot*Z_z)/(m-Z_w_dot));0;0;0];
Alon_mod(:,6) = modified_column_Alon;


%%%%%%%%%%% lateral matrix %%%%%%%%%%%%%%%%%%%%% 
Y_v = 0.5*rho*u_0*S*C_y_beta;
Y_p = 0.25*rho*u_0*b*S*C_y_p;
Y_r = 0.25*rho*u_0*b*S*C_y_r;
L_v = 0.5*rho*u_0*b*S*C_l_beta;
L_p = 0.25*rho*u_0*b^2*S*C_l_p;
L_r = 0.25*rho*u_0*b^2*S*C_l_r;
N_v = 0.5*rho*u_0*b*S*C_n_beta;
N_p = 0.25*rho*u_0*b^2*S*C_n_p;
N_r = 0.25*rho*u_0*b^2*S*C_n_r;

Alat = [     Y_v/m             ,      Y_p/m             ,       Y_r/m - u_0      ,  g*cos(theta_0);...
        Gamma_3*L_v+Gamma_4*N_v, Gamma_3*L_p+Gamma_4*N_p, Gamma_3*L_r+Gamma_4*N_r,  0;             ...
        Gamma_4*L_v+Gamma_8*N_v, Gamma_4*L_p+Gamma_8*N_p, Gamma_4*L_r+Gamma_8*N_r,  0;             ...
               0               ,         1              ,       tan(theta_0)     ,  0;             ...
    
];
 
%for the modified Lateral matrix accounting for yaw
Alat_mod = zeros(6);
Alat_mod(1:4,1:4) = Alat;
Alat_mod(6,1)=1;Alat_mod(5,3)=sec(theta_0);Alat_mod(6,5)=(u_0*cos(theta_0));


% Dimensional Control Derivatives
C_x_deltae = (ap.CLde*sin(theta_0) - ap.CDde*cos(theta_0));
C_x_deltap = (ap.kmotor - u_0)*((2*ap.Sprop)/S)*(ap.Cprop/u_0)*(1 + d_t0*(ap.kmotor - u_0));

C_z_deltae = -(ap.CLde*cos(theta_0) + ap.CDde*sin(theta_0));
C_z_deltap = 0;


X_deltae = C_x_deltae*.5*density*u_0^2*S;
X_deltap = C_x_deltap*.5*density*u_0^2*S;
Y_deltaa = ap.CYda*.5*density*u_0^2*S;
Y_deltar = ap.CYdr*.5*density*u_0^2*S;
M_deltae = ap.Cmde*.5*density*u_0^2*S*c_bar;
M_deltap = 0;

Z_deltae = C_z_deltae*.5*density*u_0^2*S;
Z_deltap = C_z_deltap*.5*density*u_0^2*S;
L_deltaa = ap.Clda*.5*density*u_0^2*S*b;
L_deltar = ap.Cldr*.5*density*u_0^2*S*b;
N_deltaa = ap.Cnda*.5*density*u_0^2*S*b;
N_deltar = ap.Cndr*.5*density*u_0^2*S*b;

% Blon Matrix

Blon = [X_deltae/m, X_deltap/m;
        Z_deltae/(m - Z_w_dot), Z_deltap/(m - Z_w_dot);
        (M_deltae/ap.Iy) + (M_w_dot*Z_deltae)/(ap.Iy*(m - Z_w_dot)), (M_deltap/ap.Iy) + (M_w_dot*Z_deltap)/(ap.Iy*(m - Z_w_dot));
        0,0;
        0,0;
        0,0];
    
% Blat Matrix

Blat = [Y_deltaa/m, Y_deltar/m;
        (L_deltaa/I_primex) + I_primezx*N_deltaa, (L_deltar/I_primex) + I_primezx*N_deltar;
        I_primezx*L_deltaa + (N_deltaa/I_primez), I_primezx*L_deltar + (N_deltar/I_primez);
        0,0;
        0,0;
        0,0];
    
        


% matrices to be output
Aad = Alon_mod;
Ayaw = Alat_mod;
Bad = Blon;
Byaw = Blat;

end