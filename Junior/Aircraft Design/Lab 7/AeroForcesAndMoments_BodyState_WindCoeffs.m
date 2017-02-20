function [aero_forces,aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state, aircraft_surfaces, wind_inertial, density, aircraft_parameters)

% Purpose: Get the aerodynamic force and moments from the aircraft state
% vector, surfaces, and aircraft parameters.

% Inputs:
%   -aircraft_state = [xi, yi, zi, roll, pitch, yaw, u, v, w, p, q, r]
%   -aircraft_surfaces = [de da dr dt];
%   -aircraft_parameters = various set constant parameters for the aircraft
%       given in recuv_tempest.m
%   -density = density of surrounding air [kg/m^3]
%   -wind_inertial = wind velocity vector in inertial coordinates

% Outputs:
%   -aero_forces = [X Y Z]'; force components in body x,y,z Coordinates
%   -aero_moments = [L M N]'; moment components in body x,y,z Coordinates

% Functions Used:
%   -AirRelativeVelocityVectorToWindAngles

% Lift and Drag are calculated in Wind Frame then rotated to body frame
% Thrust is given in Body Frame
% Sideforce calculated in Body Frame


%%% redefine states and inputs for ease of use

% For Problem 3b
% density = 1.0466;

ap = aircraft_parameters;
S = ap.S;
height = -aircraft_state(3,1);
u = aircraft_state(7,1);
v = aircraft_state(8,1);
w = aircraft_state(9,1);
roll = aircraft_state(4,1);
pitch = aircraft_state(5,1);
yaw = aircraft_state(6,1);
euler = [roll pitch yaw]';
v_b = [u v w]';
w_e = wind_inertial;
w_b = TransformFromInertialToBody(w_e , euler);
AirrelativeV = v_b - w_b;
wind_angles = AirRelativeVelocityVectorToWindAngles(AirrelativeV);
V = wind_angles(1);
beta = wind_angles(2);
alpha = wind_angles(3);

p = aircraft_state(10,1)*ap.b/(2*V);
q = aircraft_state(11,1)*ap.c/(2*V);
r = aircraft_state(12,1)*ap.b/(2*V);

de = aircraft_surfaces(1);
da = aircraft_surfaces(2);
dr = aircraft_surfaces(3);
dt = aircraft_surfaces(4);



%%% Determine aero force coefficients (CL, CD, CT, CY)
CL = ap.CL0 + ap.CLalpha*alpha + ap.CLq*q + ap.CLde*de;
CD = ap.CDmin + ap.K*CL^2;

CY = ap.CYbeta*beta + ap.CYp*p + ap.CYr*r + ap.CYda*da + ap.CYdr*dr;

CT = 2*(ap.Sprop/ap.S)*ap.Cprop*(dt/V^2)*(V + dt*(ap.kmotor - V))*(ap.kmotor - V);


%%% Convert CL, CD, CT into body coordinate coefficients CX and CZ
CX = CT - CD*cos(alpha) + CL*sin(alpha);
CZ = -CD*sin(alpha) - CL*cos(alpha);

%%% Determine aero forces from coeffficients 
Q = (1/2)*density*V^2;
X = S*Q*CX;
Y = S*Q*CY;
Z = S*Q*CZ;


aero_forces = [X Y Z]';


%%% Determine aero moment coefficients
Cl = ap.Clbeta*beta + ap.Clp*p + ap.Clr*r + ap.Clda*da + ap.Cldr*dr;
Cm = ap.Cm0 + ap.Cmalpha*alpha + ap.Cmq*q + ap.Cmde*de;
Cn = ap.Cnbeta*beta + ap.Cnp*p + ap.Cnr*r + ap.Cnda*da + ap.Cndr*dr;


%%% Determine aero moments from coeffficients

L = ap.b * S * Q * Cl;
M = ap.c * S * Q * Cm;
N = ap.b * S * Q * Cn;
aero_moments = [L M N]';


