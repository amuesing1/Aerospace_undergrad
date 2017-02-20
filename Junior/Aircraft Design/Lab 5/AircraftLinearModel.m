%Jeremy Muesing
% Stuff

function [ Aad, Bad, Ayaw, Byaw ] = AircraftLinearModel( trim_state, trim_inputs, aircraft_parameters )

ap=aircraft_parameters;
g=9.81; %m/s^2
kappa=(4.2*10^(-5)) * 3.28084; %1/m
[density,~,~,~,~,~]=stdatmo(-trim_state(3)); %kg/m^3
u_0=sqrt(trim_state(7)^2 + trim_state(9)^2);
theta_0=trim_state(5);

%from aircraft_parameters
Iy=aircraft_parameters.Iy;
m=aircraft_parameters.m;

%constants
Cmu=0;
Czu=0;
CW0=ap.m*g/(0.5*density*u_0^2*ap.S);
CL0=CW0*cos(theta_0);
CD0=ap.CDmin+ap.K*CL0^2;
Czalpha=-CD0-ap.CLalpha;
Czalphadot=-ap.CLalphadot;
deltat0=trim_inputs(4);
Cxu=2*(ap.Sprop/ap.S)*ap.Cprop*(ap.kmotor/u_0)*deltat0*(2*deltat0-1-((2*...
    deltat0*ap.kmotor)/u_0));
Cxalpha=CL0*(1-2*ap.K*ap.CLalpha);
Czq=-ap.CLq;

%dimentional derivatives
Gamma=ap.Ix*ap.Iz-ap.Ixz^2;
Gamma3=ap.Iz/Gamma;
Gamma4=ap.Ixz/Gamma;
Gamma8=ap.Ix/Gamma;

L_p=.25*density*u_0*ap.b^2*ap.S*ap.Clp;
L_r=.25*density*u_0*ap.b^2*ap.S*ap.Clr;
L_v=.5*density*u_0*ap.b*ap.S*ap.Clbeta;

M_q=.25*density*ap.c^2*u_0*ap.S*ap.Cmq;
M_u=.5*density*u_0*ap.S*ap.c*Cmu;
M_w=.5*density*u_0*ap.S*ap.c*ap.Cmalpha;
M_w_dot=.25*density*ap.c^2*ap.S*ap.Cmalphadot;
M_z=0;

N_p=.25*density*u_0*ap.b^2*ap.S*ap.Cnp;
N_r=.25*density*u_0*ap.b^2*ap.S*ap.Cnr;
N_v=.5*density*u_0*ap.b*ap.S*ap.Cnbeta;

X_u=density*u_0*ap.S*CW0*sin(theta_0)+.5*density*u_0*ap.S*Cxu;
X_w=.5*density*u_0*ap.S*Cxalpha;
X_z=0;

Y_p=.25*density*u_0*ap.b*ap.S*ap.CYp;
Y_r=.25*density*u_0*ap.b*ap.S*ap.CYr;
Y_v=.5*density*u_0*ap.S*ap.CYbeta;

Z_q=.25*density*ap.c*u_0*ap.S*Czq;
Z_u=-density*u_0*ap.S*CW0*cos(theta_0)+.5*density*u_0*ap.S*Czu;
Z_w=.5*density*u_0*ap.S*Czalpha;
Z_w_dot=.25*density*ap.c^2*ap.S*Czalphadot;
Z_z=-ap.m*g*kappa;


%%Longitudinal Matrix

Alon = [X_u/ap.m X_w/ap.m 0 -g*cos(theta_0);...
    Z_u/(ap.m-Z_w_dot) Z_w/(ap.m-Z_w_dot) (Z_q + ap.m*u_0)/(ap.m - Z_w_dot)...
    -ap.m*g*sin(theta_0)/(ap.m-Z_w_dot);1/ap.Iy*(M_u + ((M_w_dot*Z_u)/(ap.m - Z_w_dot)))...
    1/ap.Iy*(M_w + ((M_w_dot*Z_w)/(ap.m-Z_w_dot))) 1/ap.Iy*(M_q + ((M_w_dot*(Z_q + ap.m*u_0))/(ap.m-Z_w_dot)))...
    -M_w_dot*ap.m*g*sin(theta_0)/(ap.Iy*(ap.m-Z_w_dot));
    0 0 1 0];
DeltaX_E = zeros(4,1);
DeltaZ_E = [X_z/ap.m; Z_z/ap.m; 1/ap.Iy*(M_z + ((M_w_dot*Z_z)/(ap.m - Z_w_dot))); 0];

Aad = [Alon, DeltaX_E, DeltaZ_E; ...
       1 0 0 0 0 0;...
       0 1 0 -u_0 0 0];
Bad = zeros(6,2);

%%Lateral Matrix

Alat = [Y_v/ap.m Y_p/ap.m ((Y_r/ap.m) - u_0) g*cos(theta_0);...
    Gamma3*L_v+Gamma4*N_v Gamma3*L_p+Gamma4*N_p Gamma3*L_r+Gamma4*N_r 0;...
    Gamma4*L_v+Gamma8*N_v Gamma4*L_p+Gamma8*N_p Gamma4*L_r+Gamma8*N_r 0;...
    0 1 tan(theta_0) 0];
Ayaw = [Alat zeros(4,2);...
    0 0 sec(theta_0) 0 0 0;...
    1 0 0 0 u_0*cos(theta_0) 0];

Byaw = zeros(6,2);





end

