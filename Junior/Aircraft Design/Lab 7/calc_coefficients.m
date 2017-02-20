function [M_deltae, X_w, m, M_w, X_deltae, g, u_0, X_deltap, Z_u, M_u, Z_w, X_u] = calc_coefficients (trim_state, trim_inputs, aircraft_parameters)

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

curly_Y = Y_deltar/m;
%curly_N_deltar = 

end